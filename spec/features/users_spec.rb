require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
  end

  it "shows only user ratings on users page" do
    use2 = FactoryGirl.create(:user, username:"bebe", password:"Seccun1", password_confirmation:"Seccun1")
    use1 = FactoryGirl.create(:user, username:"beba", password:"Seccun1", password_confirmation:"Seccun1")
    beer = FactoryGirl.create :beer
    rating = FactoryGirl.create(:rating, beer:beer, user:use1)
    rating2 = FactoryGirl.create(:rating, beer:beer, user:use2)
    visit user_path(use1)
    expect(page).to have_content 'has made 1 rating'
    expect(page).to have_content "#{rating}"
  end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with:'Brian')
      fill_in('user_password', with:'Secret55')
      fill_in('user_password_confirmation', with:'Secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end

  describe "favorite style and brewery" do
    let! (:use1) {FactoryGirl.create :user, username:"bebe", password:"Seccun1", password_confirmation:"Seccun1"}
    let! (:brewery) { FactoryGirl.create :brewery, name:"Koff" }
    let! (:brewery2) { FactoryGirl.create :brewery, name:"Koff2" }
    let! (:beer) {FactoryGirl.create :beer, name:"iso 3", style:"Large", brewery:brewery}
    let! (:beer2) {FactoryGirl.create :beer, name:"iso 1", style:"Small", brewery:brewery2}

  it "page has favorites if user has rating" do
    FactoryGirl.create(:rating, beer:beer, user:use1)
    visit user_path(use1)
    expect(page).to have_content 'favorite style Large'
    expect(page).to have_content 'favorite brewery Koff'
  end

  it "page has right favorites if user has ratings" do
    FactoryGirl.create(:rating, beer:beer, user:use1, score:"10")
    FactoryGirl.create(:rating, beer:beer2, user:use1, score:"20")
    visit user_path(use1)
    expect(page).to have_content 'favorite style Small'
    expect(page).to have_content 'favorite brewery Koff2'
  end

  it "page don't have favorites if user don't have rating" do
    visit user_path(use1)
    expect(page).to have_content 'user has no favorite style!'
    expect(page).to have_content 'user has no favorite brewery!'
  end
    end
  end