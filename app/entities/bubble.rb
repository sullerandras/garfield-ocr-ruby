require 'entities/bw_image'

class Bubble
	def initialize(row, col)
		@points = [ [row, col] ]
		@left = col
		@right = col
		@top = row
		@bottom = row
	end
	def width
		@right - @left + 1
	end
	def height
		@bottom - @top + 1
	end
	def add(row, col)
		@points << [row, col]
		@left = col if col < @left
		@right = col if col > @right
		@top = row if row < @top
		@bottom = row if row > @bottom
	end
	def to_s
		# puts "Bubble(#{@points}, #{@left}, #{@top}, #{@right}, #{@bottom})"
		(@top..@bottom).map do |row|
			(@left..@right).map{ |col| self[row, col] }.join
		end.join("\n")
	end
	def [](row, col)
		@points.include?([row, col]) ? BWImage::WHITE : BWImage::BLACK
	end
end
