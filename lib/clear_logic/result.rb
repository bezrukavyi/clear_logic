# frozen_string_literal: true
Dry::Monads::Result::Success.class_eval do
  alias context success
end

Dry::Monads::Result::Failure.class_eval do
  alias context failure
end

module ClearLogic
  module Result
    DEFAULT_ERRORS = %i[
      unauthorized
      forbidden
      not_found
      invalid
    ].freeze

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
      Dry::Monads::Result::Success.new(context)
    end

    def exit_success(context)
      context.exit_success = true
      success(context)
    end

    def failure(context)
      Dry::Monads::Result::Failure.new(context)
    end
  end
end
