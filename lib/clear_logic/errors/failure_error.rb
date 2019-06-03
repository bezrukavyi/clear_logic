# frozen_string_literal: true

module ClearLogic
  class FailureError
    ERRORS = %i[
      unauthorized
      forbidden
      not_found
      invalid
      system
    ].freeze

    attr_reader :status

    def initialize(status)
      @status = status
    end
  end
end
