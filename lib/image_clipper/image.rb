# encoding: utf-8

# basic image class to represent an image

require 'image_clipper'
require 'image_clipper/geometry'

module ImageClipper
	class Image
		attr_accessor :file, :path, :file_size, :type, :geometry

		def initialize(file_path)
			@file = File.open(file_path)
			@path = file_path
			attributes = `identify #{file_path}`.split(' ')
			@type = attributes[1]
			@geometry = Geometry.new(attributes[2])
			@file_size = attributes[6]
		end

		def resize(new_size, new_file_path = self.path)
			geo = case new_size
			when /\d+x\d+/
				Geometry.new(new_size)
			when /\d+%/
				percent = new_size.to_f / 100
				Geometry.new("#{(geometry.width * percent).round}x#{(geometry.height * percent).round}")
			end

			`convert #{path} -resize '#{geo.width}x#{geo.height}' #{new_file_path}`

			Image.new(new_file_path)
		end

		def watermarking(watermark_path, options = {})
			# options:
			# 	position: the string position of watermark
			# 	save_to: the path to save watermarked image
			#		resize_to: the target size of watermark image

			# read the watermark
			watermark = Image.new watermark_path

			# config options
			options = { position: 'bottom_right' }.merge(options)

			# process resizing watermark
			if options[:resize_to]
				watermark_geo = case options[:resize_to]
				when /\d+%/
					watermark.geometry.width = (watermark.geometry.width * options[:resize_to].to_i / 100).round
					watermark.geometry.height = (watermark.geometry.height * options[:resize_to].to_i / 100).round
				when /\d+x\d+/
					resize_tmp = options[:resize_to].split('x')
					watermark.geometry.width = resize_tmp[0].to_i
					watermark.geometry.height = resize_tmp[1].to_i
				else
					raise ArgumentError, "resize_to argument format error, try '100x100' or '50%'"
				end
			end
			watermark_geo = "#{watermark.geometry.width},#{watermark.geometry.height}"

			# process watermark position
			pos_coord = case options[:position]
			when 'top_left'
				'0,0'
			when 'top_right'
				"#{geometry.width - watermark.geometry.width},0"
			when 'bottom_left'
				"0,#{geometry.height - watermark.geometry.height}"
			when 'bottom_right'
				"#{geometry.width - watermark.geometry.width},#{geometry.height - watermark.geometry.height}"
			when 'center'
				"#{(geometry.width - watermark.geometry.width) / 2},#{(geometry.height - watermark.geometry.height) / 2}"
			when /\d+,\d+/
				options[:position]
			else
				raise ArgumentError, "position argument missing"
			end

			# config the watermarked image path
			watermarked_path = options[:save_to] || path

			# process!
			# ap "convert #{path} -draw \"image SrcOver #{pos_coord} #{watermark_geo} #{watermark_path}\" #{watermarked_path}"
			`convert #{path} -draw "image SrcOver #{pos_coord} #{watermark_geo} #{watermark_path}" #{watermarked_path}`
			
			# return the new Image object
			Image.new(watermarked_path)
		end
	end
end
