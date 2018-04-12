# Ratify

Ratify is a very fast, easy to use, zero-dependency Ruby authorization gem.
Simply include the `Ratify` module in your class to give it permissions. You 
can check the permissions on a class or instance level with the `permit?` 
method.

Ratify makes as few assumptions about your authorization stragegy as possible.
It knows only that you have one object that needs permission to be accessed  
by another object. You can optionally provide a list of actions and/or 
conditions as well.

Here's a very simple user-authorization example:

```ruby
class User
  attr_accessor :admin
end

class Record
  include Ratify
  
  attr_accessor :published, :user
  
  # Admins have full access to any record.
  permit :User, :full_access, if: -> (user, *) do
    user&.admin
  end
  
  # Users have full access to their own records.
  permit :User, :full_access, if: -> (user, *) do
    # In this context self is an instance of the record. If the permission
    # is being checked at the class-level, self will be nil. That is why the
    # safe-navigation operator (&.) is being used here. 
    self&.user == user
  end
  
  # Signed in users can create new records.
  permit :User, :create
  
  # Signed out users can read published records.
  permit nil, :read, if: :published
end
```

The permissions can be read at a class-level:

```ruby
Record.permit?(current_user, :create)
```

or on an instance-level:

```ruby
record.permit?(current_user, :update)
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ratify'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ratify

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then,
run `rake test` to run the tests. You can also run `bin/console` for an
interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/hi5dev/ratify.

This project is intended to be a safe, welcoming space for collaboration, and
contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT).
