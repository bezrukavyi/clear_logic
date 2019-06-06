# ClearLogic

Service object based on [dry-rb](https://dry-rb.org/)

## Installation

```ruby
gem 'clear_logic'
```

## Usage

- [Interface](#interface)
- [Types](#types)
- [Context](#context)
- [Stride](#stride)
- [Result](#result)
- [Logger](#logger)
- [Matcher](#matcher)


## Interface

DSL for building class initializer with params and options based on [`dry-initializer`](https://github.com/dry-rb/dry-initializer)

```ruby
class MyService < ClearLogic::Service
  context :name, Dry::Types['strict.string'], as: :param
  context :test, Dry::Types['strict.bool'], default: -> { false }
  
  stride :some_step

  def some_step(context)
    context.name # => first argument
    success(context)
  end
end
```

In console:

```ruby
result = MyService.call('Liskov', test: true)

result.success? # => true
result.context.name # => 'Liskov'
result.context.test # => true
```

```ruby
result = MyService.call('Lenon')

result.success? # => true
result.context.name # => 'Lenon'
result.context.test # => false
```

# Types

You can register own `class` types.

In your initializer:

```ruby
ActiveRecord::Base.connection.tables.map { |x| x.classify.safe_constantize }.compact.each do |model|
  ClearLogic::Types.register(model, prefix: 'model')
end
```

In your initializer:

```ruby
Dry::Types['model.user']
```

## Context

In each step you work with `context`. Context have next methods which are available to you:
- `args`
- `[]`
- `[]=`
- `exit_success?`
- `catched_error?`
- `failure_error?`
- `to_h`

And next accessors:
- `catched_error`
- `failure_error`
- `service`
- `exit_success`
- `step`

```ruby
class MyService < ClearLogic::Service
  context :name, Dry::Types['strict.string'], as: :param
  
  stride :some_step

  def some_step(context)
    fetch_user

    success(context)
  end

  private

  def fetch_user
    context[:user] = User.find_by(name: context.name)
  end
end
```

In console:

```ruby
result = MyService.call('Buscemi')

result.context.name # => 'Buscemi'
result.context.step # => :some_step # return last step
result.context.args # => ['Buscemi']

result.context[:some_option] # => true

result.context.to_h # => {:catched_error=>nil, :failure_error=>nil, :service=>MyService, :exit_success=>nil, :step=>:some_step, :options=>{:some_option=>true}, :args=>['Buscemi']}

result.context.exit_success? # => false
result.context.catched_error? # => false
result.context.failure_error? # => false
```

## Stride

Business transaction DSL based on [`dry-transaction`](https://github.com/dry-rb/dry-transaction)

### Catch failed step

```ruby
class MyService < ClearLogic::Service
  stride :first, failure: :some_rollback
  stride :second

  def first(context)
    # ...
    failure(context)
  end
  
  def second(context)
    # ...
    success(context)
  end

  def some_rollback(context)
    # Do sth if first step is failed
    success(context)
  end
end
```

In console:

```ruby
result = MyService.call

result.success? # => true
```

### Catch specific errors

```ruby
class MyService < ClearLogic::Service
  stride :first
  stride :second, rescue: { StandardError => :some_rescue }

  def first(context)
    # ...
    success(context)
  end
  
  def second(context)
    # ...
    raise StandardError
  end

  def some_rescue(context)
    # Do sth if first step is raised error from `rescue` option
    failure(context)
  end
end
```

In console:

```ruby
result = MyService.call

result.success? # => false
result.context.catched_error? # => true
result.context.catched_error.class # => StandardError
```

### Exit success from process

```ruby
class MyService < ClearLogic::Service
  stride :first
  stride :second, rescue: { StandardError => :some_rescue }

  def first(context)
    context[:test] = 'first'
    exit_success(context)
  end
  
  def second(context)
    context[:test] = 'second'
    success(context)
  end
end
```

In console:

```ruby
result = MyService.call

result.success? # => true
result.context[:test] # => 'first'
result.exit_success? # => true'
```

## Result

Result with status of failed execution based on [`dry-monads`](https://github.com/dry-rb/dry-monads)

### Default errors

Aside from default monads methods `success` and `failure` you have next failure methods which give you status of failed execution:

- `unauthorized`
- `forbidden`
- `not_found`
- `invalid`

```ruby
class MyService < ClearLogic::Service
  stride :first
  stride :second

  def first(context)
    # ...
    not_found(context)
  end
  
  def second(context)
    # If will not be handled
    failure(context)
  end
end
```

In console:

```ruby
result = MyService.call

result.failure? # => false
result.context.failure_error? # => true
result.context.failure_error.status # => :not_found
```

### Custom errors

You also can use own errors

```ruby
class MyService < ClearLogic::Service
  errors :failed_logic

  stride :first
  stride :second

  def first(context)
    # ...
    failed_logic(context)
  end
  
  def second(context)
    # If will not be handled
    success(context)
  end
end
```

In console:

```ruby
result = MyService.call

result.failure? # => false
result.context.failure_error? # => true
result.context.failure_error.status # => :failed_logic
```

## Logger

DSL for insert log context state on each step

### Default logger

```ruby
class MyService < ClearLogic::Service
  stride :first, log: true
  stride :second
  stride :third, log: true

  def first(context)
    context[:test] = ['first']
    success(context)
  end
  
  def second(context)
  context[:test] += ['second']
    success(context)
  end
  
  def third(context)
  context[:test] += ['third']
    success(context)
  end
end
```

In console:

```ruby
result = MyService.call
```

In `log/my_service.log`

```pl
# Logfile created on 2019-06-06 10:28:42 +0300 by logger.rb/61378

[19-06-06 10:28:42.087 #14159#79000]  INFO -- : {
  "catched_error": null,
  "failure_error": null,
  "service": "LoggerService",
  "exit_success": null,
  "step": "first_log",
  "options": {
    "test": [
      "first"
    ]
  },
  "args": [

  ]
}
[19-06-06 10:28:42.087 #14159#79000]  INFO -- : {
  "catched_error": null,
  "failure_error": null,
  "service": "LoggerService",
  "exit_success": null,
  "step": "third_log",
  "options": {
    "test": [
      "first",
      "second",
      "third"
    ]
  },
  "args": [

  ]
}

```

### Custom logger

```ruby
class MyLogger < ::Logger
  def format_message(severity, time, progname, context)
    context[:test][0] + "\n"
  end
end

class MyService < ClearLogic::Service
  logger MyLogger

  stride :first, log: true

  def first(context)
    context[:test] = ['first']
    success(context)
  end
  
  def second(context)
  context[:test] += ['second']
    success(context)
  end
end
```

In `log/my_service.log`

```pl
# Logfile created on 2019-06-06 10:28:42 +0300 by logger.rb/61378
first
first
```


## Matcher

Service for handling failed result based on [`dry-matcher`](https://github.com/dry-rb/dry-matcher)

```ruby
class MyService < ClearLogic::Service
  context :user_id, Dry::Types['strict.integer']

  errors :custom_error

  stride :find_user
  stride :check_policy

  def initilize
  end

  def find_user(context)
    return not_found(context) unless fetched_user

    success(context)
  end
  
  def check_policy(context)
    return forbidden(context) unless user_policy.has_ability?

    success(context)
  end

  def fetched_user
    @fetched_user ||= User.find_by(id: context.user_id)
  end

  def user_policy
    @user_policy ||= PolicyUser.call(fetched_user)
  end
end
```

In matcher you can check [custom errors](#custom-errors) and [default result](#default-errors) errors

In console:

```ruby
result = MyService.call(user_id: 1)

match_result = ClearLogic::Matcher.call(result) do |on|
  on.failure(:unauthorized) { :unauthorized_result }
  on.failure(:forbidden) { :forbidden_result }
  on.failure(:not_found) { :not_found_result }
  on.failure(:invalid) { :invalid_result }
  on.failure(:custom_error) { :custom_error_result }
  on.failure { :failure_result }
  on.success { :success_result }
end

match_result # => :not_found_result
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/bezrukavyi/clear_logic. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ClearLogic project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/bezrukavyi/clear_logic/blob/master/CODE_OF_CONDUCT.md).
