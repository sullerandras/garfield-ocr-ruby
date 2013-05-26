class BWImage
	BLACK = 'x'
	WHITE = '.'

	def initialize(data)
		@width, @height = BWImage.determine_size(data)
		@data = data
	end
	def to_s
		@data
	end
	def width
		@width
	end
	def height
		@height
	end
	def [](row, col)
		raise 'Invalid coordinates' if not contains(row, col)
		@data[col + (width + 1) * row]
	end
	def contains(row, col)
		row >= 0 && row < height && col >= 0 && col < width
	end
	def is_white(row, col)
		self[row, col] == WHITE
	end
	def set_black(row, col)
		@data[col + (width + 1) * row] = BLACK
	end
	def each_with_indexes
		i = 0
		row = 0
		col = 0
		while i < @data.length
			ch = @data[i]
			if ch != "\n"
				yield [(ch == BLACK), row, col]
				col += 1
			else
				row += 1
				col = 0
			end
			i += 1
		end
	end

	def self.from_string(data)
		BWImage.new data
	end
	def self.determine_size(data)
		data.each_byte do |ch|
			if not [BLACK, WHITE, "\n"].include? ch.chr
				raise "Invalid character: #{ch.chr}"
			end
		end
		raise 'Last line is empty' if data[-1] == "\n"
		row_lengths = data.split("\n").map(&:length)
		raise 'Some line has different length' if row_lengths.uniq.count != 1
		[row_lengths.first, row_lengths.count]
	end
end
