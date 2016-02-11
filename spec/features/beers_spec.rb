require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "is created if it's name is valid" do
    visit new_beer_path
    fill_in('Name', with: 'Lapin kulta')
    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(1)
  end

  it "is not created if it's name is not valid" do
    visit new_beer_path
    fill_in('Name', with: '')
    expect{
      click_button('Create Beer')
    }.to change{Beer.count}.by(0)
    expect(page).to have_content "Name can't be blank"
  end

end