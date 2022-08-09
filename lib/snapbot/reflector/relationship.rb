# frozen_string_literal: true

module Snapbot
  class Reflector
    # A source/destination-based relationship
    class Relationship
      attr_accessor :source, :destination

      def initialize(source, destination)
        self.source = source
        self.destination = destination
      end

      def ==(other)
        source == other.source && destination == other.destination
      end
    end
  end
end
