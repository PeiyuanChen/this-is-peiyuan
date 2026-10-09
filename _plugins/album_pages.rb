module AlbumPages
  module Sorted
    def self.list(site)
      albums = site.data["albums"]
      return [] unless albums.is_a?(Hash)

      albums.map { |slug, data| data.merge("slug" => slug) }
            .sort_by { |a| a["date"].to_s }
            .reverse
    end
  end

  class AlbumPage < Jekyll::Page
    def initialize(site, slug)
      @site = site
      @base = site.source
      @dir = File.join("photography", slug)
      @name = "index.html"
      process(@name)
      data = site.data["albums"][slug]
      self.data = {
        "layout" => "album",
        "title" => data["title"],
        "slug" => slug,
        "album" => data
      }
    end
  end

  class Generator < Jekyll::Generator
    safe true
    priority :low

    def generate(site)
      Sorted.list(site).each { |a| site.pages << AlbumPage.new(site, a["slug"]) }
    end
  end
end

Jekyll::Hooks.register :site, :pre_render do |site, payload|
  payload["site"]["albums_sorted"] = AlbumPages::Sorted.list(site)
end
