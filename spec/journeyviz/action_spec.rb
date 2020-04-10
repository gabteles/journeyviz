# frozen_string_literal: true

RSpec.describe Journeyviz::Action do
  subject { described_class.new(name) }
  let(:name) { :foobar }

  it_behaves_like 'having a normalized name'
end
