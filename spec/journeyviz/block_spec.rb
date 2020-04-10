# frozen_string_literal: true

RSpec.describe Journeyviz::Block do
  subject { described_class.new(name) }
  let(:name) { :foobar }

  it 'has a name' do
    expect(subject.name).to eq name
  end

  context 'when empty name is given' do
    let(:name) { '' }
    it do
      expect { subject }
        .to raise_error(Journeyviz::InvalidNameError, 'Invalid block name given: ""')
    end
  end

  context 'when no name is given' do
    let(:name) { nil }
    it do
      expect { subject }
        .to raise_error(Journeyviz::InvalidNameError, 'Invalid block name given: nil')
    end
  end
end
