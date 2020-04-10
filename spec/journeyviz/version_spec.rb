# frozen_string_literal: true

RSpec.describe 'Journeyviz::VERSION' do
  subject { Journeyviz::VERSION }

  it { is_expected.to be_a(String) }
end
