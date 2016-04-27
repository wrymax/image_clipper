[![Gem Version][GV img]][Gem Version]
[![Build Status](https://travis-ci.org/wrymax/image_clipper.svg?branch=master)](https://travis-ci.org/wrymax/image_clipper)

# ImageClipper

[Gem Version]: https://rubygems.org/gems/image_clipper
[travis pull requests]: https://travis-ci.org/wrymax/image_clipper/pull_requests

[GV img]: https://badge.fury.io/rb/image_clipper@2x.png

What ImageClipper does is just to make image processing easier! 

Now you can forget about the complex command line of ImageMagick, and use deadly simple ruby method to complete image processing jobs.

## Installation

Firstly install the ImageMagick components:

    brew install imagemagick

Or go to offcial website and download it:

    http://www.imagemagick.org/script/binary-releases.php

Add this line to your application's Gemfile:

    gem 'image_clipper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install image_clipper

## Directly processing image:

Read image:

    image = ImageClipper::Image.new(image_path)
    
Resize image:

    # overwrite the original image:
    image.resize('200x100')
    
    # save to new file
    image.resize('200x100', save_new_file_path)
    
    # use percentage
    image.resize('35%')

Add watermark:

    # this will add watermark to bottom right corner as default, and will overwrite the original image
    image.watermarking(watermark_image_path)

    # config the watermark position:
    # posible selections: %W(top_left top_right bottom_left bottom_right center)
    image.watermarking(watermark_image_path, position: 'center', save_to: your_watermarked_path)

    # you can also customize the size of watermark picture:
    # using /\d+x\d+/
    image.watermarking(watermark_image_path, save_to: your_watermarked_path, resize_to: '177x20')

    # using percentage, and set position
    image.watermarking(watermark_image_path, save_to: your_watermarked_path, resize_to: '60%', position: '100,230')

## Work with paperclip and Rails

Suppose a model user.rb has :avatar attachment based on paperclip, and I want to add watermark for the existing avatar.

Add some code to user.rb: (just for example)

    def watermark(watermark_path, options = {})
      ImageClipper::Image.new(avatar.path(:original)).watermarking(watermark_path, options)
      update_attribute(:avatar, avatar)
    end


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

