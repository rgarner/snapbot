# frozen_string_literal: true

require "snapbot/diagram/dot_generator"

RSpec.describe Snapbot::Diagram::DotGenerator do
  include FixtureDatabase

  subject(:dot_generator) { Snapbot::Diagram::DotGenerator.new(ignore_lets: %i[dot_generator dot]) }

  describe "#dot" do
    subject(:dot) { dot_generator.dot }

    context "there is a database with stuff in it" do
      before(:all) { create_fixture_database }

      include Snapbot::Diagram
      describe "the categorised post creator" do
        let(:blog)   { Blog.first }
        let(:author) { Author.first }

        it "creates posts automatically, categorised" do
          save_and_open_diagram attrs: true
        end
      end

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
    end
  end
end
