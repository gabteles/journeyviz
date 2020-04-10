# frozen_string_literal: true

require 'journeyviz/version'
require 'journeyviz/journey'

module Journeyviz
  class Error < StandardError; end
  class InvalidNameError < Error; end

  module_function

  def configure(&block)
    journey = Journey.new
    block.call(journey)
    @journey = journey
  end

  def journey
    @journey
  end
end
