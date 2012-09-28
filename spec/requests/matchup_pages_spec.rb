require "rspec"

describe "Matchup pages" do

  subject { page }

  describe "show page" do
    let(:league) { FactoryGirl.create(:league) }
    let!(:team1) { FactoryGirl.create(:team, league: league) }
    let!(:team2) { FactoryGirl.create(:team, league: league) }
    let!(:matchup) { FactoryGirl.create(:matchup, league: league, team1: team1, team2: team2) }
    before { visit league_matchup_path(league, matchup) }

    it { should have_selector('h1', text: matchup.get_display_name) }
    it { should have_selector('title', text: matchup.get_display_name) }
  end

end