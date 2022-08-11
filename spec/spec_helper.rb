# frozen_string_literal: true

require "snapbot"

Dir[File.join(File.dirname(__FILE__), "support", "**", "*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  # declare an exclusion filter
  config.filter_run_excluding manual: true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
