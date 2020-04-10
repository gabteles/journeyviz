# frozen_string_literal: true

require 'journeyviz/action'
require 'journeyviz/normalized_name'

module Journeyviz
  class Screen
    include NormalizedName
    attr_reader :actions

    def initialize(name)
      assign_normalize_name(name)
      @actions = []
    end

    def action(name, **params)
      action = Action.new(name, params)

      if actions.any? { |defined_action| action.name == defined_action.name }
        raise DuplicatedDefinition, "Duplicated action name: #{name}"
      end

      @actions << action
    end
  end
end
