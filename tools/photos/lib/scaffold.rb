require "fileutils"
require "time"
require "yaml"

module Scaffold
  module_function

  def new_essay(root, slug)
    create_doc(root, "_essays", slug, "layout" => "single", "show_date" => true)
  end

  def new_note(root, slug, subtype:)
    create_doc(root, "_notes", slug,
               "layout" => "single", "show_date" => true, "subtype" => subtype)
  end

  def new_album(root, slug)
    dir = File.join("photo-source", slug)
    FileUtils.mkdir_p(File.join(root, dir))
    File.write(File.join(root, dir, "album.yml"),
               YAML.dump("title" => "", "date" => "", "description" => "", "cover" => nil))
    File.write(File.join(root, dir, "captions.json"), "{}\n")
    dir
  end

  # collection 文档的 slug 取自文件名，故不带日期前缀；日期写进 front matter
  def create_doc(root, folder, slug, front_matter)
    rel = File.join(folder, "#{slug}.md")
    FileUtils.mkdir_p(File.join(root, folder))
    data = { "title" => "", "date" => Time.now }.merge(front_matter)
    File.write(File.join(root, rel), YAML.dump(data) + "\n---\n\n")
    rel
  end
end
