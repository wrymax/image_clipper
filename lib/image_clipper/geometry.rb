require 'image_clipper'

module ImageClipper
	class Geometry
		attr_accessor :width, :height

		def initialize(attrs)
			case attrs
			when String
				raise ArgumentError unless attrs.match(/^\w+x\w+$/)
				geo = attrs.split('x')
				@width = geo[0].to_i
				@height = geo[1].to_i
			when Hash
				@width = attrs[:width].to_i
				@height = attrs[:height].to_i
			end
		end
	end
end
