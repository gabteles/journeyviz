# frozen_string_literal: true

require 'journeyviz/normalized_name'

module Journeyviz
  class Action
    include NormalizedName

    attr_reader :transitions

    def initialize(name, transitions: [])
      assign_normalize_name(name)
      @transitions = transitions
    end
  end
end
