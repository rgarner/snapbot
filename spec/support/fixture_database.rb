# frozen_string_literal: true

require "sqlite3"

class Abstract < ActiveRecord::Base
  self.abstract_class = true
end

class Blog < ActiveRecord::Base
  has_many :posts
end

class Post < ActiveRecord::Base
  belongs_to :blog
  belongs_to :author
  has_and_belongs_to_many :categories
end

class Author < ActiveRecord::Base
  has_many :posts
end

class Category < ActiveRecord::Base
  has_and_belongs_to_many :posts
end

module FixtureDatabase
  def create_fixture_database
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

      create_table "categories", force: :cascade do |t|
        t.string "name"
      end

      create_table "posts", force: :cascade do |t|
        t.string "title"
        t.integer "blog_id"
        t.integer "author_id"
      end

      create_table "categories_posts", force: :cascade do |t|
        t.integer "category_id"
        t.integer "post_id"
      end

      create_table "authors", force: :cascade do |t|
        t.string "name"
      end

      create_table "schema_migrations", force: :cascade
    end

    blog = Blog.create!(title: "Cooking With Politicians")
    ids = Author.create!(name: "Ian Duncan Smith")
    nonsense = Category.create!(name: "nonsense")
    cycling = Category.create!(name: "cycling")
    Post.create!(blog: blog, title: "Excellent meals for 37p", author: ids, categories: [nonsense])
    Post.create!(blog: blog, title: "Eat Your Own Bicycle", author: ids, categories: [nonsense, cycling])
  end
end
