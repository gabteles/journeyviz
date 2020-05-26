# frozen_string_literal: true

RSpec.describe Journeyviz do
  describe '.configure' do
    describe 'journey definition' do
      it 'validates definition of every transition' do
        expect do
          Journeyviz.configure do |journey|
            journey.screen(:one) do |screen|
              screen.action :foobar, transition: :non_existing_screen
            end
          end
        end.to raise_error(Journeyviz::InvalidTransition)
      end
    end
  end

  describe '.identify' do
    subject { described_class.identify(user_id) }
    let(:user_id) { rand(10_000).to_s(16) }

    it 'sets user id to current context' do
      expect { subject }.to change { described_class.context }.to include(user_id: user_id)
    end

    context 'when handling multiple threads' do
      it 'keeps a record per thread' do
        expect { Thread.new { subject }.join }.to_not change { described_class.context }
      end
    end
  end
end
