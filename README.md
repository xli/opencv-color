# OpenCVColor

OpenCV is a great library for writing Computer Vision software. However, OpenCV's HSV format is different than what you would expect! This gem trys to learn HSV color range from sample images for your OpenCV program to detect color.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'opencv-color'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install opencv-color

## Usage

Put your color sample images input the following structure:

* color samples root directory
 * color name
  * color sample image files

See color-samples directory as example.

Run opencv-color command to extract color range data:

    opencv-color <color samples root directory> > color-data.yml

The output data is a YAML dump of a Ruby Hash object:

    {color name => {low: HSV color CvScalar array format, high: HSV color CvScalar array format}}

Use the data in your application, the following example uses ruby-opencv gem:

    include OpenCV

    colors = YAML.load(File.read('color-data.yml'))
    low = CvScalar.new(*colors['blue']['low'])
    high = CvScalar.new(*colors['blue']['high'])

    image = IplImage.load('picture.png', CV_LOAD_IMAGE_ANYCOLOR | CV_LOAD_IMAGE_ANYDEPTH)
    image.BGR2HSV.in_range(low, high)
    ....

## Contributing

1. Fork it ( https://github.com/[my-github-username]/opencv-color/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
