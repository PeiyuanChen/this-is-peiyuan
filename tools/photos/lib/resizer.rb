require "open3"
require "exifr/jpeg"

module Resizer
  class Error < StandardError; end

  QUALITY = { thumb: 4, medium: 3, large: 3 }.freeze
  LONG_EDGE = { thumb: 500, medium: 1280, large: 2000 }.freeze

  module_function

  def resize(src, dst, long_edge:, quality: 3)
    raise Error, "源文件不存在: #{src}" unless File.exist?(src)
    FileUtils.mkdir_p(File.dirname(dst))
    filter = "scale=w='if(gt(iw,ih),#{long_edge},-2)':h='if(gt(iw,ih),-2,#{long_edge})':flags=lanczos"
    out, status = Open3.capture2("ffmpeg", "-y", "-loglevel", "error", "-i", src,
                                 "-vf", filter, "-q:v", quality.to_s, dst)
    raise Error, "ffmpeg 处理失败 #{File.basename(src)}: #{out}" unless status.success? && File.exist?(dst)
    j = EXIFR::JPEG.new(dst)
    { width: j.width, height: j.height }
  end
end
