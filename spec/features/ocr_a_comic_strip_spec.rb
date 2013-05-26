require 'spec_helper'
require 'entities/comic_strip'
require 'interactors/garfield_ocr'

describe 'OCR a comic strip' do
	it 'default' do
		strip = GarfieldOCR.ocr('spec/fixtures/2013-02-25.gif')
		strip.transliteration.should == 'GONNA SNEEZE\n--\nWAH-CHOO!\n--\nGOOD ONE\n'
	end
end
# 		strip.bubbles.count.should == 3

# 		bubble = strip.bubbles.first
# 		bubble.comic_number.should == 1
# 		bubble.words.count.should == 2
# 		bubble.words.first.transliteration = 'GONNA'
# 		bubble.words.last.transliteration = 'SNEEZE'
# 		bubble.transliteration.should == 'GONNA SNEEZE'

# 		bubble = strip.bubbles.second
# 		bubble.comic_number.should == 2
# 		bubble.words.count.should == 1
# 		bubble.words.first.transliteration = 'WAH-CHOO!'
# 		bubble.transliteration.should == 'WAH-CHOO!'

# 		bubble = strip.bubbles.last
# 		bubble.comic_number.should == 3
# 		bubble.words.count.should == 2
# 		bubble.words.first.transliteration = 'GOOD'
# 		bubble.words.last.transliteration = 'ONE'
# 		bubble.transliteration.should == 'GOOD ONE'

# 		strip.transliteration.should == 'GONNA SNEEZE\n--\nWAH-CHOO!\n--\nGOOD ONE\n'
# 	end
# end
