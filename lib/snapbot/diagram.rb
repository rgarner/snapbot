# frozen_string_literal: true

require "snapbot/diagram/dot_generator"
require "snapbot/diagram/renderer"

module Snapbot
  # Print the small constellation of objects in your integration test and how they relate.
  # Requires Graphviz. Optimised for Mac. YMMV.
  module Diagram
    def save_and_open_diagram(path = Renderer::DEFAULT_OUTPUT_FILENAME, **args)
      filename = save_diagram(path, **args)

      unless launchy_present?
        warn "Cannot open diagram – install `launchy`."
        return
      end

      Launchy.open(filename)
    end

    def save_diagram(path = Renderer::DEFAULT_OUTPUT_FILENAME, **args)
      args.reverse_merge!(rspec: !!defined?(RSpec))
      dot = DotGenerator.new(**args).dot
      Renderer.new(dot).save(path)
    end

    def launchy_present?
      require "launchy"
      true
    rescue LoadError
      false
    end
  end
end
