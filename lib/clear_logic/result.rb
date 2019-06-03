# frozen_string_literal: true

module ClearLogic
  module Result
    private

    def self.included(base)
      base.extend(ClassMethdos)

      base.errors(*ClearLogic::FailureError::ERRORS)
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

    def failure(context)
      Dry::Monads.Failure(context)
    end
  end
end
