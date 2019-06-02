# frozen_string_literal: true

module ClearResult
  module Type
    private

    ERRORS = {
      unauthorized: 401,
      forbidden: 403,
      not_found: 404,
      invalid: 422,
      system: 500
    }.freeze

    RAISE = {
      unauthorized: 401,
      forbidden: 403,
      not_found: 404,
      invalid: 422,
      system: 500
    }.freeze

    ERRORS.each do |error_type, error_status|
      define_method(error_type) do |**result|
        result = result.is_a?(Hash) ? result : { object: result }

        result[:meta] ||= {}
        result[:meta][:type] = error_type
        result[:meta][:status] = error_status

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
      error_type = result.dig(:error, :type)
      wrap_method = "#{error_type}_wrap"
      wrap_result = error_type && respond_to?(wrap_method) ? send(wrap_method, result) : result

      Dry::Monads.Failure(wrap_result)
    end
  end
end
