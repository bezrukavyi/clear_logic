# frozen_string_literal: true

class BaseService < ClearResult::Service
  context :params, Dry::Types['strict.hash']

  errors :invalid, :not_found

  stride :test, rescue: { ArgumentError => :failure_step }, failure: :failure_step
  stride :next_step

  # stride :another_test
  # stride :failure_step
  # stride :another_test

  def test(context)
    failure(context)
  end

  def failure_step(context)
    binding.pry
    success(context)
  end

  def next_step(context)
    binding.pry
    success(context)
  end
end
