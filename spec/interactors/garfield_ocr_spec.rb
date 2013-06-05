#encoding: US-ASCII
require 'spec_helper'
require 'interactors/garfield_ocr'
require 'entities/comic_strip'
require 'RMagick'
include Magick

describe GarfieldOCR do
	it 'constants' do
		GarfieldOCR::WHITE_THRESHOLD.should == 100
	end
	describe '.ocr' do
		subject { GarfieldOCR.ocr(filename) }
		before { GarfieldOCR.should_receive(:readImage).with(filename).and_return([width, height, pixels]) }
		let(:filename) { 'garfield_comic_strip.gif' }
		let(:pixels) { double 'pixels' }
		let(:width) { double 'width' }
		let(:height) { double 'height' }
		before { GarfieldOCR.should_receive(:convert_to_black_and_white).with(width, height, pixels).and_return(bw_pixels) }
		let(:bw_pixels) { double 'bw_pixels' }
		before { BWImage.should_receive(:new).with(bw_pixels).and_return(bw_image) }
		let(:bw_image) { double 'bw_image' }
		before { ComicStrip.should_receive(:ocr).with(bw_image).and_return(strip) }
		let(:strip) { double 'strip' }
		it { should == strip }
	end
	describe '.readImage' do
		it "1x1 black image" do
			img = Image.new(1, 1) { self.background_color = 'black' }
			img.write('test_black_1x1.gif')
			GarfieldOCR.readImage('test_black_1x1.gif').should == [1, 1, "\x00\x00\x00"]
		end
		it "1x2 white image" do
			img = Image.new(1, 2) { self.background_color = 'white' }
			img.write('test_white_1x2.gif')
			GarfieldOCR.readImage('test_white_1x2.gif').should == [1, 2, "\xFF\xFF\xFF\xFF\xFF\xFF"]
		end
	end
	describe '.convert_to_black_and_white' do
		it 'converts black pixels to black (x)' do
			GarfieldOCR.convert_to_black_and_white(1, 1, "\x00\x00\x00").should == 'x'
		end
		it 'converts white pixels to white (.)' do
			GarfieldOCR.convert_to_black_and_white(1, 1, "\xFF\xFF\xFF").should == '.'
		end
		it 'converts pixels whiter than WHITE_THRESHOLD to white (.)' do
			GarfieldOCR.convert_to_black_and_white(1, 1, "\x64\x64\x64").should == '.'
		end
		it 'converts pixels darker than WHITE_THRESHOLD to black (x)' do
			GarfieldOCR.convert_to_black_and_white(1, 1, "\x63\x63\x63").should == 'x'
		end
		it 'treats non-gray pixels as black' do
			GarfieldOCR.convert_to_black_and_white(1, 1, "\xFF\xBF\x8F").should == 'x'
		end
		it 'treats grayish pixels as white' do
			GarfieldOCR.convert_to_black_and_white(1, 1, "\xEF\xF8\xFF").should == '.'
		end
		it 'handles multiple pixels' do
			GarfieldOCR.convert_to_black_and_white(3, 1, "\x00\x00\x00\xFF\xFF\xFF\x00\x00\x00").should == 'x.x'
		end
		it 'returns multiline image as a multiline string' do
			GarfieldOCR.convert_to_black_and_white(1, 2, "\x00\x00\x00\xFF\xFF\xFF").should == "x\n."
		end
		it 'raises error if the image size does not match the length of pixels' do
			expect{ GarfieldOCR.convert_to_black_and_white(1, 1, "\x00\x00\x00\xFF\xFF\xFF") }.to raise_error
		end
	end
end
