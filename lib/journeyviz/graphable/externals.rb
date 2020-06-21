# frozen_string_literal: true

module Journeyviz
  module Graphable
    module Externals
      private

      def graph_inputs
        return '' unless defined?(root_scope)

        inputs = self.inputs.map { |screen| screen.full_scope + [screen] }

        return '' if inputs.empty?

        <<~INPUTS
          subgraph inputs
          #{graph_external_chain(inputs, 'input')}
          end
        INPUTS
      end

      def graph_outputs
        outputs = self.outputs.map { |screen| screen.full_scope + [screen] }
        return '' if outputs.empty?

        <<~OUTPUTS
          subgraph outputs
          #{graph_external_chain(outputs, 'output')}
          end
        OUTPUTS
      end

      def graph_external_chain(nodes, sufix)
        nodes
          .group_by(&:first)
          .flat_map { |parent, chain| graph_external_chain_node(parent, chain, sufix) }
          .join("\n")
      end

      def graph_external_chain_node(parent, chain, sufix)
        chain_without_parent = chain.map { |subchain| subchain[1..-1] }

        if parent.is_a?(Journeyviz::Screen)
          [graph_external_screen(parent, sufix)] + graph_external_transitions(parent)
        else
          graph_external_block(parent, chain_without_parent, sufix)
        end
      end

      def graph_external_screen(screen, sufix)
        "#{sufix}_#{graph_id(screen)}[#{screen.name}]:::external_screen"
      end

      def graph_external_transitions(screen)
        screen
          .actions
          .select { |action| screens.include?(action.transition) }
          .map { |action| "#{graph_id(action)}(#{action.name}):::transition" }
      end

      def graph_external_block(block, chain, sufix)
        definition = graph_external_chain(chain, sufix)
        return definition if block.is_a?(Journeyviz::Journey)

        <<~SUBGRAPH
          subgraph #{sufix}_#{graph_id(block)}[#{block.name}]
          #{definition}
          end
        SUBGRAPH
      end
    end
  end
end
