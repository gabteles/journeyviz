# frozen_string_literal: true

RSpec.shared_examples 'scopable' do
  class DummyScopable
    include Journeyviz::Scopable[:qualifier]
    attr_reader :qualifier

    def initialize(qualifier, scope)
      @qualifier = qualifier
      assign_scope(scope)
    end
  end

  describe '#root_scope' do
    subject { instance.root_scope }
    let(:root_scope) { Object.new }
    let(:scope1) { DummyScopable.new(:scope1, root_scope) }
    let(:scope) { DummyScopable.new(:scope2, scope1) }
    let(:qualifier) { :foobar }

    it 'returns first node of scope chain' do
      is_expected.to eq root_scope
    end
  end

  describe '#full_scope' do
    subject { instance.full_scope }
    let(:root_scope) { Object.new }
    let(:scope1) { DummyScopable.new(:scope1, root_scope) }
    let(:scope) { DummyScopable.new(:scope2, scope1) }
    let(:qualifier) { :foobar }

    it 'collects every node until no upper scope is visible' do
      is_expected.to eq [root_scope, scope1, scope]
    end
  end

  describe '#full_qualifier' do
    subject { instance.full_qualifier }
    let(:qualifier) { :foobar }

    context 'when scope is not informed' do
      let(:scope) { nil }

      it 'is the qualifier only' do
        is_expected.to eq [:foobar]
      end
    end

    context 'when scope is informed' do
      let(:scope) { DummyScopable.new(:block, nil) }

      it 'joins scope qualifier and screen qualifier' do
        is_expected.to eq %i[block foobar]
      end
    end

    context 'when scope does not respond to full qualifier' do
      let(:scope) { Object.new }

      it 'is the qualifier only' do
        is_expected.to eq [:foobar]
      end
    end
  end
end
