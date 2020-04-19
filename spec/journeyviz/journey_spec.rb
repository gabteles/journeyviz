# frozen_string_literal: true

RSpec.describe Journeyviz::Journey do
  let(:instance) { described_class.new }

  it_behaves_like 'node group'

  describe '#validate!' do
    subject { instance.validate! }

    it 'validates definition of every transition' do
      instance.screen(:one) do |screen|
        screen.action :foobar, transition: :non_existing_screen
      end

      expect { subject }.to raise_error(
        Journeyviz::InvalidTransition,
        'Action :foobar on screen [:one] has invalid transition: :non_existing_screen'
      )
    end

    it 'ignores action validation when without transitions' do
      instance.screen(:one) { |screen| screen.action :foobar }
      expect { subject }.to_not raise_error
    end
  end
end
