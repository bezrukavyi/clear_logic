# frozen_string_literal: true

module ClearLogic
  class ContextBuilder
    def self.call
      Class.new do
        extend ::Dry::Initializer

        attr_reader :options
        attr_accessor :rescue_error, :failure_error, :service, :exit_success

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
      end
    end
  end
end
