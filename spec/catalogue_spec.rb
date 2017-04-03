require 'spec_helper'

describe Catalogue do
  subject { described_class.new }

  describe "initialize" do
    it "has products" do
      expect(subject.products.count).to eq 3
    end

    it "has offers" do
      expect(subject.offers.count).to eq 1
    end
  end

  describe "#find_product_by_code" do
    it "returns to correct product" do
      expect(subject.find_product_by_code("J01")).to be_instance_of Product
      expect(subject.find_product_by_code("J01")).to have_attributes(name: "Jeans", code: "J01", price: 3295)
    end
  end
end
