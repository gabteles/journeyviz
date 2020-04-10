# frozen_string_literal: true

RSpec.shared_examples 'having a normalized name' do
  it 'has a name' do
    expect(subject.name).to be_a Symbol
  end

  context 'when name is given as string' do
    let(:name) { 'foobar' }

    it 'converts to symbol' do
      expect(subject.name).to eq :foobar
    end
  end

  [
    ['name is empty', ''],
    ['no name is given', nil],
    ['name is nor a String or Symbol', Object.new]
  ].each do |(context_name, invalid_name)|
    context "when #{context_name}" do
      let(:name) { invalid_name }

      it 'raises error' do
        expect { subject }
          .to raise_error(
            Journeyviz::InvalidNameError,
            "Invalid name given: #{name.inspect}"
          )
      end
    end
  end
end
