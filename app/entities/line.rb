require 'entities/bw_image'

class Line < Bubble
	def initialize(bubble)
		super bubble.top, bubble.left, false
		(bubble.top..bubble.bottom).each do |row|
			(bubble.left..bubble.right).each do |col|
				add row, col, bubble[row, col] == BWImage::WHITE
			end
		end
	end
end
