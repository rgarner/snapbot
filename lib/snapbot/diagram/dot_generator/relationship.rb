# frozen_string_literal: true

module Snapbot
  module Diagram
    class DotGenerator
      # A source/destination-based relationship
      class Relationship
        attr_accessor :source, :destination

        def initialize(source, destination)
          self.source = source
          self.destination = destination
        end

        def equals(other)
          source == other.source && destination == other.destination
        end
      end
    end
  end
end
