# frozen_string_literal: true

module Snapbot
  module RSpec
    # Collect RSpec `let`s for a given example and all her parents
    class Lets
      def initialize(example)
        @example = example
      end

      def collect
        _collect(@example.class, [])
      end

      private

      def _collect(klass, lets)
        lets.tap do
          next if klass.to_s == "RSpec::ExampleGroups" # stop when we hit the top

          lets.concat(klass::LetDefinitions.instance_methods(false))
          parent_class = klass.to_s.deconstantize.constantize

          _collect(parent_class, lets)
        end
      end
    end
  end
end
