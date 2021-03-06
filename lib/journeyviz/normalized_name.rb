# frozen_string_literal: true

module Journeyviz
  module NormalizedName
    attr_reader :name

    private

    def assign_normalize_name(name)
      if !name.is_a?(String) && !name.is_a?(Symbol) || name.size <= 0
        raise InvalidNameError, "Invalid name given: #{name.inspect}"
      end

      raise(InvalidNameError, "Invalid character `!` on `#{name.inspect}`") if name.to_s.include?('!')

      @name = name.to_sym
    end
  end
end
