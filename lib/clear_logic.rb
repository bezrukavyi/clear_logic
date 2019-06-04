# frozen_string_literal: true

require 'logger'
require 'json'
require 'pry'

require 'dry-types'
require 'dry-initializer'
require 'dry-transaction'
require 'dry-matcher'
require 'dry-monads'

require 'clear_logic/logger/default'
require 'clear_logic/logger/adapter'
require 'clear_logic/errors/failure_error'
require 'clear_logic/errors/catched_error'
require 'clear_logic/version'
require 'clear_logic/types'
require 'clear_logic/result'
require 'clear_logic/step_adapters/stride'
require 'clear_logic/matcher'
require 'clear_logic/context/builder'
require 'clear_logic/service'

module ClearLogic
end
