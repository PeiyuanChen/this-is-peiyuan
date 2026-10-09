require_relative "test_helper"
require "exif_reader"

class ExifReaderTest < Minitest::Test
  def test_full_exif
    info = ExifReader.read(fixture_photo("IMG08161"))
    assert_equal "SONY", info[:make]
    assert_equal "ILCE-7RM3", info[:model]
    assert_equal 4.0, info[:f_number]
    assert_equal "1/160", info[:exposure]
    assert_equal 100, info[:iso]
    assert_includes info[:lens], "APO-LANTHAR"
  end

  def test_partial_exif_keeps_available_fields
    info = ExifReader.read(fixture_photo("IMG07481"))
    assert_nil info[:make]
    assert_nil info[:iso]
    assert_equal 2.8, info[:f_number]
    assert_equal "1/100", info[:exposure]
  end

  def test_exposure_formatting
    assert_equal "1/320", ExifReader.format_exposure(Rational(1, 320))
    assert_equal "2s", ExifReader.format_exposure(2)
    assert_equal "0.5s", ExifReader.format_exposure(0.5)
  end
end
