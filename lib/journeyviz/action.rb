# frozen_string_literal: true

module Journeyviz
  class Action
    attr_reader :name, :transitions

    def initialize(name, transitions: [])
      @name = name
      @transitions = transitions
    end
  end
end
