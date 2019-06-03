# frozen_string_literal: true

module ClearLogic
  class CatchedError
    attr_reader :error

    def initialize(error)
      @error = error
    end
  end
end
