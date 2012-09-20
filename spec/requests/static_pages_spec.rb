require 'spec_helper'

describe "Static pages" do

  describe "Home page" do
    before { visit root_path }

    it "should have the content 'Fantasy Football Scheduler'" do
      page.should have_content('Fantasy Football Scheduler')
    end
  end
end
