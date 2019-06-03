# frozen_string_literal: true

module ClearResult
  class ContextBuilder
    ADDITIONAL = %i[rescue_error failure_error service].freeze

    def self.call
      Class.new do
        extend ::Dry::Initializer

        attr_reader :options

        def [](key)
          @options ||= {}
          @options[key]
        end

        def []=(key, value)
          @options ||= {}
          @options[key] = value
        end

        ADDITIONAL.each do |name|
          define_method("#{name}=") do |error|
            self[name] = error
          end

          define_method(name) do
            self[name]
          end
        end
      end
    end
  end
end
