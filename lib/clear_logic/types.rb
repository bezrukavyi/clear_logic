# frozen_string_literal: true

module ClearLogic
  class Types
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def register(base_key)
      Dry::Types.register(key, define)
    end

    def define
      Dry::Types::Nominal.new(klass).constrained(type: klass)
    end

    def klass_key(base_key, klass)
      [base_key, Dry::Inflector.new.underscore(klass.name).gsub('/', '.')].compact.join('.')
    end
  end
end
