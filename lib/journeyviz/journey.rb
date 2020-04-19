# frozen_string_literal: true

require 'journeyviz/node_group'
require 'journeyviz/block'

module Journeyviz
  class Journey
    include NodeGroup

    def initialize
      @blocks = []
    end

    def validate!
      screens.each do |screen|
        screen.actions.each { |action| validate_action(action) }
      end
    end

    private

    def validate_action(action)
      return if action.transition || !action.raw_transition

      message = "Action #{action.name.inspect} "
      message += "on screen #{action.screen.full_qualifier.inspect} "
      message += "has invalid transition: #{action.raw_transition.inspect}"
      raise(Journeyviz::InvalidTransition, message)
    end
  end
end
