# frozen_string_literal: true

require "launchy"

RSpec.describe Snapbot::Diagram do
  describe ".save_and_open_diagram" do
    include Snapbot::Diagram

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
        expect(self).to have_received(:warn).with(
          "Cannot open diagram – install `launchy`. File saved to tmp/models.svg"
        )
        expect(Launchy).not_to have_received(:open)
      end
    end
  end
end
