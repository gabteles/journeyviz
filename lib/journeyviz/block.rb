module Journeyviz
  class Block
    include HasScreens

    def initialize(name)
      @name = name
    end

    attr_reader :name
  end
end
