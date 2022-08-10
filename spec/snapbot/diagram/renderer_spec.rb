# frozen_string_literal: true

RSpec.describe Snapbot::Diagram::Renderer do
  let(:dot)          { "digraph g { }" }
  subject(:renderer) { Snapbot::Diagram::Renderer.new(dot) }

  describe "#save" do
    context "graphviz is installed" do
      def clean
        FileUtils.rm("tmp/models.svg", force: true)
        FileUtils.rm_f("tmp")
      end

      before { clean }
      after  { clean }

      context "the DOT is valid" do
        context "no filename is given" do
          before { renderer.save }

          it "generates SVG to tmp/models.svg" do
            content = File.read("tmp/models.svg")
            expect(content).to include("svg")
          end
        end

        context "a filename is given" do
          before { renderer.save("tmp/downhere/blog.svg") }

          it "generates SVG to tmp/downhere/blog.svg" do
            content = File.read("tmp/downhere/blog.svg")
            expect(content).to include("svg")
          end
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
