# frozen_string_literal: true

require "launchy"

RSpec.describe Snapbot::Diagram do
  include Snapbot::Diagram

  describe "#save_diagram" do
    before do
      FileUtils.rm_f("tmp/models.svg")
      save_diagram
    end

    it "saves the diagram to a fixed place" do
      expect(File).to exist("tmp/models.svg")
    end
  end

  describe "#save_and_open_diagram" do
    before { allow(Launchy).to receive(:open) }

    context "Launchy is present" do
      before do
        allow(self).to receive(:launchy_present?).and_return(true)
      end

      it "saves and opens a diagram" do
        save_and_open_diagram
        expect(Launchy).to have_received(:open).with("tmp/models.svg")
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
        expect(self).to have_received(:warn).with(
          "Cannot open diagram – install `launchy`."
        )
        expect(Launchy).not_to have_received(:open)
      end
    end
  end
end
