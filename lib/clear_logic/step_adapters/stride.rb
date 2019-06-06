# frozen_string_literal: true

require 'dry/transaction/errors'

module ClearLogic
  module StepAdapters
    class Stride
      include Dry::Monads::Result::Mixin
      include ClearLogic::Result

      attr_reader :operation, :options, :args, :context

      def call(operation, options, args)
        @operation = operation
        @options = options
        @args = args
        @context = args.flatten.first

        options[:rescue] ||= {}

        context.step = options[:step_name]

        return success(context) if context.exit_success?

        result = operation.call(context)

        log_result

        return result if result.success?

        failure_method
      rescue *Array(options[:rescue].keys) => e
        catch_error(e)
      end

      def catch_error(error)
        context.catched_error = error

        log_result

        rescue_method = options[:rescue][error.class]
        rescue_method ? context.service.send(rescue_method, context) : failure(context)
      end

      def log_result
        return unless options[:log] || context.service.class.logger_options[:log_all]

        context.service.class.logger_instance.info(context)
      end

      def failure_method
        options[:failure] ? context.service.send(options[:failure], context) : failure(context)
      end
    end
  end
end

Dry::Transaction::StepAdapters.register(:stride, ClearLogic::StepAdapters::Stride.new)
