# Ratify

An easy to use, zero-dependency authorization gem.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ratify'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ratify

## Usage

Here's an example of how you can use Ratify for basic user permissions.

```ruby
class User
  attr_accessor :admin

  def initialize(admin: false)
    @admin = admin
  end
  
  def admin?
    admin && true  
  end
end

class Record
  include Ratify
 
  # Admins have full access to the records.
  permit User, :full_access, if: :admin?
  
  # Users can create new records.
  permit User, :create
  
  # Users can update and destroy their own records.
  permit User, :update, :destroy, if: -> (user) { self.user == user }

  attr_accessor :user

  def initialize(user)
    @user = user  
  end
end

admin = User.new(admin: true)
user1 = User.new
user2 = User.new
record = Record.new(user: user1)

record.permits?(admin, :create) # => true
record.permits?(user1, :update) # => true
record.permits?(user2, :destroy) # => false

Record.permits?(admin, :create) # => true
Record.permits?(user1, :create) # => true
Record.permits?(user2, :create) # => true
```

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
