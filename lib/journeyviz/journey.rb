# frozen_string_literal: true

require 'journeyviz/has_screens'
require 'journeyviz/block'

module Journeyviz
  class Journey
    include HasScreens
    attr_reader :blocks

    def initialize
      @blocks = []
    end

    def block(name, &definition)
      block = Block.new(name)

      if blocks.any? { |defined_block| block.name == defined_block.name }
        raise DuplicatedDefinition, "Duplicated block name: #{name}"
      end

      @blocks << block
      definition.call(block)
    end
  end
end
