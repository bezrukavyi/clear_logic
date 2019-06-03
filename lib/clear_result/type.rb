# frozen_string_literal: true

module ClearResult
  module Type
    private

    ERRORS = %i[
      unauthorized
      forbidden
      not_found
      invalid
      system
    ].freeze

    ERRORS.each do |error_type|
      define_method(error_type) do |context|
        context[:error] ||= error_type

        failure(context)
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
