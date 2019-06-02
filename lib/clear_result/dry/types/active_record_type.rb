# frozen_string_literal: true

module Dry
  module Types
    class ActiveRecordLoader
      DEFAULT_KEY = 'model'

      attr_reader :base_key

      def initialize(base_key = nil)
        @base_key = base_key || DEFAULT_KEY
      end

      def call
        models.each do |klass|
          key = model_key(klass)
          definition = model_definition(klass)

          Dry::Types.register("#{base_key}.#{key}", definition)
        end
      end

      private

      def models
        @models ||= ActiveRecord::Base.connection.tables.map { |table| table.classify.safe_constantize }.compact
      end

      def model_key(klass)
        klass.name.underscore.gsub('/', '.')
      end

      def model_definition(klass)
        Dry::Types::Nominal.new(klass).constrained(type: klass)
      end
    end
  end
end
