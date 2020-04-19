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
end
