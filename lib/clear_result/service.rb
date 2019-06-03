# frozen_string_literal: true

module ClearResult
  class Service
    include Dry::Transaction
    include ClearResult::Result

    class << self
      attr_accessor :context_class

      def call(*args)
        new.call(*args)
      end

      def build_context
        self.context_class = ClearResult::ContextBuilder.call
      end

      def context(name, type, as: :option)
        context_class.class_eval do
          send(as, name, type)
        end
      end

      def inherited(base)
        base.class_eval do
          attr_reader :context

          build_context

          step :initialize_context

          private

          def initialize_context(*args)
            @context = self.class.context_class.new(*args)
            context.service = self

            success(context)
          end
        end
      end
    end
  end
end
