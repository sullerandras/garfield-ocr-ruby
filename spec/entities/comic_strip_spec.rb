require 'spec_helper'
require 'entities/comic_strip'
require 'entities/bw_image'

describe ComicStrip do
	describe '.ocr' do
		subject { ComicStrip.ocr(bw_image) }
		let(:bw_image) { double 'bw_image' }
		before { ComicStrip.should_receive(:ocr_bubbles).with(bw_image).and_return(bubbles) }
		let(:bubbles) { double 'bubbles' }
		it { should be_a ComicStrip }
		its(:bubbles) { should == bubbles }
	end
	describe '#bubbles' do
		subject { ComicStrip.new(bubbles).bubbles }
		let(:bubbles) { double 'bubbles' }
		it { should == bubbles }
	end
	describe '.ocr_bubbles' do
		def image_from_string(s)
			BWImage.new(s)
		end
		context '1x1 black image' do
			subject { ComicStrip.ocr_bubbles(image_from_string("x")) }
			it { should == [] }
		end
		context '1x1 white image' do
			subject { ComicStrip.ocr_bubbles(image_from_string(".")) }
			its(:count) { should == 1 }
			its('first.to_s') { should == "." }
		end
		context 'multiple white areas' do
			subject { ComicStrip.ocr_bubbles(image_from_string(".x..")) }
			its(:count) { should == 2 }
			its('first.to_s') { should == "." }
			its('last.to_s') { should == ".." }
		end
		context 'white area with a hole' do
			subject { ComicStrip.ocr_bubbles(image_from_string("....\n.xx.\n....")) }
			its(:count) { should == 1 }
			its('first.to_s') { should == "....\n.xx.\n...." }
		end
	end
	describe '#transliteration' do

	end
end
