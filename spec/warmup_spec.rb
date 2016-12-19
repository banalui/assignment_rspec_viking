require 'warmup'

describe Warmup do
	
	let(:warmup){ Warmup.new }

	let(:an_object_to_triple_size) do 
    	double("Array",  size: 12 )
  	end

	it 'can shout' do
		allow(warmup).to receive(:gets).and_return("akbar")
		expect(warmup).to receive(:puts).with("AKBAR")
		warmup.gets_shout
	end

	it 'can triple size' do
		expect(warmup.triple_size(an_object_to_triple_size)).to eq(36)
	end

	it 'raises an error with bad input string' do
		an_empty_string = ""
		expect{warmup.calls_some_methods(an_empty_string)}.to raise_error("Hey, give me a string!")
	end

	it 'can send upcase to a string' do
		string = "behdad"
		expect(string).to receive(:upcase!).and_return(string.upcase!)
		expect(string).to eq("BEHDAD")
		warmup.calls_some_methods(string)
	end

	it 'can send reverse to a string' do
		string = "behdad"
		expect(string).to receive(:reverse!).and_return(string.reverse!)
		expect(string).to eq("dadheb")
		warmup.calls_some_methods(string)
	end

	it 'returns a different object' do
		string = "behdad"
		returned_val = warmup.calls_some_methods(string)
		expect(returned_val).not_to eq(string)
		expect(returned_val.object_id).not_to eq(string.object_id)
		expect(returned_val).to eq("I am unrelated")
	end

end