require_relative "test_helper"
require "yaml"
require "pipeline"

class PipelineTest < Minitest::Test
  FULL_PHOTOS = %w[IMG07481 IMG08161 IMG09227]

  def setup
    @work = Dir.mktmpdir
    @source_root = File.join(@work, "source")
    @output_root = File.join(@work, "photos")
    @data_root = File.join(@work, "data")
    @album = File.join(@source_root, "2025")
    FileUtils.mkdir_p(@album)
    FULL_PHOTOS.each { |n| FileUtils.cp(fixture_photo(n), File.join(@album, "#{n}.JPG")) }
    File.write(File.join(@album, "IMG09227.txt"), "傍晚的光")
    File.write(File.join(@album, "album.yml"), {
      "title" => "二〇二五",
      "date" => "2025-10-01",
      "description" => "这一年的碎片"
    }.to_yaml)
    File.write(File.join(@album, "broken.JPG"), "not a jpeg")
  end

  def teardown
    FileUtils.remove_entry @work
  end

  def run_pipeline(**opts)
    Pipeline.run(
      source_root: @source_root,
      output_root: @output_root,
      data_root: @data_root,
      **opts
    )
  end

  def test_end_to_end_generates_tiers_and_data
    report = run_pipeline

    %w[thumb medium large].each do |tier|
      FULL_PHOTOS.each do |n|
        assert File.exist?(File.join(@output_root, "2025", tier, "#{n}.jpg")),
               "missing #{tier}/#{n}.jpg"
      end
    end
    refute File.exist?(File.join(@output_root, "2025", "large", "broken.jpg"))
    assert report.errors.any? { |e| e.include?("broken.JPG") }

    data = YAML.load_file(File.join(@data_root, "2025.yml"))
    assert_equal "二〇二五", data["title"]
    assert_equal "2025-10-01", data["date"].to_s
    assert_equal "这一年的碎片", data["description"]

    photos = data["photos"]
    assert_equal FULL_PHOTOS, photos.map { |p| p["file"] }
    assert_equal 2000, [photos.first["width"], photos.first["height"]].max

    full = photos.find { |p| p["file"] == "IMG08161" }
    assert_equal 4.0, full["exif"]["f_number"]
    assert_equal "1/160", full["exif"]["exposure"]
    assert_equal 100, full["exif"]["iso"]

    partial = photos.find { |p| p["file"] == "IMG07481" }
    assert_nil partial["exif"]["iso"]
    assert_equal "1/100", partial["exif"]["exposure"]

    captioned = photos.find { |p| p["file"] == "IMG09227" }
    assert_equal "傍晚的光", captioned["caption"]
    assert_nil partial["caption"]

    assert_equal "IMG07481", data["cover"]
  end

  def test_cover_override_in_album_metadata
    File.write(File.join(@album, "album.yml"), {
      "title" => "二〇二五", "date" => "2025", "cover" => "IMG09227"
    }.to_yaml)
    run_pipeline
    data = YAML.load_file(File.join(@data_root, "2025.yml"))
    assert_equal "IMG09227", data["cover"]
  end

  def test_idempotent_second_run_resizes_nothing
    run_pipeline
    calls = []
    resizer = ->(src, dst, long_edge:) { calls << File.basename(src); Resizer.resize(src, dst, long_edge: long_edge) }
    report = run_pipeline(resizer: resizer)
    refute calls.any? { |s| s.start_with?("IMG") }
    assert_empty report.processed
  end

  def test_changed_photo_is_regenerated
    run_pipeline
    File.write(File.join(@album, "IMG09227.JPG"), "tampered")
    calls = []
    resizer = ->(src, dst, long_edge:) { calls << dst; Resizer.resize(src, dst, long_edge: long_edge) }
    report = run_pipeline(resizer: resizer)
    refute report.ok?
    assert calls.any? { |d| d.include?("IMG09227.jpg") }
    refute calls.any? { |d| d.match?(/IMG07481|IMG08161/) }
  end
end
