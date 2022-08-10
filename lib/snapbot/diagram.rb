# frozen_string_literal: true

require "snapbot/diagram/dot_generator"
require "snapbot/diagram/renderer"
require "open3"

module Snapbot
  # Print the small constellation of objects in your integration test and how they relate.
  # Requires Graphviz. Optimised for Mac. YMMV.
  module Diagram
    def save_and_open_diagram(**args)
      args.reverse_merge!(rspec: !!defined?(RSpec))
      dot = DotGenerator.new(**args).dot
      filename = Renderer.new(dot).save

      unless open_command.present?
        warn "No `open` command available. File saved to #{filename}"
        return
      end

      _stdout, stderr, status = Open3.capture3("#{open_command} #{filename}")
      raise stderr unless status.exitstatus.zero?
    end

    def open_command
      `which open`.chomp
    end
  end
end
