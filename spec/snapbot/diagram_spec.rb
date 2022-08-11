# frozen_string_literal: true

require "launchy"

RSpec.describe Snapbot::Diagram do
  include Snapbot::Diagram
  include FixtureDatabase
  include_examples "silence warn"

  before(:all) { create_fixture_database }

  describe "#save_diagram" do
    context "no filename is given" do
      before do
        FileUtils.rm_f("tmp/models.svg")
        save_diagram
      end

      it "saves the diagram to a fixed place" do
        expect(File).to exist("tmp/models.svg")
      end
    end

    context "a filename is given" do
      before do
        FileUtils.rm_f("tmp/downhere/blog.svg")
        save_diagram("tmp/downhere/blog.svg")
      end

      it "saves the diagram to place we asked for" do
        expect(File).to exist("tmp/downhere/blog.svg")
      end
    end
  end

  describe "#save_and_open_diagram" do
    before { allow(Launchy).to receive(:open) }

    context "Launchy is present" do
      before do
        allow(self).to receive(:launchy_present?).and_return(true)
      end

      context "no filename is given" do
        it "saves and opens a diagram" do
          save_and_open_diagram
          expect(Launchy).to have_received(:open).with("tmp/models.svg")
        end
      end

      context "a filename is given" do
        it "saves and opens a diagram" do
          save_and_open_diagram("tmp/downhere/blog.svg")
          expect(Launchy).to have_received(:open).with("tmp/downhere/blog.svg")
        end
      end
    end

    context "Launchy is not present" do
      before do
        allow(self).to receive(:launchy_present?).and_return(false)
        allow(self).to receive(:warn)
        save_and_open_diagram
      end

      it "only saves the diagram and warns about no `open`" do
        expect(File).to exist("tmp/models.svg")
        expect(self).to have_received(:warn).with("Cannot open diagram – install `launchy`.")
        expect(Launchy).not_to have_received(:open)
      end
    end
  end
end
