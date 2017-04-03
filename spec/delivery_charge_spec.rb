require 'spec_helper'

describe DeliveryCharge do
  subject { described_class }

  describe "::for_amount" do
    # NOTE: 5000 = 50.00
    it "returns the correct value when < 5000" do
      expect(subject).to receive(:for_amount).and_return 495
      subject.for_amount(3000)
    end

    it "returns the correct value when < 9000" do
      expect(subject).to receive(:for_amount).with(7000).and_return 295
      subject.for_amount(7000)
    end

    it "returns the correct value when == 9000" do
      expect(subject).to receive(:for_amount).with(9000).and_return 0
      subject.for_amount(9000)
    end

    it "returns the correct value when > 9000" do
      expect(subject).to receive(:for_amount).with(9001).and_return 0
      subject.for_amount(9001)
    end
  end
end
