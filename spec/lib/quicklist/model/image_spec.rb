require 'rspec/autorun'
require './lib/quicklist/model/image'

describe Quicklist::Model::Image do

  before(:all) do
    @url = "//quicklist.it/assets/image.gif"
    @image = Quicklist::Model::Image.new(300, 150, @url)
  end

  let(:image) { Quicklist::Model::Image.new("300", "150", @url) }

  describe "#initialize" do

    it "converts width to integer" do
      image.width.should be(300)
      image.width.should_not be("300")
    end

    it "converts height to integer" do
      image.height.should be(150)
      image.height.should_not be("150")
    end

    it "converts strings to integers" do
      image.should == @image
    end

  end

  describe "#view" do

    let(:view) { @image.view }

    it "has the right keys" do
      view.keys.should include(:width, :height, :url)
    end

    it "has the right values" do
      view.values.should include(300, 150, @url)
    end

    it "has keys matching values" do
      expect(view[:width]).to eq(300)
      expect(view[:height]).to eq(150)
      expect(view[:url]).to eq(@url)
    end

  end

  describe "#==" do

    it "is true if properties are the same" do
      expect(image == @image).to be_true
      expect(image.equal?(@image)).to be_false
    end

    it "is true if compared to a Hash representing the view" do
      expect(image == image.view).to be_true
    end

  end

end
