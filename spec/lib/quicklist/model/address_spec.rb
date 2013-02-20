require 'rspec/autorun'
require './lib/quicklist/model/address'

describe Quicklist::Model::Address do

  let(:address) {
    Quicklist::Model::Address.new(
      line_one="Addr L1",
      line_two="Addr L2",
      city="New York",
      state="NY",
      zip="10002"
    )
  }

  describe "#initialize" do

    it "has line_one" do
      expect(address.line_one).to eq('Addr L1')
    end

    it "has line_two" do
      expect(address.line_two).to eq('Addr L2')
    end

    it "has city" do
      expect(address.city).to eq('New York')
    end

    it "has state" do
      expect(address.state).to eq('NY')
    end

    it "has zip" do
      expect(address.zip).to eq('10002')
    end

  end

  describe "#view" do

    let(:view) { address.view }

    it "has keys for line_one, line_two, city, state, zip" do
      expect(view.keys).to include(:line_one, :line_two, :city, :state, :zip)
    end

    it "has values for line_one, line_two, city, state, zip" do
      expect(view[:line_one]).to eq('Addr L1')
      expect(view[:line_two]).to eq('Addr L2')
      expect(view[:city]).to eq('New York')
      expect(view[:state]).to eq('NY')
      expect(view[:zip]).to eq('10002')
    end

  end

  describe "#==" do

    let(:a2) {
      Quicklist::Model::Address.new(
        line_one="Addr L1",
        line_two="Addr L2",
        city="New York",
        state="NY",
        zip="10002"
      )
    }

    it "is true if properties are the same" do
      expect(address == a2).to be_true
      expect(address.equal?(a2)).to be_false
    end

    it "is true if compared to a Hash representing the view" do
      expect(address == address.view).to be_true
    end

  end

end