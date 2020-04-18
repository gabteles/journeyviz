# frozen_string_literal: true

RSpec.describe Journeyviz::Action do
  let(:instance) { described_class.new(name, screen, transitions: transitions) }
  let(:name) { :foobar }
  let(:screen) { Journeyviz::Screen.new(:foobar_screen) }
  let(:transitions) { [] }

  it_behaves_like 'having a normalized name' do
    subject { instance }
  end

  describe '#transitions' do
    subject { instance.transitions }

    let!(:journey) { Journeyviz::Journey.new }
    let!(:block) { journey.block(:same_block) {} }
    let!(:screen) { block.screen(:foobar_screen) }
    let!(:screen_in_same_scope) { block.screen(:screen_in_same_scope) }
    let!(:closer_ambiguous_screen) { block.screen(:ambiguous_screen) }
    let!(:other_block) { journey.block(:other_block) {} }
    let!(:screen_in_other_block) { other_block.screen(:screen_in_other_block) }
    let!(:root_screen) { journey.screen(:root_screen) }
    let!(:further_ambiguous_screen) { journey.screen(:ambiguous_screen) }

    before do
      screen.actions << instance

      # STRUCTURE:
      #
      # JOURNEY ─── same_block ──── foobar_screen
      #       │              ├───── screen_in_same_scope
      #       │              └───── ambiguous_screen (closer_ambiguous_screen)
      #       ├──── other_block ─── screen_in_other_block
      #       ├──── root_screen
      #       └──── ambiguous_screen (further_ambiguous_screen)
    end

    context 'when transition is a Symbol' do
      context 'and screen does not exist' do
        let(:transitions) { [:screen_does_not_exists] }

        it 'will be nil' do
          is_expected.to eq [nil]
        end
      end

      context 'and screen exists in same scope' do
        let(:transitions) { [:screen_in_same_scope] }

        it 'finds screen' do
          is_expected.to eq [screen_in_same_scope]
        end
      end

      context 'and screen exists in upper scope' do
        let(:transitions) { [:root_screen] }

        it 'finds screen' do
          is_expected.to eq [root_screen]
        end
      end

      context 'and screen exists but in non related journey branch' do
        let(:transitions) { [:screen_in_other_block] }

        it 'will be nil' do
          is_expected.to eq [nil]
        end
      end

      context 'and screen is ambiguous' do
        let(:transitions) { [:ambiguous_screen] }

        it 'prefers closer screen' do
          is_expected.to eq [closer_ambiguous_screen]
        end
      end
    end

    context 'when transition is an full qualifier (array)' do
      context 'and screen exists' do
        let(:transitions) { [%i[other_block screen_in_other_block]] }

        it 'finds screen' do
          is_expected.to eq [screen_in_other_block]
        end
      end

      context 'and screen does not exist' do
        let(:transitions) { [%i[other_block screen_does_not_exists]] }

        it 'will be nil' do
          is_expected.to eq [nil]
        end
      end
    end
  end
end
