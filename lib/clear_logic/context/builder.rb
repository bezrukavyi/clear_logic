# frozen_string_literal: true

module ClearLogic
  class ContextBuilder
    def self.call
      Class.new do
        extend ::Dry::Initializer

        attr_reader :args
        attr_accessor :catched_error, :failure_error, :service, :exit_success, :step

        def initialize(*args)
          @args = args
          super(*args)
        end

        def [](key)
          @additional_opts ||= {}
          @additional_opts[key]
        end

        def []=(key, value)
          @additional_opts ||= {}
          @additional_opts[key] = value
        end

        def exit_success?
          exit_success == true
        end

        def catched_error?
          !catched_error.nil?
        end

        def failure_error?
          !failure_error.nil?
        end

        def to_h
          {
            catched_error: catched_error,
            failure_error: failure_error,
            service: service.class,
            exit_success: exit_success,
            step: step,
            options: @additional_opts,
            args: args
          }
        end
      end
    end
  end
end
