# frozen_string_literal: true

module ClearResult
  class Service
    include Dry::Transaction
    include ClearResult::Type

    def call(*args)
      super(*args)
    rescue *self.class.exceptions.keys => e
      send(self.class.exceptions[e.class], e.message)
    end

    class << self
      attr_accessor :exceptions

      def call(*args)
        new.call(*args)
      end

      def rescue_callbacks(exceptions = {})
        self.exceptions ||= {}
        self.exceptions.merge!(exceptions)
      end
    end

    rescue_callbacks
  end
end
