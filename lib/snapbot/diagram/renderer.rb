# frozen_string_literal: true

require "open3"

module Snapbot
  module Diagram
    # Render some DOT via Graphviz dot command line
    class Renderer
      INSTALL_GRAPHVIZ_URL = "https://graphviz.org/download/#executable-packages"
      DEFAULT_OUTPUT_FILENAME = "tmp/models.svg"

      def initialize(dot)
        @dot = dot
      end

      def save(path = DEFAULT_OUTPUT_FILENAME)
        ensure_graphviz
        FileUtils.rm(path, force: true)
        FileUtils.mkdir_p(File.dirname(path))

        IO.popen("dot -Tsvg -o #{path}", "w") do |pipe|
          pipe.puts(@dot)
        end

        warn "Written to #{path}"
        path
      end

      private

      def graphviz_executable
        `which dot`
      end

      def ensure_graphviz
        return unless graphviz_executable.empty?

        warn <<~GRAPHVIZ
          The graphviz executable `dot` was not found.
          Install from #{INSTALL_GRAPHVIZ_URL}
        GRAPHVIZ
      end
    end
  end
end
