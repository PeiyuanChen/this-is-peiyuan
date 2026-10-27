# 首页混合最新流：随感与相册按日期合并、倒序排列，取前 N 条。
# 模板只读 site.latest_feed，统一结构：
#   type("album"/"essay")、title、date、url、thumb(相册封面相对路径，随感为 nil)
require "time"

module HomeFeed
  LIMIT = 6

  def self.list(site)
    items = []

    albums = site.data["albums"]
    if albums.is_a?(Hash)
      albums.each do |slug, a|
        cover = (a["photos"] || []).find { |p| p["file"] == a["cover"] }
        cover ||= (a["photos"] || []).first
        items << {
          "type"  => "album",
          "title" => a["title"],
          "date"  => a["date"],
          "url"   => "/photography/#{slug}/",
          "thumb" => cover && cover.dig("urls", "thumb")
        }
      end
    end

    essays = site.collections["essays"]
    essays&.docs&.each do |doc|
      items << {
        "type"  => "essay",
        "title" => doc.data["title"],
        "date"  => doc.date,
        "url"   => doc.url,
        "thumb" => nil
      }
    end

    items.sort_by { |i| time_of(i["date"]) }.reverse.first(LIMIT)
  end

  # data 文件里的日期是 Date/字符串，collection 文档日期是 Time，统一成 Time 再排序
  def self.time_of(value)
    case value
    when Time then value
    when Date then value.to_time
    else
      begin
        Time.parse(value.to_s)
      rescue ArgumentError
        Time.at(0)
      end
    end
  end
end

Jekyll::Hooks.register :site, :pre_render do |site, payload|
  payload["site"]["latest_feed"] = HomeFeed.list(site)
end
