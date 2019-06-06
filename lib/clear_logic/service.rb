# frozen_string_literal: true

module ClearLogic
  class Service
    include Dry::Transaction
    include ClearLogic::Result

    class << self
      attr_accessor :context_class, :logger_instance, :logger_options,
                    :logger_class

      def call(*args)
        new.call(args)
      end

      def build_context
        self.context_class = ClearLogic::ContextBuilder.call
      end

      def context(name, type = nil, **options)
        context_class.class_eval do
          method = options.delete(:as) || :option
          send(method, name, type, **options)
        end
      end

      def logger(logger_class, log_all: false, log_path: nil)
        self.logger_options = { log_all: log_all, log_path: log_path }
        self.logger_class = logger_class
        self.logger_instance = ClearLogic::Logger::Adapter.new(self).logger
      end

      def inherited(base)
        base.class_eval do
          attr_reader :context

          build_context

          logger ClearLogic::Logger::Default

          step :initialize_context

          private

          def initialize_context(args)
            @context = self.class.context_class.new(*args.flatten)
            context.service = self

            success(context)
          end
        end
      end
    end
  end
end
