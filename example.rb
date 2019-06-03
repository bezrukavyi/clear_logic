class BaseService < ClearLogic::Service
  context :params, Dry::Types['strict.hash']

  errors :invalid, :not_found

  stride :test, rescue: { ArgumentError => :raise_step }, failure: :failure_step
  stride :next_step

  def test(context)
    failure(context)
  end

  def raise_step(context)
    failure(context)
  end

  def failure_step(context)
    success(context)
  end

  def next_step(context)
    success(context)
  end
end
