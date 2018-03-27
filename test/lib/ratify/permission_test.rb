require 'test_helper'

module Ratify
  class PermissionTest < Minitest::Test
    def test_objects_can_be_equal
      permission = Permission.new(:this, :create)

      assert permission.permits?(:this, :create)
      refute permission.permits?(:that, :create)
    end

    def test_all_action_must_match
      permission = Permission.new(:this, :destroy, :update)

      assert permission.permits?(:this, :destroy)
      assert permission.permits?(:this, :update)
      assert permission.permits?(:this, :destroy, :update)

      refute permission.permits?(:this, :create, :destroy,:update)
      refute permission.permits?(:this, :read)
    end

    def test_instances_can_match
      permission = Permission.new(String, :create)

      assert permission.permits?('this', :create)
      refute permission.permits?(:this, :create)
    end

    def test_strings_as_constants
      permission = Permission.new('String', :create)

      assert permission.permits?('this', :create)
      refute permission.permits?(:this, :create)

      permission = Permission.new(Symbol, :create)
      assert permission.permits?(:this, :create)
      assert permission.permits?(:that, :create)
      refute permission.permits?('this', :create)
    end

    def test_condition_as_a_proc
      permission = Permission.new String, :create, if: -> (s, *) { s == 'this' }

      assert permission.permits?('this', :create)
      refute permission.permits?('that', :create)
    end

    def test_unless_condition
      permission = Permission.new String, :create, unless: -> (s, *) { s == 'this' }

      refute permission.permits?('this', :create)
      assert permission.permits?('or this', :create)
      assert permission.permits?('and that', :create)
    end

    def test_all_conditions_must_match
      permission = Permission.new Integer, if: -> (i, *) { i > 10 }, unless: -> (i, *) { i < 15 }
      refute permission.permits?(5)
      refute permission.permits?(14)
      assert permission.permits?(16)
    end

    def test_full_access
      permission = Permission.new(String, :full_access)
      assert permission.permits?('this')
      assert permission.permits?('that', :anything)
    end
  end
end
