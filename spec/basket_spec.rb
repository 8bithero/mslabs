require 'spec_helper'

describe Basket do
  let(:basket) { described_class.new }
  let(:catalogue) { basket.catalogue }
  let(:product) { catalogue.products.first }

  subject { basket }

  describe "#add" do
    let(:entry) { subject.entries.first }

    context "product not in basket" do
      it "adds product to basket" do
        expect{ subject.add(product.code) }.to change{ subject.entries.count }.from(0).to(1)
        expect(entry).to be_instance_of EntryGroup
        expect(entry).to have_attributes(product_code: "J01", quantity: 1)
      end

      it "returns the product that was added" do
        expect(subject.add(product.code)).to be_instance_of EntryGroup
      end
    end

    context "product already exists in basket" do
      before do
        subject.add(product.code)
      end

      it "does not add new product basket" do
        expect{ subject.add(product.code) }.to_not change{ subject.entries.count }
      end

      it "changes existing product" do
        expect{ subject.add(product.code) }.to change{ entry.quantity }.from(1).to(2)
      end

      it "returns the product that was added" do
        expect(subject.add(product.code)).to be_instance_of EntryGroup
      end
    end
  end

  describe "#delivery_charge" do
    before do
      allow(basket).to receive(:sub_total).and_return 3000
    end

    it "returns the correct value" do
      expect(subject.delivery_charge).to eq 495
    end
  end

  describe "#sub_total" do
    context "no entries" do
      it "returns the correct value" do
        expect(subject.sub_total).to eq 0
      end
    end

    context "entries on offer" do
      before do
        subject.add("J01")
        subject.add("J01")
      end
      it "returns the correct value" do
        expect(subject.sub_total).to eq 4942 # = 3295 + 1647
      end
    end

    context "entries NOT no offer" do
      before do
        subject.add("J01")
        subject.add("S01")
      end
      it "returns the correct value" do
        expect(subject.sub_total).to eq 4090 # = 3295 + 7.95
      end
    end

    it "returns the correct value" do
      expect(subject.delivery_charge).to eq 495
    end
  end

  describe "#total" do
    before do
      allow(basket).to receive(:sub_total).and_return 3000
      allow(DeliveryCharge).to receive(:for_amount).and_return 495
    end

    it "returns the correct value" do
      expect(subject.total).to eq 34.95
    end
  end

end
