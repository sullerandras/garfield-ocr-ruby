require 'spec_helper'
require 'entities/bw_image'

describe BWImage do
	describe 'constants' do
		it { BWImage::BLACK.should == "x" }
		it { BWImage::WHITE.should == "." }
	end
	describe '.new' do
		subject { BWImage.new(data) }
		let(:data) { double 'data' }
		before { BWImage.should_receive(:determine_size).with(data).and_return([1, 2]) }
		its(:to_s) { should == data }
		its(:width) { should == 1 }
		its(:height) { should == 2 }
	end
	describe '.determine_size' do
		context 'returns the dimensions of the matrix' do
			it { BWImage.determine_size(".").should == [1, 1] }
			it { BWImage.determine_size(".\n.").should == [1, 2] }
			it { BWImage.determine_size("....\n....").should == [4, 2] }
		end
		context 'accepts . and x' do
			it { BWImage.determine_size(".") }
			it { BWImage.determine_size("x") }
		end
		context 'passes when all line has the same length' do
			it { BWImage.determine_size(".\n.") }
			it { BWImage.determine_size(".....\nxxxxx\n.....") }
		end
		context 'raises error when the string has invalid characters' do
			it { expect{ BWImage.determine_size("A") }.to raise_error }
		end
		context 'raises error when lines have different length' do
			it { expect{ BWImage.determine_size(".\n") }.to raise_error }
			it { expect{ BWImage.determine_size(".\n.\n") }.to raise_error }
			it { expect{ BWImage.determine_size(".\n.\n..") }.to raise_error }
			it { expect{ BWImage.determine_size(".\n\n.") }.to raise_error }
		end
	end
	describe '#[]' do
		subject { BWImage.new(".x\n.x") }
		it { subject[0, 0].should == "." }
		it { subject[0, 1].should == "x" }
		it { subject[1, 0].should == "." }
		it { subject[1, 1].should == "x" }
		context 'invalid coordinates' do
			it { expect{ subject[2, 1] }.to raise_error }
			it { expect{ subject[-1, 0] }.to raise_error }
			it { expect{ subject[0, 2] }.to raise_error }
			it { expect{ subject[0, -1] }.to raise_error }
		end
	end
	describe '#contains' do
		subject { BWImage.new(".\nx") }
		it { subject.contains(0, 0).should == true }
		it { subject.contains(1, 0).should == true }

		it { subject.contains(2, 0).should == false }
		it { subject.contains(-1, 0).should == false }
		it { subject.contains(0, 1).should == false }
		it { subject.contains(0, -1).should == false }
	end
	describe '#is_white' do
		subject { BWImage.new(".\nx") }
		it { subject.is_white(0, 0).should == true }
		it { subject.is_white(1, 0).should == false }
	end
	describe '#set_black' do
		it do
			bw_image = BWImage.new(".")
			bw_image.is_white(0, 0).should == true
			bw_image.set_black(0, 0)
			bw_image.is_white(0, 0).should == false
		end
	end
	describe '#each_with_indexes' do
		it 'returns all pixel with coordinates' do
			results = []
			BWImage.new(".\nx").each_with_indexes do |is_black, row, col|
				results << [is_black, row, col]
			end
			results.should == [
				[false, 0, 0],
				[true, 1, 0],
			]
		end
		it 'raises error when no block given' do
			expect { BWImage.new('.').each_with_indexes }.to raise_error
		end
	end
end
