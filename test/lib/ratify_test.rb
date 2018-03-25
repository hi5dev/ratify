require 'test_helper'

class RatifyTest < Minitest::Test
  def test_ratify_module_is_defined
    assert defined?(Ratify)
    assert_kind_of Module, Ratify
  end
end
