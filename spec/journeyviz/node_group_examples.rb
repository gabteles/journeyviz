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

  describe '#blocks' do
    before do
      instance.block(:a) do |child|
        child.block(:a_1) {}
        child.block(:a_2) {}
      end

      instance.block(:b) do |child|
        child.block(:b_1) {}
        child.block(:b_2) {}
      end
    end

    it 'returns direct children' do
      expect(instance.blocks.map(&:name)).to contain_exactly(:a, :b)
    end

    context 'when including children' do
      it 'returns full children chain' do
        expect(instance.blocks(include_children: true).map(&:name))
          .to contain_exactly(:a, :a_1, :a_2, :b, :b_1, :b_2)
      end
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

  describe '#inputs' do
    context "when instance's scope is not defined" do
      before { allow(instance).to receive(:root_scope).and_return(nil) }
      it { expect(instance.inputs).to eq [] }
    end

    context 'when there are other screens below same scope' do
      let(:target_block) { instance.block(:target_block) {} }
      let(:external_block) { instance.block(:external_block) {} }
      let(:scope_qualifier) { external_block.full_qualifier[0..-2] }
      let!(:external_screen) do
        external_block.screen(:external2) do |screen|
          screen.action(:external_to_external, transition: :external1)
          screen.action(
            :external_to_internal,
            transition: scope_qualifier + %i[target_block internal1]
          )
        end
      end

      before do
        target_block.screen(:internal1)
        target_block.screen(:internal2) do |screen|
          screen.action(:internal_action, transition: :internal1)
        end

        external_block.screen(:external1)
      end

      it "selects external screens that transition to this node group's screens" do
        expect(target_block.inputs).to contain_exactly(external_screen)
      end
    end
  end

  describe '#outputs' do
    subject { instance.outputs }

    let(:screen3) { double(:screen, actions: [double(:action, transition: screen4)]) }
    let(:screen4) { Journeyviz::Screen.new(:foobar) }

    before do
      instance.screen(:screen1)
      instance.screen(:screen2).action(:click, transition: :screen1)
      instance.instance_variable_get(:@screens) << screen3
    end

    it 'returns screens defined outside instance' do
      is_expected.to contain_exactly(screen4)
    end
  end
end
