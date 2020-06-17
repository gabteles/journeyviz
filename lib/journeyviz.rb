# frozen_string_literal: true

require 'journeyviz/version'
require 'journeyviz/server'
require 'journeyviz/journey'

module Journeyviz
  class Error < StandardError; end
  class InvalidNameError < Error; end
  class DuplicatedDefinition < Error; end
  class InvalidTransition < Error; end

  class << self
    def configure(&block)
      block.call(journey)
      journey.validate!
    end

    def identify(user_id)
      context[:user_id] = user_id
    end

    def visit(screen)
      # TODO
      # screen/day/:day/visits ++
      # screen/week/:week/visits ++
      # screen/month/:month/visits ++
      # screen/quarter/:quarter/visits ++
    end

    def act(action)
      # TODO
      # :action/day/:day ++
      # :action/week/:week ++
      # :action/month/:month ++
      # :action/quarter/:quarter ++
    end

    def context
      Thread.current[:journeyviz_context] ||= {}
    end

    def journey
      @journey ||= Journey.new
    end
  end
end
