# frozen_string_literal: true

require "snapbot/diagram/dot_generator"
require "sqlite3"

class Blog < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :blog
  belongs_to :author
end

class Author < ActiveRecord::Base
  has_many :posts
end


RSpec.describe Snapbot::Diagram::DotGenerator do
  subject(:dot_generator) { Snapbot::Diagram::DotGenerator.new(ignore_lets: %i[dot_generator dot]) }

  describe "#dot" do
    subject(:dot) { dot_generator.dot }

    context "there is a database with stuff in it" do
      before(:all) do
        config = YAML.safe_load(
          <<~YAML
            adapter: sqlite3
            database: ":memory:"
            pool: 5
            timeout: 5000
          YAML
        )

        ActiveRecord::Base.establish_connection(config)
        SQLite3::Database.open(config["database"])

        ActiveRecord::Schema.define do
          create_table "blogs", force: :cascade do |t|
            t.string "title"
          end

          create_table "posts", force: :cascade do |t|
            t.string "title"
            t.integer "blog_id"
            t.integer "author_id"
          end

          create_table "authors", force: :cascade do |t|
            t.string "name"
          end

          create_table "schema_migrations", force: :cascade
        end

        blog = Blog.create!(title: "Cooking With Politicians")
        ids = Author.create!(name: "Ian Duncan Smith")
        Post.create!(blog: blog, title: "Excellent meals for 37p", author: ids)
        Post.create!(blog: blog, title: "Eat Your Own Bicycle", author: ids)
      end

      it "has one node definition per model instance in the quoted form Model#<id>" do
        aggregate_failures do
          expect(dot).to include('"Author#1"')
          expect(dot).to include('"Blog#1"')
          expect(dot).to include('"Post#1"')
          expect(dot).to include('"Post#2"')
        end
      end

      it "relates the instances" do
        aggregate_failures do
          expect(dot).to include('"Author#1" -> "Post#1')
          expect(dot).to include('"Author#1" -> "Post#2')
          expect(dot).to include('"Blog#1" -> "Post#1')
          expect(dot).to include('"Blog#1" -> "Post#2')
        end
      end
    end
  end
end
