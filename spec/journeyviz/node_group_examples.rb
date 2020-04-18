# frozen_string_literal: true

RSpec.shared_examples 'node group' do
  describe '#screen' do
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

    it 'returns newly created screen' do
      expect(instance.screen(:foobar)).to be_a(Journeyviz::Screen)
    end
  end

  describe '#block' do
    it 'adds defined blocks to an list' do
      expect { instance.block(:foobar) {} }.to change(instance, :blocks)
    end

    it 'yields block' do
      expect { |block| instance.block(:foobar, &block) }.to yield_control
    end

    it 'raises error when duplicated block name is defined' do
      expect { 2.times { instance.block(:foobar) {} } }
        .to raise_error(
          Journeyviz::DuplicatedDefinition,
          'Duplicated block name: foobar'
        )
    end

    it 'returns newly created block' do
      expect(instance.block(:foobar) {}).to be_a(Journeyviz::Block)
    end
  end

  describe '#find_screen' do
    subject { instance.find_screen(qualifier) }
    let(:qualifier) { screen1.full_qualifier }

    let!(:screen1) { instance.screen(:foo) }
    let!(:screen2) { instance.screen(:bar) }

    it 'finds screen with matching qualifier' do
      is_expected.to eq screen1
    end
  end

  describe '#screens' do
    subject { instance.screens }

    before { instance.screen(:foobar) }

    it { is_expected.to be_a(Array).and all be_a(Journeyviz::Screen) }

    context 'when it has blocks' do
      before { instance.block(:foo_block) { |block| block.screen(:foo_screen) } }

      it 'includes blocks screens' do
        expect(subject.size).to eq 2
      end
    end
  end
end
