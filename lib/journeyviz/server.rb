require 'rack/app'

module Journeyviz
  class Server < Rack::App
    get '/' do
      @blocks = [Journeyviz.journey] + Journeyviz.journey.deep_blocks

      path = File.expand_path('server/index.html.erb', __dir__)
      ERB.new(File.read(path)).result(binding)
    end
  end
end
