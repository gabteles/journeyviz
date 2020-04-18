# frozen_string_literal: true

module Journeyviz
  Scopable = proc do |qualified_by|
    Module.new do
      attr_reader :scope

      def assign_scope(scope)
        @scope = scope
      end

      def root_scope
        current_scope = self
        current_scope = current_scope.scope until !current_scope.respond_to?(:scope) || current_scope.scope.nil?
        current_scope
      end

      def full_scope
        current_scope = scope
        chain = [current_scope]

        until current_scope.nil? || !current_scope.respond_to?(:scope)
          current_scope = current_scope.scope
          chain.unshift(current_scope)
        end

        chain
      end

      define_method(:full_qualifier) do
        base_qualifier = scope&.respond_to?(:full_qualifier) ? scope.full_qualifier : []
        [*base_qualifier, send(qualified_by)].compact
      end
    end
  end
end
