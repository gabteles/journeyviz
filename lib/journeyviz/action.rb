# frozen_string_literal: true

require 'journeyviz/normalized_name'

module Journeyviz
  class Action
    include NormalizedName
    attr_reader :screen

    def initialize(name, screen, transitions: [])
      assign_normalize_name(name)
      @screen = screen
      @transitions = transitions
    end

    def transitions
      @transitions.map do |transition|
        case transition
        when Symbol then find_screen_by_name(transition)
        when Array then find_screen_by_full_qualifier(transition)
        end
      end
    end

    def raw_transitions
      @transitions
    end

    private

    def find_screen_by_name(screen_name)
      qualifier = screen.full_qualifier

      (qualifier.size - 1).downto(0) do |len|
        found_screen = find_screen_by_full_qualifier(qualifier[0, len] + [screen_name])
        return found_screen if found_screen
      end

      nil
    end

    def find_screen_by_full_qualifier(qualifier)
      screen.root_scope.find_screen(qualifier)
    end
  end
end
