# frozen_string_literal: true

module ClearLogic
  module Result
    DEFAULT_ERRORS = %i[
      unauthorized
      forbidden
      not_found
      invalid
      system
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
      Dry::Monads.Success(context)
    end

    def exit_success(context)
      context.exit_success = true
      success(context)
    end

    def failure(context)
      Dry::Monads.Failure(context)
    end
  end
end
