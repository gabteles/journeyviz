# frozen_string_literal: true

RSpec.describe Journeyviz::Screen do
  it_behaves_like 'having a normalized name' do
    subject { described_class.new(name) }
    let(:name) { :foobar }
  end

  it_behaves_like 'scopable' do
    let(:instance) { described_class.new(qualifier, scope) }
  end

  describe '#action' do
    let(:instance) { described_class.new(:foobar) }

    it 'adds defined actions to an list' do
      expect { instance.action(:foobar) {} }.to change(instance, :actions)
    end

    it 'raises error when duplicated action name is defined' do
      expect { 2.times { instance.action(:foobar) {} } }
        .to raise_error(
          Journeyviz::DuplicatedDefinition,
          'Duplicated action name: foobar'
        )
    end
  end
end
