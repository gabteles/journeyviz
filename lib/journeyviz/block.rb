# frozen_string_literal: true

require 'journeyviz/normalized_name'
require 'journeyviz/has_screens'

module Journeyviz
  class Block
    include NormalizedName
    include HasScreens

    def initialize(name)
      assign_normalize_name(name)
    end
  end
end
