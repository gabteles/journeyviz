# frozen_string_literal: true

RSpec.shared_examples 'having screens' do
  it 'adds defined screens to an list' do
    expect { instance.screen(:foobar) }.to change(instance, :screens)
  end

  it 'allows screens definition without block' do
    expect { instance.screen(:foobar) }.to_not raise_error
  end

  it 'yields screen when block is given' do
    expect { |block| instance.screen(:foobar, &block) }.to yield_control
  end

  it 'raises error when duplicated screen name is defined' do
    expect { 2.times { instance.screen(:foobar) } }
      .to raise_error(
        Journeyviz::DuplicatedDefinition,
        'Duplicated screen name: foobar'
      )
  end
end
