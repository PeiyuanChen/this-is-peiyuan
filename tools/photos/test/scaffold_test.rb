require_relative "test_helper"
require "yaml"
require "json"
require "scaffold"

class ScaffoldTest < Minitest::Test
  def setup
    @root = Dir.mktmpdir
  end

  def teardown
    FileUtils.remove_entry @root
  end

  def test_new_essay_creates_markdown_with_front_matter
    path = Scaffold.new_essay(@root, "a-title")
    data = YAML.load_file(File.join(@root, path), permitted_classes: [Time])
    assert_equal "single", data["layout"]
    assert data["title"]
    assert data["date"]
    assert_equal true, data["show_date"]
    assert_match(%r{\A_essays/a-title\.md\z}, path.tr("\\", "/"))
  end

  def test_new_note_carries_subtype
    path = Scaffold.new_note(@root, "mongo", subtype: "topic")
    assert_equal "topic", YAML.load_file(File.join(@root, path), permitted_classes: [Time])["subtype"]
    assert_match(%r{\A_notes/mongo\.md\z}, path.tr("\\", "/"))
  end

  def test_new_album_creates_folder_and_metadata
    dir = Scaffold.new_album(@root, "kyoto-2019")
    assert File.directory?(File.join(@root, dir))
    meta = YAML.load_file(File.join(@root, dir, "album.yml"))
    assert_equal "", meta["title"]
    assert_equal "", meta["date"]
    assert_nil meta["cover"]
    assert_equal({}, JSON.parse(File.read(File.join(@root, dir, "captions.json"))))
    assert_match(%r{\Aphoto-source/kyoto-2019\z}, dir.tr("\\", "/"))
  end
end
