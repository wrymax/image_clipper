require 'spec_helper'
require 'image_clipper/geometry'

describe ImageClipper::Geometry do
	it "new geometry with multiple ways" do
		geo1 = ImageClipper::Geometry.new('640x480')
		geo2 = ImageClipper::Geometry.new(width: 640, height: 480)

		geo1.width.should == 640
		geo1.height.should == 480

		geo2.width.should == 640
		geo2.height.should == 480
	end
end
