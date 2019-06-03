# frozen_string_literal: true

require 'dry/transaction/errors'

module Dry
  module Transaction
    class StepAdapters
      class Stride
        include Dry::Monads::Result::Mixin
        include ClearResult::Type

        def call(operation, options, args)
          context = args.flatten.first
          service = context.service

          options[:rescue] ||= {}

          result = operation.call(context)

          return success(result) if result.success?

          options[:failure] ? service.send(options[:failure], context) : failure(context)
        rescue *Array(options[:rescue].keys) => e
          context.rescue_error = ClearResult::CatchedError.new(e)
          rescue_method = options[:rescue][e.class]
          rescue_method ? service.send(rescue_method, context) : failure(context)
        end
      end

      register :stride, Stride.new
    end
  end
end
