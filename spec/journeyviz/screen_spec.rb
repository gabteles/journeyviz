# frozen_string_literal: true

RSpec.describe Journeyviz::Screen do
  subject { described_class.new(name) }
  let(:name) { :foobar }

  it_behaves_like 'having a normalized name'

  describe 'actions definition' do
    it 'adds defined actions to an list' do
      expect { subject.action(:foobar) {} }.to change(subject, :actions)
    end

    it 'raises error when duplicated action name is defined' do
      expect { 2.times { subject.action(:foobar) {} } }
        .to raise_error(
          Journeyviz::DuplicatedDefinition,
          'Duplicated action name: foobar'
        )
    end
  end
end
