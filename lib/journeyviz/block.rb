# frozen_string_literal: true

require 'journeyviz/normalized_name'
require 'journeyviz/node_group'
require 'journeyviz/graphable'
require 'journeyviz/scopable'

module Journeyviz
  class Block
    include NormalizedName
    include NodeGroup
    include Graphable
    include Scopable[:name]

    def initialize(name, scope = nil)
      assign_normalize_name(name)
      assign_scope(scope)
    end
  end
end
