# frozen_string_literal: true

require "snapbot/reflector"

if defined?(::RSpec)
  require "snapbot/rspec/lets"
  require "binding_of_caller"
end

module Snapbot
  module Diagram
    # Get a visual handle on what small constellations of objects we're creating
    # in specs
    class DotGenerator
      def initialize(label: "g", attrs: false, ignore_lets: %i[])
        @label = label
        @options = { attrs: attrs }
        @ignore_lets = ignore_lets

        return unless defined?(::RSpec)

        example = binding.of_caller(1).eval("self")
        collect_lets(example)
      end

      def dot
        renderer = ERB.new(template, trim_mode: "-")
        renderer.result(self.binding)
      end

      private

      delegate :instances, :relationships, :attributes, to: :reflector

      def reflector
        @reflector ||= Reflector.new
      end

      def collect_lets(example)
        @lets_by_value = RSpec::Lets.new(example).collect.each_with_object({}) do |sym, lets_by_value|
          value = example.send(sym) unless @ignore_lets.include?(sym)
          lets_by_value[value] = sym if value.is_a?(reflector.base_activerecord_class)
        end
      end

      def instance_name(instance)
        "#{instance.model_name}##{instance.id}"
      end

      def template
        <<~ERB
          digraph "<%= @label %>" {
            rankdir = "LR";
            ranksep = "0.5";
            nodesep = "0.4";
            pad = "0.4,0.4";
            margin = "0,0";
            concentrate = "true";
            labelloc = "t";
            fontsize = "13";
            fontname = "Arial BoldMT";
            splines = "spline";
            node[ shape  =  "Mrecord" , fontsize  =  "10" , fontname  =  "ArialMT" , margin  =  "0.07,0.05" , penwidth  =  "1.0"];
            edge[ fontname  =  "ArialMT" , fontsize  =  "7" , dir  =  "both" , arrowsize  =  "0.9" , penwidth  =  "1.0" , labelangle  =  "32" , labeldistance  =  "1.8"];
            rankdir = "TB";
            splines = "spline";
            <%- instances.each do |instance| -%>
            "<%= instance_name(instance) %>" [
              label=<
                <table border="0" cellborder="0">
                  <%- if @lets_by_value[instance] -%>
                  <tr><td><font face="Monaco,Courier,monospace" point-size="8">let(:<%= @lets_by_value[instance] %>)</font></td></tr>
                  <%- end -%>
                  <tr><td><%= instance_name(instance) %></td></tr>
                </table>
                <%- if @options[:attrs] -%>
                |
                <table border="0" cellborder="0">
                  <%- attributes(instance).each_pair do |attr, value| -%>
                  <tr>
                    <td align="left" port="<%= attr %>">
                      <%= attr %>
                    </td>
                    <td align="left">
                      <font color="grey50"><%= value.inspect %></font>
                    </td>
                  </tr>
                  <%- end -%>
                </table>
                <%- end -%>
              >
            ];
            <% end %>
            <%- relationships.each do |relationship| -%>
            "<%= relationship.source %>" -> "<%= relationship.destination %>" [arrowhead = "none", arrowtail = "normal", weight = "6"];
            <%- end -%>
          }
        ERB
      end
    end
  end
end
