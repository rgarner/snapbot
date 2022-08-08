# frozen_string_literal: true

RSpec.describe Snapbot::Diagram do
  describe ".save_and_open_diagram" do
    include Snapbot::Diagram

    context "the command `open` exists" do
      before do
        allow(Open3).to receive(:capture3).with(
          "/usr/bin/open tmp/models.svg"
        ).and_return(
          ["", "", double("Process::Status", exitstatus: 0)]
        )
      end

      it "saves and opens a diagram" do
        save_and_open_diagram
        expect(Open3).to have_received(:capture3)
      end
    end

    context "the command `open` does not exist" do
      before do
        allow(self).to receive(:open_command).and_return("")
        allow(self).to receive(:warn)
        allow(Open3).to receive(:capture3)
        save_and_open_diagram
      end

      it "only saves the diagram and warns about no `open`" do
        expect(self).to have_received(:warn).with("No `open` command available. File saved to tmp/models.svg")
        expect(Open3).not_to have_received(:capture3)
      end
    end
  end
end
