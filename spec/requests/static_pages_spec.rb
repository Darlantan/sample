require 'spec_helper'

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    let(:user) { FactoryGirl.create(:user) }

    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }

    it { should_not have_link('Users',       href: users_path) }
    it { should_not have_link('Profile',     href: user_path(user)) }
    it { should_not have_link('Settings',    href: edit_user_path(user)) }
    it { should_not have_link('Sign out',    href: signout_path) }
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title(full_title('About Us'))
    click_link "Help"
    expect(page).to have_title(full_title('Help'))
    click_link "Contact"
    expect(page).to have_title(full_title('Contact'))
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title(full_title('Sign up'))
    click_link "sample app"
    expect(page).to have_title(full_title(''))
  end

  describe "Home page" do
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      let(:other_user) { FactoryGirl.create(:user, email: "other@example.com") }
      before do
        40.times { FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum") }
        20.times { FactoryGirl.create(:micropost, user: other_user, content: "Lorem ipsum") }
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li.feed-item", count: 30)
        end
      end

      it "should paginate the user's feed" do
        expect(page).to have_selector('div.pagination')
      end

      it "should count user's microposts" do
        expect(page).to have_selector("span#sidebar-microposts-count", text: "#{user.microposts.count} "+"micropost".pluralize(user.microposts.count))
      end
    end
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About' }
    let(:page_title) { 'About Us' }

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact' }
    let(:page_title) { 'Contact' }

    it_should_behave_like "all static pages"
  end
end