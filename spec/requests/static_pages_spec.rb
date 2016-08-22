require 'rails_helper'

describe 'Static Pages' do
  describe 'Home Page' do 
    it "should have the content 'Sample App'" do
      visit root_path

      expect(page).to have_content('Sample App')
    end

    it 'should not have base title' do
       visit root_path

       expect(page).to have_title('RoR')
    end

    it 'it should not have custom title' do
       visit root_path

       expect(page).not_to have_title('| Home')
    end
  end

  describe 'Help Page' do
    it "should have the content 'Help'" do
      visit help_path

      expect(page).to have_content('Help')
    end

    it 'should have right title' do
       visit help_path

       expect(page).to have_title('RoR | Help')
    end
  end

  describe 'About Page' do
    it "should have the content 'About Us'" do
      visit about_path

      expect(page).to have_content('About Us')
    end

    it 'should have right title' do
       visit about_path

       expect(page).to have_title('RoR | About Us')
    end
  end

  describe 'Contant Page' do
    it "should have the content 'Contact'" do
      visit contact_path

      expect(page).to have_content('Contact')
    end

    it 'should have right title' do
       visit contact_path

       expect(page).to have_title('RoR | Contact')
    end
  end
end
