# frozen_string_literal: true

RSpec.describe Snapbot::RSpec::Lets do
  describe "#collect" do
    subject { described_class.new(self).collect }

    context "when there are lets" do
      let(:foo) { "bar" }
      let(:bar) { "baz" }

      it { is_expected.to match_array %i[foo bar subject] }
    end
  end

  describe "#collect when there are no lets" do # (cannot use a `subject`, separate describe)
    it "returns an empty array" do
      expect(described_class.new(self).collect).to be_empty
    end
  end
end
