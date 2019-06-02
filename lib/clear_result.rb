# frozen_string_literal: true

require 'dry-transaction'
require 'dry-matcher'
require 'dry-monads'

require 'clear_result/version'
require 'clear_result/version'
require 'clear_result/type'
require 'clear_result/matcher'
require 'clear_result/service'

module ClearResult
  class Error < StandardError; end
end