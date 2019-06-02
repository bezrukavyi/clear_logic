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
      define_method(error_type) do |**result|
        result[:error] ||= error_type

        failure(result)
      end
    end

    def success(**result)
      Dry::Monads.Success(success_wrap(result))
    end

    def success_wrap(result)
      result
    end

    def failure(**result)
      Dry::Monads.Failure(result)
    end
  end
end
