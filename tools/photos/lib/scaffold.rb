require "fileutils"
require "time"
require "yaml"

module Scaffold
  module_function

  def new_essay(root, slug)
    create_post(root, "_essays", slug, "layout" => "single")
  end

  def new_note(root, slug, subtype:)
    create_post(root, "_notes", slug, "layout" => "single", "subtype" => subtype)
  end

  def new_album(root, slug)
    dir = File.join("photos-source", slug)
    FileUtils.mkdir_p(File.join(root, dir))
    File.write(File.join(root, dir, "album.yml"),
               YAML.dump("title" => "", "date" => "", "description" => "", "cover" => nil))
    dir
  end

  def create_post(root, folder, slug, front_matter)
    name = "#{Time.now.strftime('%Y-%m-%d')}-#{slug}.md"
    rel = File.join(folder, name)
    FileUtils.mkdir_p(File.join(root, folder))
    data = { "title" => "", "date" => Time.now }.merge(front_matter)
    File.write(File.join(root, rel), YAML.dump(data) + "\n---\n\n")
    rel
  end
end
