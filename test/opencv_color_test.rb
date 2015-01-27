require 'minitest/autorun'

require "opencv-color"

class TestOpencvColor < MiniTest::Test

  class Image
    def initialize(data)
      @data = data
    end

    def width
      height == 0 ? 0 : @data[0].size
    end

    def height
      @data.size
    end

    def [](i, j)
      @data[i][j]
    end
  end

  def test_cluster_colors
    image1 = Image.new([
      [[0,1,1], [1,1,1]],
      [[189,1,1], [190,1,1]]
    ])

    clusters = OpenCVColor.cluster_colors([OpenCVColor.colors(image1)])
    assert_equal 2, clusters.size
    assert_equal [[0,1], [1,1],[1,1]], clusters[0].colors
    assert_equal [[189,190], [1,1], [1,1]], clusters[1].colors

    image2 = Image.new([
      [[0,1,1], [1,1,1], [5,1,1], [111, 1, 1]],
      [[3,1,1], [180,1,1], [100,1,1], [115,1,1]]
    ])

    clusters = OpenCVColor.cluster_colors([OpenCVColor.colors(image1), OpenCVColor.colors(image2)])

    assert_equal 3, clusters.size
    assert_equal [[0,1,0,1,5,3], [1,1,1,1,1,1], [1,1,1,1,1,1]], clusters[0].colors
    assert_equal [[189,190,180], [1,1,1], [1,1,1]], clusters[1].colors
    assert_equal [[111,100,115], [1,1,1], [1,1,1]], clusters[2].colors
  end

  def test_cluster_color_range
    image1 = Image.new([
      [[10,10,10], [12,12,12]],
      [[150,150,150], [152,152,152]]
    ])
    clusters = OpenCVColor.cluster_colors([OpenCVColor.colors(image1)])
    assert_equal [6,6,6], clusters[0].color_range[:low]
    assert_equal [16,16,16], clusters[0].color_range[:high]
    assert_equal [11,11,11], clusters[0].color_range[:mean]

    assert_equal [146,146,146], clusters[1].color_range[:low]
    assert_equal [156,156,156], clusters[1].color_range[:high]
    assert_equal [151,151,151], clusters[1].color_range[:mean]
  end

  def test_cluster_color_range_min_and_max_values
    image1 = Image.new([
      [[0,0,0], [2,2,2]],
      [[175,250,250], [179,254,254]]
    ])
    clusters = OpenCVColor.cluster_colors([OpenCVColor.colors(image1)])
    assert_equal [0,0,0], clusters[0].color_range[:low]
    assert_equal [6,6,6], clusters[0].color_range[:high]
    assert_equal [1,1,1], clusters[0].color_range[:mean]

    assert_equal [168,243,243], clusters[1].color_range[:low]
    assert_equal [179,255,255], clusters[1].color_range[:high]
    assert_equal [177, 252, 252], clusters[1].color_range[:mean]
  end
end