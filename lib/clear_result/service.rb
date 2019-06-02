# frozen_string_literal: true

module ClearResult
  class Service
    include Dry::Transaction
    include ClearResult::Type

    class << self
      attr_accessor :context_class

      def call(*args)
        new.call(*args)
      end

      def inherited(base)
        base.class_eval do
          attr_reader :context

          context

          tee :init_context

          private

          def init_context(*args)
            @context = self.class.context_class.new(*args)
          end
        end
      end

      def context(&block)
        self.context_class = ClearResult::ContextBuilder.call("#{name}Context")

        context_class.class_eval(&block) if block_given?
      end
    end
  end
end
