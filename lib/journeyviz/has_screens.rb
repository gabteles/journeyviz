# frozen_string_literal: true

require 'journeyviz/screen'

module Journeyviz
  module HasScreens
    def screen(name)
      @screens ||= []
      screen = Screen.new(name)

      if screens.any? { |defined_screen| screen.name == defined_screen.name }
        raise DuplicatedDefinition, "Duplicated screen name: #{name}"
      end

      screens.push(screen)
      yield screen if block_given?
    end

    attr_reader :screens
  end
end
