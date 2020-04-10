# frozen_string_literal: true

RSpec.describe Journeyviz::Block do
  subject { described_class.new(name) }
  let(:name) { :foobar }

  it_behaves_like 'having a normalized name'

  it_behaves_like 'having screens' do
    let(:instance) { described_class.new(:foobar) }
  end
end
