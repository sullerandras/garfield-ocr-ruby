require 'spec_helper'
require 'entities/bubble'
require 'entities/line'

describe Bubble do
	describe 'initialize' do
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
	describe '.from_s' do
		it 'creates a Bubble object with the given pattern' do
			b = Bubble.from_s(".x\nx.")
			b.to_s.should == ".x\nx."
		end
	end
	describe '#recognize_lines' do
		context 'one line' do
			it 'one character' do
				b = Bubble.from_s([
					'x...',
					'.xxx',
					'...x',
					'.xxx',
					'x...',
					].join("\n"))
				res = b.recognize_lines
				res.count.should == 1
				res.first.should be_a Line
				res.first.to_s.should == b.to_s
			end
			it 'multiple characters' do
				b = Bubble.from_s([
					'....xx....xx....',
					'.xxxxx.xxxxx.xxx',
					'...xxx...xxx...x',
					'.xxxxx.xxxxx.xxx',
					'....xx....xx....',
					].join("\n"))
				res = b.recognize_lines
				res.count.should == 1
				res.first.should be_a Line
				res.first.to_s.should == b.to_s
			end
		end
		context '2 lines' do
			it 'one character' do
				line1 = [
					'x...',
					'.xxx',
					'...x',
					'.xxx',
					'.xxx',
					].join("\n")
				line2 = [
					'x...',
					'.xxx',
					'...x',
					'.xxx',
					'x...',
					].join("\n")
				b = Bubble.from_s([line1, line2].join("\n....\n"))
				res = b.recognize_lines
				res.count.should == 2
				res.first.should be_a Line
				res.first.to_s.should == line1
				res.last.should be_a Line
				res.last.to_s.should == line2
			end
			it 'multiple characters' do
				line1 = [
					'....xx....xx....',
					'.xxxxx.xxxxx.xxx',
					'...xxx...xxx...x',
					'.xxxxx.xxxxx.xxx',
					'....xx....xx....',
					].join("\n")
				line2 = [
					'.xxxxx....xx....',
					'.xxxxx.xxxxx.xxx',
					'.xxxxx...xxx...x',
					'.xxxxx.xxxxx.xxx',
					'....xx....xx....',
					].join("\n")
				b = Bubble.from_s([line1, line2].join("\n................\n"))
				res = b.recognize_lines
				res.count.should == 2
				res.first.should be_a Line
				res.first.to_s.should == line1
				res.last.should be_a Line
				res.last.to_s.should == line2
			end
		end
		context 'multiple lines' do
		end
	end
	describe '#is_empty_row' do
		it do
			b = Bubble.from_s "....\n..xx\n....\n...."
			b.is_empty_row(0).should be_true
			b.is_empty_row(1).should be_false
			b.is_empty_row(2).should be_true
			b.is_empty_row(3).should be_true
		end
	end
	describe '#slice' do
		it 'handles top & bottom' do
			b = Bubble.from_s "x...\n..xx\n.x..\n..x."
			b.slice(top: 0, bottom: 3).to_s.should == "x...\n..xx\n.x..\n..x."
			b.slice(top: 1, bottom: 3).to_s.should == "..xx\n.x..\n..x."
			b.slice(top: 1, bottom: 1).to_s.should == "..xx"
		end
		it 'handles left & right' do
			b = Bubble.from_s "x...\n..xx\n.x..\n..x."
			b.slice(left: 0, right: 3).to_s.should == "x...\n..xx\n.x..\n..x."
			b.slice(left: 1, right: 3).to_s.should == "...\n.xx\nx..\n.x."
			b.slice(left: 1, right: 1).to_s.should == ".\n.\nx\n."
		end
	end
end
