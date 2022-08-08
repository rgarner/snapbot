RSpec.describe Snapbot::Diagram::Renderer do
  let(:stderr)       { double("STDERR") }
  let(:dot)          { "digraph g { }" }
  subject(:renderer) { Snapbot::Diagram::Renderer.new(dot) }

  describe "#save" do
    context "graphviz is installed" do
      before { renderer.save }
      after  { FileUtils.rm_f("tmp/models.svg") }

      context "the DOT is valid" do
        it "generates SVG to tmp/models.svg" do
          content = File.read("tmp/models.svg")
          expect(content).to include("svg")
        end
      end
    end

    context "graphviz is not installed" do
      before do
        allow(renderer).to receive(:graphviz_executable).and_return("")
        allow(renderer).to receive(:warn)

        renderer.save
      end

      it "tells you what to do to install it" do
        expect(renderer).to have_received(:warn).with(/The graphviz executable `dot` was not found/)
      end
    end
  end
end