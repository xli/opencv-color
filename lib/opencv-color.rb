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
    Hash[samples(dir).map do |color, files|
      group = [[], [], [], []]
      files.map(&method(:load_image_colors)).each do |colors|
        colors.each do |c|
          4.times do |i|
            group[i] << c[i]
          end
        end
      end
      range = group.map(&:to_scale).inject({low: [], high: []}) do |memo, g|
        sd = g.sd
        mean = g.mean
        memo[:low] << [mean - 3 * sd, 0].max
        memo[:high] << mean + 3 * sd
        memo
      end
      [File.basename(color), range]
    end]
  end

  def load_image_colors(file)
    Colors.new(IplImage.load(file, OpenCV::CV_LOAD_IMAGE_ANYCOLOR | OpenCV::CV_LOAD_IMAGE_ANYDEPTH).BGR2HSV)
  end

end
