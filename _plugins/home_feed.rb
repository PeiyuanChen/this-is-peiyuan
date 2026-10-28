# 首页数据：相册列表（封面缩略图），按日期倒序。
# 随感列表直接在模板中遍历 site.essays，无需此处处理。
# 模板只读 site.home_albums，统一结构：
#   title、date、url、thumb(相册封面 thumb 相对路径)
require "time"

module HomeFeed
  def self.albums(site)
    data = site.data["albums"]
    return [] unless data.is_a?(Hash)

    data.map do |slug, a|
      cover = (a["photos"] || []).find { |p| p["file"] == a["cover"] }
      cover ||= (a["photos"] || []).first
      {
        "title" => a["title"],
        "date"  => a["date"],
        "url"   => "/photography/#{slug}/",
        "thumb" => cover && cover.dig("urls", "thumb")
      }
    end.sort_by { |i| time_of(i["date"]) }.reverse
  end

  # data 文件里的日期是 Date/字符串，统一成 Time 再排序
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
  payload["site"]["home_albums"] = HomeFeed.albums(site)
end
