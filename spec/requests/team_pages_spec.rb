require 'spec_helper'

describe "Team pages" do

  subject { page }

  describe "show page" do
    let(:league) { FactoryGirl.create(:league) }
    let!(:team) { FactoryGirl.create(:team, league: league) }
    before { visit league_team_path(league, team) }

    it { should have_selector('h1', text: team.name) }
    it { should have_selector('title', text: team.name) }
  end
end