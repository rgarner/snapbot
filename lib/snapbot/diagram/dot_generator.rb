# frozen_string_literal: true

require_relative "snapbot/diagram/dot_generator/relationship"
require "active_record"

if defined?(::RSpec)
  require "binding_of_caller"
  require_relative "snapbot/rspec/lets"
end

module Snapbot
  module Diagram
    # Get a visual handle on what small constellations of objects we're creating
    # in specs
    class DotGenerator
      def initialize(label: "g", output_filename: "tmp/models.svg", attrs: false, ignore_lets: %i[])
        @label = label
        @output_filename = output_filename
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

      def open
        FileUtils.rm(@output_filename, force: true)
        IO.popen("dot -Tsvg -o #{@output_filename}", "w") do |pipe|
          pipe.puts(dot).tap { |_d| File.open("tmp/models.dot", "w+") { |f| f.write(dot) } }
        end

        warn "Written to #{@output_filename}"
        open_command = `which open`.chomp
        `#{open_command} #{@output_filename}` if open_command.present?
      end

      private

      BASE_ACTIVERECORD_CLASS = defined?(ApplicationRecord) ? ApplicationRecord : ActiveRecord::Base

      def collect_lets(example)
        @lets_by_value = RSpec::Lets.new(example).collect.each_with_object({}) do |sym, lets_by_value|
          value = example.send(sym) unless @ignore_lets.include?(sym)
          lets_by_value[value] = sym if value.is_a?(BASE_ACTIVERECORD_CLASS)
        end
      end

      def models(only_with_records: true)
        @models ||= begin
          Rails.application.eager_load! if defined?(Rails)
          BASE_ACTIVERECORD_CLASS.descendants.reject do |c|
            c.to_s == "Schema" || (only_with_records && c.count.zero?)
          end
        end
      end

      def instances
        @instances ||= models.each_with_object([]) do |klass, array|
          array << klass.all
        end.flatten
      end

      def instance_name(instance)
        "#{instance.model_name}##{instance.id}"
      end

      # A Set of relationships to other identified entities
      def relationships
        @relationships ||= instances.each_with_object(Set.new) do |instance, set|
          add_relationships(instance, set)
        end
      end

      def add_relationships(instance, set)
        reflect_associations(instance).each do |association|
          case association
          when ActiveRecord::Reflection::HasManyReflection
            records = instance.send(association.name)
            records.each do |record|
              set.add(Relationship.new(instance_name(instance), instance_name(record)))
            end
          when ActiveRecord::Reflection::HasOneReflection
            one = instance.send(association.name)
            set.add(Relationship.new(instance_name(instance), instance_name(one))) if one.present?
          end
        end
      end

      def reflect_associations(instance)
        (
          instance.class.reflect_on_all_associations(:has_many).reject { |a| a.name == :schemas } +
            instance.class.reflect_on_all_associations(:has_one)
        ).flatten
      end

      def escape_hash(hash)
        hash.each_with_object([]) do |(key, value), array|
          array << "#{key}: #{value.nil? ? "nil" : value}"
        end.join(", ")
      end

      def attributes(instance)
        instance.attributes.to_h.transform_values { |v| v.is_a?(Hash) ? escape_hash(v) : v }
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
            <% instances.each do |instance| %>
            "<%= instance_name(instance) %>" [
              label=<
                <table border="0" cellborder="0">
                  <% if @lets_by_value[instance] %>
                  <tr><td fontsize="8"><font face="Monaco" point-size="8">let(:<%= @lets_by_value[instance] %>)</font></td></tr>
                  <% end %>
                  <tr><td><%= instance_name(instance) %></td></tr>
                </table>
                <% if @options[:attrs] %>
                |
                <table border="0" cellborder="0">
                  <% attributes(instance).each_pair do |attr, value| %>
                  <tr>
                    <td align="left" width="200" port="<%= attr %>">
                      <%= attr %>
                      <font face="Arial BoldMT" color="grey60"><%= value.inspect %></font>
                    </td>
                  </tr>
                  <% end %>
                </table>
                <% end %>#{" "}
              >
            ];
            <% end %>
            <% relationships.each do |relationship| %>
              "<%= relationship.source %>" -> "<%= relationship.destination %>" [arrowhead = "none", arrowtail = "normal", weight = "6"];
            <% end %>
          }
        ERB
      end
    end
  end
end
