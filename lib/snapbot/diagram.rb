# frozen_string_literal: true

module Snapbot
  # Print the small constellation of objects in your integration test and how they relate.
  # Requires Graphviz. Optimised for Mac. YMMV.
  module Diagram
    def save_and_open_diagram(**args)
      DotGenerator.new(**args).open
    end
  end
end
