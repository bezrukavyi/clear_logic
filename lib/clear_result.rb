# frozen_string_literal: true

require 'pry'

require 'dry-types'
require 'dry-initializer'
require 'dry-transaction'
require 'dry-matcher'
require 'dry-monads'

require 'clear_result/errors/failure_error'
require 'clear_result/errors/catched_error'
require 'clear_result/version'
require 'clear_result/dry_types'
require 'clear_result/type'
require 'clear_result/dry/transaction/step_adapters/stride'
require 'clear_result/matcher'
require 'clear_result/context_builder'
require 'clear_result/service'
require 'clear_result/base_service'

module ClearResult
  class Error < StandardError; end
end
