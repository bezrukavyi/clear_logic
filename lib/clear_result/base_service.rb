class BaseService < ClearResult::Service
  context do
    option :params, Dry::Types['strict.hash'].default({})
  end
end
