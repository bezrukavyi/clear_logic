# frozen_string_literal: true

module ClearLogic
  class FailureError
    attr_reader :status

    def initialize(status)
      @status = status
    end
  end
end
