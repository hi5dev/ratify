require 'test_helper'

class RatifyTest < Minitest::Test
  class Perm
    include Ratify

    permit String, if: -> (s, *) { s == 'this' }
  end

  def test_class_methods
    assert_respond_to Perm, :permissions
    assert_respond_to Perm, :permit
    assert_respond_to Perm, :permits?
  end

  def test_permissions_on_object
    assert Perm.permits?('this')
  end

  def test_permission_in_instance
    perm = Perm.new

  end
end
