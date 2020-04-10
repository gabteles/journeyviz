# frozen_string_literal: true

module Journeyviz
  class Screen
    def initialize(name)
      @name = name
      @actions = []
    end

    def action(name, **params)
      # TODO: Validate name
      @actions << Action.new(name, params)
    end

    attr_reader :name
  end
end
