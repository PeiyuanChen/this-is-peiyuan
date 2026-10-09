require "exifr/jpeg"

module ExifReader
  module_function

  def read(path)
    j = EXIFR::JPEG.new(path)
    {
      make: j.make&.strip,
      model: j.model&.strip,
      lens: j.lens_model&.strip,
      f_number: f_number(j.f_number),
      exposure: j.exposure_time && format_exposure(j.exposure_time),
      iso: Array(j.iso_speed_ratings).first
    }.compact
  rescue EXIFR::MalformedJPEG, Errno::ENOENT
    nil
  end

  def f_number(value)
    return nil if value.nil?
    v = value.to_f
    (v == v.round ? v.round : v)
  end

  def format_exposure(value)
    seconds = value.to_r
    if seconds >= 1
      shown = seconds == seconds.to_i ? seconds.to_i : seconds.to_f
      "#{shown}s"
    elsif seconds == Rational(1, 2)
      "0.5s"
    else
      "1/#{(1 / seconds).to_i}"
    end
  end
end
