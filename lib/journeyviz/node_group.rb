# frozen_string_literal: true

require 'journeyviz/screen'

module Journeyviz
  autoload :Block, 'journeyviz/block'

  module NodeGroup
    def block(name, &definition)
      block = Block.new(name, self)

      @blocks ||= []
      if @blocks.any? { |defined_block| block.name == defined_block.name }
        raise DuplicatedDefinition, "Duplicated block name: #{name}"
      end

      @blocks.push(block)
      definition.call(block)
      block
    end

    def blocks
      @blocks ||= []
    end

    def deep_blocks
      blocks.flat_map { |block| [block] + block.deep_blocks }
    end

    def screen(name)
      @screens ||= []
      screen = Screen.new(name, self)

      if @screens.any? { |defined_screen| screen.name == defined_screen.name }
        raise DuplicatedDefinition, "Duplicated screen name: #{name}"
      end

      @screens.push(screen)
      yield screen if block_given?
      screen
    end

    def screens
      @screens ||= []
      @screens + blocks.flat_map(&:screens)
    end

    def find_screen(qualifier)
      screens.find { |screen| screen.full_qualifier == qualifier }
    end

    def inputs
      options = defined?(root_scope) ? root_scope.screens : []
      self_screens = screens

      options.select do |screen|
        external_screen = !self_screens.include?(screen)
        transitions_to_internal = screen.actions.any? do |action|
          self_screens.include?(action.transition)
        end

        external_screen && transitions_to_internal
      end
    end

    def outputs
      screens
        .flat_map(&:actions)
        .map(&:transition)
        .compact
        .reject { |screen| screens.include?(screen) }
    end
  end
end
