require 'spec_helper'

describe "Team pages" do

  subject { page }

  describe "show page" do
    let(:team) { FactoryGirl.create(:team) }
    before { visit team_path(team) }

    it { should have_selector('h1', text: team.name) }
    it { should have_selector('title', text: team.name) }
  end
end