require 'entities/bubble'

class ComicStrip
	def initialize(bubbles)
		@bubbles = bubbles
	end
	def bubbles
		@bubbles
	end

	def self.ocr(bw_image)
		ComicStrip.new ComicStrip.ocr_bubbles(bw_image)
	end
	def self.ocr_bubbles(bw_image)
		bubbles = []
		bw_image.each_with_indexes do |is_black, row, col|
			if !is_black
				bubble = Bubble.new(row, col)
				points = [ [row, col] ]
				while points.count > 0
					y, x = points.pop
					if bw_image.contains(y, x) && bw_image.is_white(y, x)
						bubble.add(y, x)
						bw_image.set_black(y, x)
						points << [y + 1, x]
						points << [y, x + 1]
						points << [y - 1, x]
						points << [y, x - 1]
					end
				end
				bubbles << bubble
			end
		end
		bubbles
	end
end
