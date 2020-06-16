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
        "transition_#{graph_id(action.screen)}_#{action.name}_#{graph_id(action.transition)}(#{action.name}):::transition"
      end

      def graph_screen_transitions
        self_outputs = outputs

        @screens
          .flat_map(&:actions)
          .select(&:transition)
          .flat_map do |action|
            suffix = self_outputs.include?(action.transition) ? 'output_' : ''
            [
              graph_transition_node(action),
              "#{graph_id(action.screen)} --- #{graph_id(action)} --> #{suffix}#{graph_id(action.transition)}"
            ]
          end
      end

      def graph_external_inputs
        inputs
          .flat_map(&:actions)
          .select { |action| screens.include?(action.transition) }
          .map do |action|
            "input_#{graph_id(action.screen)} --- #{graph_id(action)} --> #{graph_id(action.transition)}"
          end
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
