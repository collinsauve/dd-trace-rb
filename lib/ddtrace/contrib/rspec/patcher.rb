require 'ddtrace/contrib/patcher'
require 'ddtrace/contrib/rspec/example'

module Datadog
  module Contrib
    module RSpec
      # Patcher enables patching of 'rspec' module.
      module Patcher
        include Contrib::Patcher

        module_function

        def target_version
          Integration.version
        end

        def patch
          ::RSpec::Core::Example.send(:include, Example)
          ::RSpec.configure do |config|
            config.after(:suite) do
              # force blocking flush before at_exit shutdown! hook
              Datadog.tracer.writer.worker.flush_data
            end
          end
        end
      end
    end
  end
end
