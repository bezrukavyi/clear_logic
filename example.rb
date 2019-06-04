class BaseService < ClearLogic::Service
  context :store, Dry::Types['service.store']

  errors :custom_error

  stride :test, rescue: { ArgumentError => :raise_step }, failure: :failure_step
  stride :next_step
  stride :next_step
  stride :next_step
  stride :next_step

  def test(context)
    context.user
    context.params

    custom_error(context)
    context[:cdasdasd] = :dasdasdasd
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
