# frozen_string_literal: true

require 'journeyviz/has_screens'
require 'journeyviz/block'

module Journeyviz
  class Journey
    include HasScreens

    def initialize
      @blocks = []
    end

    def block(name, &definition)
      block = Block.new(name)
      @blocks << block
      definition.call(block)
    end
  end
end
