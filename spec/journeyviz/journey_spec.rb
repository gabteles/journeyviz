# frozen_string_literal: true

RSpec.describe Journeyviz::Journey do
  subject { described_class.new }

  it_behaves_like 'having screens' do
    let(:instance) { described_class.new }
  end

  describe 'blocks definition' do
    it 'adds defined blocks to an list' do
      expect { subject.block(:foobar) {} }.to change(subject, :blocks)
    end

    it 'yields block' do
      expect { |block| subject.block(:foobar, &block) }.to yield_control
    end

    it 'raises error when duplicated block name is defined' do
      expect { 2.times { subject.block(:foobar) {} } }
        .to raise_error(
          Journeyviz::DuplicatedDefinition,
          'Duplicated block name: foobar'
        )
    end
  end
end
