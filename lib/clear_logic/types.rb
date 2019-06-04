# frozen_string_literal: true

module ClearLogic
  class Types
    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def register(key = klass_key)
      Dry::Types.register(key, define)
    end

    def define
      Dry::Types::Nominal.new(klass).constrained(type: klass)
    end

    def klass_key
      klass.name.underscore.gsub('/', '.')
    end
  end
end
