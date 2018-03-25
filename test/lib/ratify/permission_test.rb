require 'test_helper'

module Ratify
  class PermissionTest < Minitest::Test
    def test_objects_can_be_equal
      permission = Permission.new(:this, :create)

      assert permission.permitted?(:this, :create)
      refute permission.permitted?(:that, :create)
    end

    def test_all_action_must_match
      permission = Permission.new(:this, :destroy, :update)

      assert permission.permitted?(:this, :destroy)
      assert permission.permitted?(:this, :update)
      assert permission.permitted?(:this, :destroy, :update)

      refute permission.permitted?(:this, :create, :destroy,:update)
      refute permission.permitted?(:this, :read)
    end

    def test_instances_can_match
      permission = Permission.new(String, :create)

      assert permission.permitted?('this', :create)
      refute permission.permitted?(:this, :create)
    end

    def test_strings_as_constants
      permission = Permission.new('String', :create)

      assert permission.permitted?('this', :create)
      refute permission.permitted?(:this, :create)

      permission = Permission.new(Symbol, :create)
      assert permission.permitted?(:this, :create)
      assert permission.permitted?(:that, :create)
      refute permission.permitted?('this', :create)
    end

    def test_condition_as_a_proc
      permission = Permission.new String, :create, if: -> (s, *) { s == 'this' }

      assert permission.permitted?('this', :create)
      refute permission.permitted?('that', :create)
    end

    def test_unless_condition
      permission = Permission.new String, :create, unless: -> (s, *) { s == 'this' }

      refute permission.permitted?('this', :create)
      assert permission.permitted?('or this', :create)
      assert permission.permitted?('and that', :create)
    end

    def test_all_conditions_must_match
      permission = Permission.new Integer, if: -> (i, *) { i > 10 }, unless: -> (i, *) { i < 15 }
      refute permission.permitted?(5)
      refute permission.permitted?(14)
      assert permission.permitted?(16)
    end

    def test_condition_as_symbol
      permission = Permission.new Array, unless: :empty?

      assert permission.permitted?(['not empty'])
      refute permission.permitted?([])
    end

    def test_equality_condition
      permission = Permission.new(Numeric, round: 10)

      refute permission.permitted?(10.8)
      assert permission.permitted?(10.1)
    end
  end
end
