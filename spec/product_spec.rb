require 'spec_helper'

describe Product do
  let(:product_params) { { name: "Jeans", code: "J01", price: 3295 } }

  subject { described_class.new(product_params) }

  it "returns the correct name" do
    expect(subject.name).to eq "Jeans"
  end

  it "returns the correct code" do
    expect(subject.code).to eq "J01"
  end

  it "returns the correct price" do
    expect(subject.price).to eq 3295
  end
end
