require_relative "test_helper"
require "resizer"

class ResizerTest < Minitest::Test
  def setup
    @dir = Dir.mktmpdir
  end

  def teardown
    FileUtils.remove_entry @dir
  end

  def test_generates_three_tiers_with_bounded_long_edge
    out = File.join(@dir, "out.jpg")
    dims = Resizer.resize(fixture_photo("IMG09227"), out, long_edge: 500)
    assert File.exist?(out)
    assert_equal 500, [dims[:width], dims[:height]].max
  end

  def test_portrait_orientation_bounded_correctly
    out = File.join(@dir, "p.jpg")
    dims = Resizer.resize(fixture_photo("IMG08161"), out, long_edge: 2000)
    assert_equal 2000, [dims[:width], dims[:height]].max
  end

  def test_missing_source_raises
    assert_raises(Resizer::Error) do
      Resizer.resize("nope.jpg", File.join(@dir, "x.jpg"), long_edge: 500)
    end
  end
end
