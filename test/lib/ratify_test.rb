require 'test_helper'

class RatifyTest < Minitest::Test
  class Perm
    include Ratify

    attr_accessor :id

    permit String, if: -> (string) { string == 'this' }
    permit Numeric, if: -> (id) { id == self.id }
    permit Numeric, if: :id_is_10?
    permit Numeric, id: 1000

    def initialize(id)
      @id = id
    end

    def id_is_10?
      id == 10
    end
  end

  def test_class_methods
    assert_respond_to Perm, :permissions
    assert_respond_to Perm, :permit
    assert_respond_to Perm, :permits?
  end

  def test_permissions_on_object
    assert Perm.permits?('this')
  end

  def test_instance_permission
    perm = Perm.new(999)

    refute perm.permits?(1)
    assert perm.permits?(999)
  end

  def test_condition_as_symbol
    refute Perm.new(1).permits?(10)
    assert Perm.new(10).permits?(10)
  end

  def test_equality_condition
    refute Perm.new(7).permits?(0)
    assert Perm.new(1000).permits?(0)
  end
end
