require 'RMagick'
include Magick

class GarfieldOCR
	WHITE_THRESHOLD = 100
	def self.ocr(filename)
		width, height, pixels = readImage(filename)
		bw_pixels = convert_to_black_and_white(width, height, pixels)
		bw_image = BWImage.new(bw_pixels)
		ComicStrip.ocr bw_image
	end
	def self.readImage(filename)
		imgs = Image.read(filename)
		if imgs.count != 1
			raise "There should be exactly one image, but got #{imgs.count}."
		end
		img = imgs.first
		[img.columns, img.rows, imgs.first.export_pixels_to_str]
	end
	def self.convert_to_black_and_white(width, height, pixels)
		raise if width * height * 3 != pixels.length
		bw_pixels = pixels.chars.each_slice(3).map do |r, g, b|
			if r.ord >= WHITE_THRESHOLD && g.ord >= WHITE_THRESHOLD && b.ord >= WHITE_THRESHOLD &&
				(r.ord - g.ord).abs <= 16 && (r.ord - b.ord).abs <= 16 && (g.ord - b.ord).abs <= 16
				BWImage::WHITE
			else
				BWImage::BLACK
			end
		end
		bw_pixels.each_slice(width).map do |slice|
			slice.join
		end.join("\n")
	end
end
