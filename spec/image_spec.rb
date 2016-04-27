require 'spec_helper'
require 'image_clipper/image'

describe ImageClipper::Image do
	let :image_1 do
		`cp test/tmp/original/test_image.jpg test/tmp/`
		ImageClipper::Image.new('test/tmp/test_image.jpg')
	end

	it "new image and read attributes" do
		image_1.path.should eql('test/tmp/test_image.jpg')
		image_1.type.should == 'JPEG'
		# image_1.file_size.should == '42.3KB'
		image_1.geometry.width.should == 1258
		image_1.geometry.height.should == 900
	end

	describe 'resize image' do
		it 'resize image to a new file' do
			new_image = image_1.resize('629x450', 'test/tmp/new_test_image.jpg')
			new_image.path.should == 'test/tmp/new_test_image.jpg'
			new_image.geometry.width.should == 629
			new_image.geometry.height.should == 450
		end

		it 'resize image to the original file' do
			new_image = image_1.resize('629x450')
			new_image.path.should == image_1.path
			new_image.geometry.width.should == 629
			new_image.geometry.height.should == 450
		end

		it 'resize image with percentage' do
			percent = '20%'
			percentage = percent.to_f / 100
			new_image = image_1.resize(percent, "test/tmp/resize_test_image_#{percent}.jpg")
			new_image.path.should == "test/tmp/resize_test_image_#{percent}.jpg"
			new_image.geometry.width.should == (image_1.geometry.width * percentage).round
			new_image.geometry.height.should == (image_1.geometry.height * percentage).round
		end
	end

	describe 'watermarking' do
		it 'add watermark at right bottom corner as default' do
			image_1.watermarking('test/tmp/original/watermark.png')
		end

		it "add watermark at custom position, saving at new image path" do
			%W(top_left top_right bottom_left bottom_right center).each do |pos|
				image_1.watermarking('test/tmp/original/watermark.png', position: pos, save_to: "test/tmp/watermarked_#{pos}.jpg")
			end
		end


		it "add watermark with special size" do
			image_1.watermarking('test/tmp/original/watermark.png', save_to: "test/tmp/watermarked_resize1.jpg", resize_to: '177x20')
			image_1.watermarking('test/tmp/original/watermark.png', save_to: "test/tmp/watermarked_resize2.jpg", resize_to: '60%', position: '100,230')
		end
	end
end
