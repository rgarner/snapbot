# frozen_string_literal: true

require "stringio"

RSpec.shared_examples "silence warn" do
  around do |example|
    old_stderr = $stderr
    $stderr = StringIO.new
    example.run
  ensure
    $stderr = old_stderr
  end
end
