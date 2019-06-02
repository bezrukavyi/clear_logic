# frozen_string_literal: true

module ClearResult
  class ContextBuilder
    def self.call(name)
      klass = Class.new do
        extend Dry::Initializer

        def [](key)
          @additional ||= {}
          @additional[key]
        end

        def []=(key, value)
          @additional ||= {}
          @additional[key] = value
        end
      end

      Object.const_defined?(name) ? Object.const_get(name) : Object.const_set(name, klass)
    end
  end
end
