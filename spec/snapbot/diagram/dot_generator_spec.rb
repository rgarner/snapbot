# frozen_string_literal: true

require "snapbot/diagram/dot_generator"

RSpec.describe Snapbot::Diagram::DotGenerator do
  subject(:dot_generator) { Snapbot::Diagram::DotGenerator.new(ignore_lets: %i[dot_generator dot]) }

  describe "#dot" do
    subject(:dot) { dot_generator.dot }

    context "there is no database" do
      it "renders a graph" do
        expect(dot).to include("digraph")
      end
    end
  end
end
