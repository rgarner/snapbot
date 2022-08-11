# frozen_string_literal: true

RSpec.describe Snapbot::Reflector do
  include FixtureDatabase
  include_examples "silence warn"

  subject(:reflector) { Snapbot::Reflector.new }

  before(:all) { create_fixture_database }

  describe "#base_active_record_class" do
    it "derives from ActiveRecord::Base" do
      expect(reflector.base_activerecord_class).to eql(ActiveRecord::Base)
    end
  end

  describe "#models" do
    subject { reflector.models }

    it "ignores activerecord cruft and has only models" do
      expect(subject).to match_array([Author, Blog, Category, Post])
    end
  end

  describe "#instances" do
    subject { reflector.instances }

    it { is_expected.to match_array [Category.all, Author.all, Blog.all, Post.all].flatten }
  end

  describe "#relationships" do
    it "has a collated set of relationship objects" do
      expect(reflector.relationships).to be_a(Set)

      expect(Array(reflector.relationships)).to match_array [
        Snapbot::Reflector::Relationship.new("Category#1", "Post#1"),
        Snapbot::Reflector::Relationship.new("Category#1", "Post#2"),
        Snapbot::Reflector::Relationship.new("Category#2", "Post#2"),
        Snapbot::Reflector::Relationship.new("Author#1", "Post#1"),
        Snapbot::Reflector::Relationship.new("Author#1", "Post#2"),
        Snapbot::Reflector::Relationship.new("Post#1", "Category#1"),
        Snapbot::Reflector::Relationship.new("Post#2", "Category#1"),
        Snapbot::Reflector::Relationship.new("Post#2", "Category#2"),
        Snapbot::Reflector::Relationship.new("Blog#1", "Post#1"),
        Snapbot::Reflector::Relationship.new("Blog#1", "Post#2")
      ]
    end
  end
end
