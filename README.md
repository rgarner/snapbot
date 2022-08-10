# Snapbot

![example workflow](https://github.com/rgarner/snapbot/actions/workflows/main.yml/badge.svg)

Snapbot generates little diagrams via `save_and_open_diagram` for you to visualise the small constellations of 
ActiveRecord objects that you find in feature and integration tests. These are most often made by
 [FactoryBot](https://github.com/thoughtbot/factory_bot) or some other fixture-handling method, but this gem has no 
 opinions on those (beyond namechecking).
 
![example](docs/img/models.svg)

## Installation

Either `gem install snapbot` or add the gem to your project's `:test` group in the gemfile:

```ruby 
  group :test do 
    gem 'snapbot' 
  end 
```

Add to your tests:

```
  include Snapbot::Diagram
```

Use:

```
  blog = Blog.create(title: 'My blog')
  post = Post.create(title: 'My post', blog: blog)
  
  save_and_open_diagram
```

## Why?

Sometimes, you need to create a few ActiveRecord objects for your test suite. Sometimes, there will be a little cluster
of objects that need to exist for an integration spec or feature spec to run reliably. And sometimes, it will be 4.30pm
and your fixtures or FactoryBot factories feel like they're slipping from what you can reasonably hold in your head.

We don't all write tests like this. Or rather, not all our tests are like this. But when they are, 
`save_and_open_diagram` is a quick way to see what's what.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rgarner/snapbot. This project is intended to
be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of
conduct](https://github.com/rgarner/snapbot/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Snapbot project's codebases, issue trackers, chat rooms and mailing lists is expected to
follow the [code of conduct](https://github.com/rgarner/snapbot/blob/main/CODE_OF_CONDUCT.md).
