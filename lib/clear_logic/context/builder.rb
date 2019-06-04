# frozen_string_literal: true

module ClearLogic
  class ContextBuilder
    def self.call
      Class.new do
        extend ::Dry::Initializer

        attr_reader :options, :args
        attr_accessor :rescue_error, :failure_error, :service, :exit_success, :step

        def initialize(*args)
          @args = args
          super(*args)
        end

        def [](key)
          @options ||= {}
          @options[key]
        end

        def []=(key, value)
          @options ||= {}
          @options[key] = value
        end

        def exit_success?
          exit_success == true
        end

        def rescue_error?
          !rescue_error.nil?
        end

        def failure_error?
          !failure_error.nil?
        end

        def to_h
          {
            rescue_error: rescue_error,
            failure_error: failure_error,
            service: service,
            exit_success: exit_success,
            step: step,
            options: options,
            args: args
          }
        end
      end
    end
  end
end
