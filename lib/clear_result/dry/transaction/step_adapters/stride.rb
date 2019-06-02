# frozen_string_literal: true

require 'dry/transaction/errors'

module Dry
  module Transaction
    class StepAdapters
      class Stride
        include Dry::Monads::Result::Mixin

        def call(operation, options, args)
          options[:rescue] ||= {}

          unless options[:catch]
            raise MissingCatchListError, options[:step_name]
          end

          rollback
          failure_result

          result = operation.call(*args)
          Success(result)
        rescue *Array(options[:rescue]) => e
          e = options[:raise].new(e.message) if options[:raise]
          Failure(e)
        end
      end

      register :stride, Stride.new
    end
  end
end
