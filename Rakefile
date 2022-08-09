# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

Dir["lib/tasks/*.rake"].each { |file| import file }

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new do |t|
  t.options = ["-d"]
end

task default: %i[spec rubocop steep:check]
