require 'spec_helper'

describe Offer do
  let(:params) do
    {
      "trigger_entries":  [ {"J01": 2} ],
      "affected_entries": [ {"J01": 1} ],
      "new_unit_price": nil,
      "discount_percentage": 50
    }
  end

  subject { described_class.new(params) }

  describe "initialize" do
    it "has correct trigger_entries" do
      expect(subject.trigger_entries.count).to eq 1
      expect(subject.trigger_entries.first).to be_instance_of EntryGroup
      expect(subject.trigger_entries.first).to have_attributes(product_code: "J01", quantity: 2)
    end

    it "has correct affected_entries" do
      expect(subject.affected_entries.count).to eq 1
      expect(subject.affected_entries.first).to be_instance_of EntryGroup
      expect(subject.affected_entries.first).to have_attributes(product_code: "J01", quantity: 1)
    end
  end

  describe "#valid_for?" do
    let(:tallied_entries) { [] }
    let(:prod_code) { "J01" }
    let(:quantity) { 2 }

    before do
      quantity.times { tallied_entries << EntryItem.new(prod_code, 3295) }
    end

    context "when offer can be applied" do
      it "returns true" do
        expect(subject.valid_for?(tallied_entries)).to be true
      end
    end

    context "when offer can NOT be applied" do
      context "insufficient quantity" do
        let(:quantity) { 1 }
        it "returns false" do
          expect(subject.valid_for?(tallied_entries)).to be false
        end
      end

      context "incorrect product code" do
        let(:prod_code) { "B01" }
        it "returns false" do
          expect(subject.valid_for?(tallied_entries)).to be false
        end
      end
    end
  end

  describe "#apply" do
    let(:entry1) { EntryItem.new("J01", 3295) }
    let(:entry2) { EntryItem.new("J01", 3295) }
    let(:entry3) { EntryItem.new("J01", 3295) }
    let(:entries) { [entry1, entry2] }

    context "with two J01" do
      it "returns the correct entries" do
        expect(subject.apply(entries)).to be_kind_of Array
        expect(subject.apply(entries).count).to eq 2
        expect(subject.apply(entries).first).to be_instance_of EntryItem
      end

      it "entries hve correct values" do
        expect { subject.apply(entries)}.to change { entry1.price }.from(3295).to(1647)
        expect { subject.apply(entries)}.to_not change { entry2.price }
      end
    end

    context "with three J01" do
      before do
        entries << entry3
      end

      it "returns the correct entries" do
        expect(subject.apply(entries)).to be_kind_of Array
        expect(subject.apply(entries).count).to eq 3
      end

      it "entries hve correct values" do
        expect { subject.apply(entries)}.to change { entry1.price }.from(3295).to(1647)
        expect { subject.apply(entries)}.to_not change { entry2.price }
        expect { subject.apply(entries)}.to_not change { entry3.price }
      end
    end
  end
end
