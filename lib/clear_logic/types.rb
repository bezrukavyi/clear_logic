# frozen_string_literal: true

module ClearLogic
  class Types
    attr_reader :klass, :prefix

    def self.register(*args)
      new(*args).register
    end

    def initialize(klass, prefix: nil)
      @klass = klass
      @prefix = prefix
    end

    def register
      Dry::Types.register(klass_key, define)
    end

    def define
      Dry::Types::Nominal.new(klass).constrained(type: klass)
    end

    def klass_key
      [prefix, Dry::Inflector.new.underscore(klass.name).gsub('/', '.')].compact.join('.')
    end
  end
end
