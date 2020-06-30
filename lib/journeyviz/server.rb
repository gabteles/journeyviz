# frozen_string_literal: true

require 'rack/app'

module Journeyviz
  class Server < Rack::App
    get '/' do
      block_path = params['block'] || ''
      @block = block_path.split('!').reduce(Journeyviz.journey) do |current, step|
        current.blocks.find { |block| block.name == step.to_sym }
      end

      path = File.expand_path('server/index.html.erb', __dir__)
      ERB.new(File.read(path)).result(binding)
    end
  end
end
