require 'test_helper'

module Ratify
  class VersionTest < Minitest::Test
    def test_version_is_semantic
      assert_match /^(\d+\.)?(\d+\.)?(\*|\d+)$/, Ratify::VERSION
    end
  end
end
