# frozen_string_literal: true

module ClearLogic
  class Service
    include Dry::Transaction
    include ClearLogic::Result

    class << self
      attr_accessor :context_class, :logger_instance, :log_options

      def call(*args)
        new.call(*args)
      end

      def build_context
        self.context_class = ClearLogic::ContextBuilder.call
      end

      def context(name, type, **options)
        context_class.class_eval do
          method = options.delete(:as) || :option
          send(method, name, type, **options)
        end
      end

      def logger(logger_klass, log_all: false, log_path: nil)
        self.log_options = { log_all: log_all }
        self.logger_instance = ClearLogic::Logger::Adapter.new(logger_klass, log_path).logger
      end

      def inherited(base)
        base.class_eval do
          attr_reader :context

          build_context

          logger ClearLogic::Logger::Default

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
