# frozen_string_literal: true

require "snapbot/diagram"

RSpec.describe "a manual save_and_open_page", manual: true do
  include FixtureDatabase
  include Snapbot::Diagram

  before { create_fixture_database }

  it "can launch your browser", :manual do
    save_and_open_diagram
  end
end
