# frozen_string_literal: true

require "snapbot/diagram/dot_generator"
require "snapbot/diagram/renderer"

module Snapbot
  # Print the small constellation of objects in your integration test and how they relate.
  # Requires Graphviz. Optimised for Mac. YMMV.
  module Diagram
    def save_and_open_diagram(**args)
      args.reverse_merge!(rspec: !!defined?(RSpec))
      dot = DotGenerator.new(**args).dot
      filename = Renderer.new(dot).save

      unless launchy_present?
        warn "Cannot open diagram – install `launchy`. File saved to #{filename}"
        return
      end

      Launchy.open(Renderer::OUTPUT_FILENAME)
    end

    def launchy_present?
      require "launchy"
      true
    rescue LoadError
      false
    end
  end
end
