require "weapons/bow"

describe Bow  do
	let(:bow_default){ Bow.new }
	
	describe '#initialize' do
		
		let(:bow_20){ Bow.new(20) }

		it 'can read arrow count' do
			expect(bow_default).to respond_to(:arrows)
		end

		it 'starts with 10 arrows by default' do
			expect(bow_default.arrows).to eq(10)
		end

		it 'can take arrow count and set instance properly' do
			expect(bow_20.arrows).to eq(20)
		end

	end

	describe '#using bow' do

		let(:bow_no_arrow){Bow.new(0)}

		it 'throws error when no bows left' do
			expect{bow_no_arrow.use}.to raise_error("Out of arrows")
		end

		it 'reduces arrow count when we use' do
			bow_default.use
			expect(bow_default.arrows).to eq(9)
		end
	end
end