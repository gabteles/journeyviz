module Journeyviz
  module HasScreens
    def screen(name, &definition)
      # TODO: Validate name
      screen = Screen.new(name)

      @screens ||= []
      @screens << screen
      definition.call(screen)
    end

    attr_reader :screens
  end
end
