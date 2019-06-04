class BaseService < ClearLogic::Service
  context :info, Dry::Types['strict.string']

  errors :custom_error

  stride :test, rescue: { ArgumentError => :raise_step }, failure: :failure_step
  stride :next_step, log: true

  def test(context)
    context[:cdasdasd] = :dasdasdasd
    custom_error(context)
  end

  def raise_step(context)
    context[:cdasdasd]

    failure(context)
  end

  def failure_step(context)
    success(context)
  end

  def next_step(context)
    success(context)
  end
end
