# frozen_string_literal: true

module ClearResult
  class Types
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def register(base_key = nil)
      key = klass_key(base_key, klass)

      Dry::Types.register(key, define)
    end

    def define
      Dry::Types::Nominal.new(klass).constrained(type: klass)
    end

    private

    def klass_key(base_key, klass)
      [base_key, klass.name.underscore.gsub('/', '.')].compact.join('.')
    end
  end
end
