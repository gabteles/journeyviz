# frozen_string_literal: true

RSpec.describe Journeyviz do
  describe '.configure' do
    describe 'journey definition' do
      it 'keeps track of every screen defined on main block' do
        Journeyviz.configure do |journey|
          journey.screen(:one) {}
          journey.screen(:two) {}
        end

        expect(Journeyviz.journey.screens.map(&:name)).to eq [:one, :two]
      end
    end
  end
end
