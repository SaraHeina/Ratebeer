require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "is saved if it has name and style" do
    beer = Beer.create name:"Lapin kulta", style_id: 1

    expect(beer.valid?).to be(true)
    expect(Beer.count).to eq(1)
  end

  it "is not saved if it does not have name" do
    beer = Beer.create name:""

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end

  it "is not saved if it does not have style" do
    beer = Beer.create name:"Lapin kulta"

    expect(beer.valid?).to be(false)
    expect(Beer.count).to eq(0)
  end
end
