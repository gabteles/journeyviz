# frozen_string_literal: true

RSpec.describe Journeyviz::Graphable do
  subject { instance.graph }
  let(:journey) { Journeyviz::Journey.new }

  before do
    journey.screen :top_level_screen do |screen|
      screen.action :top_level_action, transition: :other_top_level
      screen.action :deep_action, transition: %i[big_block1 screen1]
    end

    journey.screen :other_top_level

    journey.block :big_block1 do |block|
      block.screen(:screen1) do |screen|
        screen.action :action1, transition: %i[big_block2 screen2]
      end
    end

    journey.block :big_block2 do |block|
      block.screen(:screen2)
    end

    journey.block :big_block3 do |block|
    end
  end

  let(:instance) { journey }

  it 'adds direct children of the instance' do
    is_expected
      .to include('block_big_block1[big_block1]:::block')
      .and include('block_big_block2[big_block2]:::block')
      .and include('block_big_block3[big_block3]:::block')
      .and include('screen_top_level_screen[top_level_screen]:::screen')
  end

  it 'includes styles' do
    is_expected
      .to match(/^\s*classDef screen .*$/)
      .and match(/^\s*classDef transition .*$/)
      .and match(/^\s*classDef block .*$/)
  end

  it 'includes transitions between blocks' do
    is_expected
      .to include('block_big_block1 --> block_big_block2')
  end

  it 'includes transition nodes between screens and screens' do
    from_id = 'screen_top_level_screen'
    to_id = 'screen_other_top_level'
    expected_id = "transition_#{from_id}_top_level_action_#{to_id}"

    is_expected
      .to include("#{expected_id}(top_level_action):::transition")
      .and include("#{from_id} --- #{expected_id} --> #{to_id}")
  end

  it 'includes transition nodes between screens and blocks' do
    from_id = 'screen_top_level_screen'
    to_id = 'block_big_block1'
    expected_id = "transition_#{from_id}_deep_action_#{to_id}"

    is_expected
      .to include("#{expected_id}(deep_action):::transition")
      .and include("#{from_id} --- #{expected_id} --> #{to_id}")
  end

  it 'will not include inputs when there is no one' do
    is_expected.to_not include('subgraph inputs')
  end

  it 'will not include outputs when there is no one' do
    is_expected.to_not include('subgraph outputs')
  end
end
