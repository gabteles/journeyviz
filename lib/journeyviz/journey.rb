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
      invalid_transition = action.transitions.find_index(nil)
      return unless invalid_transition

      transition_definition = action.raw_transitions[invalid_transition]

      message = "Action #{action.name.inspect} "
      message += "on screen #{action.screen.full_qualifier.inspect} "
      message += "has invalid transition: #{transition_definition.inspect}"
      raise(Journeyviz::InvalidTransition, message)
    end
  end
end
