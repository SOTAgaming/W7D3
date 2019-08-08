require 'rails_helper'

feature "new_user" do
  scenario 'has a new user page' do
    visit new_user_url
    expect(page).to have_content 'Username:'
    expect(page).to have_content 'Password:'
  end

  feature "create an account" do
    before(:each) do
      visit new_user_url
      fill_in 'Username:', with: 'bob'
      fill_in 'Password:', with: '123456'
      # save_and_open_page
      click_on 'Sign Up'
    end

    it "correctly creates a user" do
      expect(User.find_by(username: 'bob')).not_to be(nil)
    end

    scenario 'redirects to show page' do
      expect(page).to have_content('Hello bob')
    end

  end

  feature "Sessions" do 
    scenario 'has a login page' do 
      visit new_sessions_url
      expect(page).to have_content 'Username:'
      expect(page).to have_content 'Password:'
    end 

    feature 'logging in' do
      before :each do
        FactoryBot.create(:user, username: 'bob')
        visit new_sessions_url
        fill_in 'Username:', with: 'bob'
        fill_in 'Password:', with: '123456'
        click_on 'Login'
      end 
      scenario 'redirects to user show page' do
         expect(page).to have_content('Hello bob')
      end 
    end 

    feature 'logging out' do

      before :each do 
        FactoryBot.create(:user, username: 'bob')
        visit new_sessions_url
        fill_in 'Username:', with: 'bob'
        fill_in 'Password:', with: '123456'
        click_on 'Login'
        # save_and_open_page
         click_on 'Logout'
      end 

      scenario 'redirects to sign in page' do
        expect(page).to have_content 'Username:'
        expect(page).to have_content 'Password:'
      end 

    end 
    
  end 


  

end