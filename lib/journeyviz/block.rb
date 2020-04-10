# frozen_string_literal: true

module Journeyviz
  class Block
    include HasScreens

    def initialize(name)
      unless name.to_s.size.positive?
        raise InvalidNameError, "Invalid block name given: #{name.inspect}"
      end

      @name = name
    end

    attr_reader :name
  end
end
