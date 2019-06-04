# frozen_string_literal: true

require 'dry/transaction/errors'

module ClearLogic
  module StepAdapters
    class Stride
      include Dry::Monads::Result::Mixin
      include ClearLogic::Result

      def call(operation, options, args)
        options[:rescue] ||= {}
        context = args.flatten.first
        context.step = operation.operation.name

        return success(context) if context.exit_success?

        result = operation.call(context)

        log_result(context, options)

        return success(result) if result.success?

        failure_method(context, options)
      rescue *Array(options[:rescue].keys) => e
        rescue_error(context, options, e)
      end

      def rescue_error(context, options, error)
        context.rescue_error = ClearLogic::CatchedError.new(error)

        log_result(context, options)

        rescue_method = options[:rescue][error.class]
        rescue_method ? context.service.send(rescue_method, context) : failure(context)
      end

      def log_result(context, options)
        return unless options[:log] || context.service.class.log_options[:log_all]

        context.service.class.logger_instance.info(context)
      end

      def failure_method(context, options)
        options[:failure] ? context.service.send(options[:failure], context) : failure(context)
      end
    end
  end
end

Dry::Transaction::StepAdapters.register(:stride, ClearLogic::StepAdapters::Stride.new)
