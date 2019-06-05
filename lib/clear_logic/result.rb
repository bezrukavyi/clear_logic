# frozen_string_literal: true

module ClearLogic
  module Result
    DEFAULT_ERRORS = %i[
      unauthorized
      forbidden
      not_found
      invalid
    ].freeze

    class Success < Dry::Monads::Result::Success
      alias_method :value, :success
    end

    class Failure < Dry::Monads::Result::Failure
      alias_method :value, :failure
    end

    private

    def self.included(base)
      base.extend(ClassMethdos)

      base.errors(*DEFAULT_ERRORS)
    end

    module ClassMethdos
      def errors(*errors_methods)
        errors_methods.each do |error_type|
          define_method(error_type) do |context|
            context.failure_error ||= ClearLogic::FailureError.new(error_type)

            failure(context)
          end

          private error_type
        end
      end
    end

    def success(context)
      Success.new(context)
    end

    def exit_success(context)
      context.exit_success = true
      success(context)
    end

    def failure(context)
      Failure.new(context)
    end
  end
end
