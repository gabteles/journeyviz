# frozen_string_literal: true

require 'journeyviz/action'
require 'journeyviz/normalized_name'
require 'journeyviz/scopable'

module Journeyviz
  class Screen
    include NormalizedName
    include Scopable[:name]
    attr_reader :actions, :scope

    def initialize(name, scope = nil)
      assign_normalize_name(name)
      @actions = []
      assign_scope(scope)
    end

    def action(name, **params)
      action = Action.new(name, self, params)

      if actions.any? { |defined_action| action.name == defined_action.name }
        raise DuplicatedDefinition, "Duplicated action name: #{name}"
      end

      @actions << action
    end
  end
end
