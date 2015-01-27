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

  class Cluster
    def initialize(color)
      @h, @s, @v = [], [], []
      @hs = 0
      self << color
    end

    def <<(color)
      @h << color[0]
      @s << color[1]
      @v << color[2]
      @hs += color[0]
    end

    def distance(color)
      (center - color[0]).abs
    end

    def center
      @hs / @h.size
    end

    def colors
      [@h, @s, @v]
    end

    def color_range
      memo = {low: [], high: [], mean: [], sd: []}
      colors.map(&:to_scale).each_with_index do |d, index|
        sd = d.sd
        mean = d.mean

        memo[:low] << ([mean - 3 * sd, 0.0].max).floor
        memo[:high] << ([mean + 3 * sd, max_value(index)].min).ceil
        memo[:mean] << mean
        memo[:sd] << sd
      end
      memo
    end

    def max_value(i)
      # H => 0
      i == 0 ? 179.0 : 255.0
    end
  end

  include OpenCV

  module_function
  def cluster_colors(colors, max_distance=20)
    clusters = []
    colors.each do |cs|
      cs.each do |color|
        cluster = clusters.find do |cluster|
          cluster.distance(color) < max_distance
        end

        if cluster
          cluster << color
        else
          clusters << Cluster.new(color)
        end
      end
    end
    clusters
  end

  def samples(dir)
    Dir["#{dir}/*"].map do |color|
      [color, Dir["#{color}/*"]]
    end
  end

  def learn(dir)
    ret = samples(dir).inject({}) do |memo, cd|
      color_dir, files = cd
      cluster_colors(files.map(&method(:load_image_colors))).each_with_index do |cluster, i|
        memo[color_name(color_dir, i)] = cluster.color_range
      end
      memo
    end
    Hash[ret]
  end

  def color_name(path, i)
    "#{File.basename(path).downcase.gsub(/[^a-z_]/, '_')}_#{i}"
  end

  def load_image_colors(file)
    img = IplImage.load(file, OpenCV::CV_LOAD_IMAGE_ANYCOLOR | OpenCV::CV_LOAD_IMAGE_ANYDEPTH)
    colors(img.BGR2HSV)
  end

  def colors(img)
    Colors.new(img)
  end
end
