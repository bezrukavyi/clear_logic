# frozen_string_literal: true

module ClearResult
  class ContextBuilder
    def self.call
      Class.new do
        extend ::Dry::Initializer

        def [](key)
          @additional ||= {}
          @additional[key]
        end

        def []=(key, value)
          @additional ||= {}
          @additional[key] = value
        end
      end
    end
  end
end
