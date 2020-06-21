# frozen_string_literal: true

module Journeyviz
  module Graphable
    module Transitions
      private

      def graph_transitions
        [
          *graph_screen_transitions,
          *graph_block_transitions,
          *graph_external_inputs
        ]
      end

      def graph_transition_node(action)
        from_id = graph_id(action.screen)
        to_id = graph_target(action)
        "transition_#{from_id}_#{action.name}_#{to_id}(#{action.name}):::transition"
      end

      def graph_screen_transitions
        @screens
          .flat_map(&:actions)
          .select(&:transition)
          .flat_map do |action|
            [graph_transition_node(action), graph_screen_transition(action)]
          end
      end

      def graph_screen_transition(action)
        "#{graph_id(action.screen)} --- #{graph_id(action)} --> #{graph_target(action)}"
      end

      def graph_target(action)
        target = action.transition

        return "output_#{graph_id(target)}" if outputs.include?(target)

        direct_children = (@blocks || []) + (@screens || [])
        target = target.scope until direct_children.include?(target)
        graph_id(target)
      end

      def graph_external_inputs
        inputs
          .flat_map(&:actions)
          .select { |action| screens.include?(action.transition) }
          .map { |action| "input_#{graph_screen_transition(action)}" }
      end

      def graph_block_transitions
        @blocks.flat_map do |block|
          targets = block.outputs
          screen_targets = @screens & targets
          block_targets = @blocks.select do |target_block|
            targets.any? { |target| target_block.screens.include?(target) }
          end

          (screen_targets + block_targets).map do |target|
            "#{graph_id(block)} --> #{graph_id(target)}"
          end
        end
      end
    end
  end
end
