require "yaml"
require "json"
require "date"
require "digest"
require "fileutils"
require_relative "exif_reader"
require_relative "resizer"

class Pipeline
  Report = Struct.new(:processed, :skipped, :errors) do
    def ok? = errors.empty?
  end

  TIER_DIR = { thumb: "thumb", medium: "medium", large: "large" }.freeze
  PHOTO_EXTS = %w[.jpg .jpeg].freeze

  def self.run(**opts)
    new(**opts).run
  end

  def initialize(source_root:, output_root:, data_root:, resizer: nil, manifest_path: nil)
    @source_root = source_root
    @output_root = output_root
    @data_root = data_root
    @resizer = resizer || ->(src, dst, long_edge:) do
      Resizer.resize(src, dst, long_edge: long_edge, quality: Resizer::QUALITY[tier_for(dst)])
    end
    @manifest_path = manifest_path || File.join(@output_root, ".manifest.yml")
  end

  def run
    report = Report.new([], [], [])
    manifest = load_manifest
    albums.each do |dir|
      process_album(dir, manifest, report)
    end
    save_manifest(manifest)
    File.write(@manifest_path + ".last-run", report.inspect)
    report
  end

  private

  def tier_for(dst)
    Resizer::LONG_EDGE.keys.find { |t| dst.include?("#{TIER_DIR[t]}/") } || :large
  end

  def albums
    Dir.children(@source_root)
       .map { |name| File.join(@source_root, name) }
       .select { |path| File.directory?(path) }
       .sort
  end

  def process_album(dir, manifest, report)
    slug = File.basename(dir)
    meta = load_album_meta(dir)
    photos = photo_files(dir)
    captions = load_captions(dir)
    cover = meta["cover"] || File.basename(photos.first, ".*")
    entries = photos.map do |src|
      name = File.basename(src, ".*")
      photo_entry(slug, src, name, captions, manifest, report)
    end
    write_data(slug, meta, cover, entries)
  end

  def photo_entry(slug, src, name, captions, manifest, report)
    key = "#{slug}/#{name}"
    sha = Digest::SHA256.file(src).hexdigest
    outputs = Resizer::LONG_EDGE.map { |tier, edge|
      [tier, File.join(@output_root, slug, TIER_DIR[tier], "#{name}.jpg")]
    }.to_h

    if manifest[key] == sha && outputs.values.all? { |p| File.exist?(p) }
      report.skipped << key
    else
      begin
        outputs.each do |tier, dst|
          @resizer.call(src, dst, long_edge: Resizer::LONG_EDGE[tier])
        end
        manifest[key] = sha
        report.processed << key
      rescue => e
        report.errors << "#{key}: #{e.message}"
        FileUtils.rm_f(outputs.values)
        return nil
      end
    end

    large_dims = image_dims(outputs[:large])
    {
      "file" => name,
      "caption" => captions[name],
      "width" => large_dims[:width],
      "height" => large_dims[:height],
      "exif" => (ExifReader.read(src) || {}).transform_keys(&:to_s),
      "urls" => outputs.transform_keys(&:to_s).transform_values { |p| relative_path(p) }
    }.compact
  end

  def image_dims(path)
    j = EXIFR::JPEG.new(path)
    { width: j.width, height: j.height }
  end

  def write_data(slug, meta, cover, entries)
    entries.compact!
    FileUtils.mkdir_p(@data_root)
    data = meta.merge(
      "slug" => slug,
      "cover" => cover,
      "photos" => entries
    )
    File.write(File.join(@data_root, "#{slug}.yml"), YAML.dump(data))
  end

  def load_captions(dir)
    path = File.join(dir, "captions.json")
    File.exist?(path) ? JSON.parse(File.read(path)) : {}
  end

  def photo_files(dir)
    Dir.children(dir)
       .select { |f| PHOTO_EXTS.include?(File.extname(f).downcase) }
       .sort
       .map { |f| File.join(dir, f) }
  end

  def load_album_meta(dir)
    path = File.join(dir, "album.yml")
    File.exist?(path) ? (YAML.load_file(path, permitted_classes: [Date, Time]) || {}) : {}
  end

  def load_manifest
    File.exist?(@manifest_path) ? (YAML.load_file(@manifest_path) || {}) : {}
  end

  def save_manifest(manifest)
    FileUtils.mkdir_p(File.dirname(@manifest_path))
    File.write(@manifest_path, YAML.dump(manifest))
  end

  def relative_path(path)
    path.sub(/\A#{Regexp.escape(@output_root)}[\\\/]/, "").tr("\\", "/")
  end
end
