# frozen_string_literal: true

require "snapbot/diagram/dot_generator"

RSpec.describe Snapbot::Diagram::DotGenerator do
  include FixtureDatabase

  let(:rspec) { false }
  subject(:dot_generator) { Snapbot::Diagram::DotGenerator.new(ignore_lets: %i[dot_generator dot], rspec: rspec) }

  describe "#dot" do
    subject(:dot) { dot_generator.dot }

    context "there is a database with stuff in it" do
      before(:all) { create_fixture_database }

      it "has one node definition per model instance in the quoted form Model#<id>" do
        aggregate_failures do
          expect(dot).to include('"Author#1" [')
          expect(dot).to include('"Blog#1" [')
          expect(dot).to include('"Post#1" [')
          expect(dot).to include('"Post#2" [')
          expect(dot).to include('"Category#1" [')
          expect(dot).to include('"Category#2" [')
        end
      end

      it "relates the instances" do
        aggregate_failures do
          expect(dot).to include('"Author#1" -> "Post#1')
          expect(dot).to include('"Author#1" -> "Post#2')
          expect(dot).to include('"Blog#1" -> "Post#1')
          expect(dot).to include('"Blog#1" -> "Post#2')
          expect(dot).to include('"Category#1" -> "Post#1"')
          expect(dot).to include('"Category#1" -> "Post#2"')
          expect(dot).to include('"Category#2" -> "Post#2"')
          expect(dot).to include('"Post#1" -> "Category#1"')
          expect(dot).to include('"Post#2" -> "Category#1"')
          expect(dot).to include('"Post#2" -> "Category#2"')
        end
      end

      context "rspec is enabled and there is a let corresponding to a model" do
        let(:rspec) { true }

        # This spec is a little bit meta; the existence of this `let` will be picked up
        # by binding_of_caller
        let(:blog) { Blog.first }

        it "generates a label for that model" do
          expect(dot).to include("let(:blog)")
        end
      end
    end
  end
end
