require 'entities/bw_image'

class Bubble
	def initialize(row, col, included=true)
		@points = [ included ? [row, col] : [] ]
		@left = col
		@right = col
		@top = row
		@bottom = row
	end
	def top
		@top
	end
	def bottom
		@bottom
	end
	def left
		@left
	end
	def right
		@right
	end
	def width
		@right - @left + 1
	end
	def height
		@bottom - @top + 1
	end
	def add(row, col, included=true)
		if included
			@points << [row, col]
		end
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
	def self.from_s(pattern)
		bubble = nil
		pattern.split("\n").each_with_index do |line, row|
			line.each_char.each_with_index do |ch, col|
				if ch == BWImage::WHITE
					if bubble.nil?
						bubble = new row, col
					else
						bubble.add(row, col)
					end
				end
			end
		end
		bubble
	end
	def recognize_lines
		bubble = self
		res = []
		while bubble.height > 0
			was = false
			(bubble.top..bubble.bottom).each do |row|
				if is_empty_row row
					res << Line.new(self.slice(top: bubble.top, bottom: row - 1))
					bubble = bubble.slice(top: row + 1, bottom: bubble.bottom).trim_top_and_bottom
					was = true
					break
				end
			end
			if !was
				res << Line.new(bubble)
				break
			end
		end
		res
	end
	def trim_top_and_bottom
		top = @top
		while is_empty_row top
			top += 1
		end
		bottom = @bottom
		while is_empty_row bottom
			bottom -= 1
		end
		if top != @top || bottom != @bottom
			slice top: top, bottom: bottom
		else
			self
		end
	end

	def is_empty_row row
		(@left..@right).each do |col|
			return false if self[row, col] != BWImage::WHITE
		end
		return true
	end

	def slice options
		if !options.has_key? :top
			options[:top] = @top
		end
		if !options.has_key? :bottom
			options[:bottom] = @bottom
		end
		if !options.has_key? :left
			options[:left] = @left
		end
		if !options.has_key? :right
			options[:right] = @right
		end
		bubble = nil
		(@top..@bottom).each do |row|
			(@left..@right).each do |col|
				if (row >= options[:top] && row <= options[:bottom] && col >= options[:left] && col <= options[:right])
					included = (self[row, col] == BWImage::WHITE)
					if bubble.nil?
						bubble = Bubble.new row, col, included
					else
						bubble.add row, col, included
					end
				end
			end
		end
		bubble
	end
end
