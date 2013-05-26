require 'spec_helper'
require 'entities/bubble'

describe Bubble do
	describe '.new' do
		it do
			b = Bubble.new(1, 2)
			b.width.should == 1
			b.height.should == 1
			b.to_s.should == '.'
		end
	end
	describe '#add' do
		it do
			b = Bubble.new(1, 2)
			b.add(0, 0)
			b.width.should == 3
			b.height.should == 2
			b.add(5, 10)
			b.width.should == 11
			b.height.should == 6
		end
	end
	describe '#to_s' do
		it do
			b = Bubble.new(1, 1)
			b.to_s.should == '.'
			b.add(0, 0)
			b.to_s.should == ".x\nx."
		end
	end
	describe '#[]' do
		it do
			b = Bubble.new(1, 1)
			b[1, 1].should == '.'
			# expect{ b[0, 1]}.to raise_error
			b.add(0, 0)
			b[0, 1].should == 'x'
			b[0, 0].should == '.'
		end
	end
end
