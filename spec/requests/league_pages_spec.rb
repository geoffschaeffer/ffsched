require 'spec_helper'

describe "League pages" do

  subject { page }

  describe "show page" do
    let(:league) { FactoryGirl.create(:league) }
    before { visit league_path(league) }

    it { should have_selector('h1', text: league.name) }
    it { should have_selector('title', text: league.name) }
  end
end