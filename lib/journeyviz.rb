# frozen_string_literal: true

require 'journeyviz/version'
require 'journeyviz/journey'

module Journeyviz
  class Error < StandardError; end

  module_function

  def configure(&block)
    journey = Journey.new
    block.call(journey)
  end
end
