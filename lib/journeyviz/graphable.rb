# frozen_string_literal: true

require 'journeyviz/graphable/externals'
require 'journeyviz/graphable/transitions'

module Journeyviz
  module Graphable
    include Externals
    include Transitions

    def graph
      defs = [
        *graph_screens,
        *graph_blocks,
        *graph_inputs,
        *graph_outputs,
        *graph_transitions,
        *graph_styles
      ].join("\n")

      "graph LR\n#{defs}"
    end

    private

    def graph_screens
      (@screens || []).map { |screen| "#{graph_id(screen)}[#{screen.name}]:::screen" }
    end

    def graph_blocks
      (@blocks || []).map { |block| "#{graph_id(block)}[#{block.name}]:::block" }
    end

    def graph_styles
      [
        'classDef screen fill:#373496,stroke:#373496,stroke-width:2px,color:#fff',
        'classDef transition fill:#fff,stroke:#373496,stroke-width:2px,color:#373496,stroke-dasharray: 5, 5',
        'classDef block fill:#963734,color:#fff'
      ]
    end

    def graph_id(node)
      case node
      when Journeyviz::Screen then screen_id(node)
      when Journeyviz::Block then block_id(node)
      when Journeyviz::Action then action_id(node)
      end
    end

    def screen_id(node)
      "screen_#{node.full_qualifier.join('_')}"
    end

    def block_id(node)
      "block_#{node.full_qualifier.join('_')}"
    end

    def action_id(node)
      from_id = graph_id(node.screen)
      to_id = graph_id(node.transition)
      "transition_#{from_id}_#{node.name}_#{to_id}"
    end
  end
end
