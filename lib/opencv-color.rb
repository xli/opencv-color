require "opencv-color/version"
require 'opencv'
require 'statsample'

module OpenCVColor
  class Colors
    include Enumerable

    def initialize(image)
      @image = image
    end

    def size
      @image.height * @image.width
    end

    def each(&block)
      @image.height.times do |i|
        @image.width.times do |j|
          yield(@image[i, j])
        end
      end
    end
  end

  include OpenCV

  module_function
  def samples(dir)
    Dir["#{dir}/*"].map do |color|
      [color, Dir["#{color}/*"]]
    end
  end

  def learn(dir)
    Hash[samples(dir).map do |color_dir, files|
      group = [[], [], []]
      files.map(&method(:load_image_colors)).each do |colors|
        colors.each do |c|
          3.times do |i|
            group[i] << c[i]
          end
        end
      end
      range = group.map(&:to_scale).each_with_index.inject({low: [], high: [], mean: [], sd: []}) do |memo, d|
        g, index = d
        sd = g.sd
        mean = g.mean
        memo[:low] << ([mean - 3 * sd, min_value].max).floor
        memo[:high] << ([mean + 3 * sd, max_value(index)].min).ceil
        memo[:mean] << mean
        memo[:sd] << sd
        memo
      end
      [color_name(color_dir), range]
    end]
  end

  def color_name(path)
    File.basename(path).downcase.gsub(/[^a-z_]/, '_')
  end

  def min_value
    0
  end

  def max_value(i)
    # H => 0
    i == 0 ? 179 : 255
  end

  def load_image_colors(file)
    img = IplImage.load(file, OpenCV::CV_LOAD_IMAGE_ANYCOLOR | OpenCV::CV_LOAD_IMAGE_ANYDEPTH)
    Colors.new(img.smooth(:median, 3).BGR2HSV)
  end

end
