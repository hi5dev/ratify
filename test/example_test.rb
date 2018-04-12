require 'test_helper'

class User
  attr_accessor :admin
end

class Record
  include Ratify

  attr_accessor :published, :user

  permit :User, :full_access, if: -> (user, *) { user&.admin }
  permit :User, :full_access, if: -> (user, *) { self&.user == user }
  permit :User, :create
  permit nil, :read, if: :published
end

# Tests that the examples provided in the README actually work.
class ExampleTest < Minitest::Test
  def test_full_access_for_admin
    user = User.new
    user.admin = true

    record = Record.new

    assert record.permits?(user, :full_access)
    assert Record.permits?(user, :full_access)
  end

  def test_users_own_records
    user1 = User.new
    user2 = User.new
    record = Record.new

    record.user = user1
    assert record.permits?(user1, :full_access)
    refute record.permits?(user2, :full_access)
    refute record.permits?(nil, :full_access)

    record.user = user2
    refute record.permits?(user1, :full_access)
    assert record.permits?(user2, :full_access)
    refute record.permits?(nil, :full_access)
  end

  def test_users_create
    refute Record.permits?(nil, :create)
    assert Record.permits?(User.new, :create)
  end

  def test_class_level_permits
    current_user = User.new
    current_user.admin = false
    assert Record.permits?(current_user, :create)
    refute Record.permits?(current_user, :full_access)

    current_user = User.new
    current_user.admin = true
    assert Record.permits?(current_user, :create)
    assert Record.permits?(current_user, :full_access)

    current_user = nil
    refute Record.permits?(current_user, :create)
    refute Record.permits?(current_user, :full_access)
  end

  def test_anon_read_published
    record = Record.new

    record.published = false
    refute record.permits?(nil, :read)

    record.published = true
    assert record.permits?(nil, :read)
    refute record.permits?(nil, :full_access)
  end
end
