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

  describe "index" do

    let(:league) { FactoryGirl.create(:league) }
    let!(:team1) { FactoryGirl.create(:team, league: league) }
    let!(:team2) { FactoryGirl.create(:team, league: league) }
    let!(:matchup) { FactoryGirl.create(:matchup, league: league, team1: team1, team2: team2) }

    before(:each) do
      visit league_matchups_path(league)
    end

    it { should have_selector('title', text: "Matchups for #{league.name}") }
    it { should have_selector('h1',    text: "Matchups for #{league.name}") }

    it { should have_content(matchup.get_display_name) }

    describe "delete matchup" do
      it "should decrement the number of matchups" do
        expect do
          click_link "Delete"
        end.to change(league.matchups, :count).by(-1)
      end
    end
  end

  describe "create matchup" do
    let(:league) { FactoryGirl.create(:league) }
    let!(:team1) { FactoryGirl.create(:team, league: league) }
    let!(:team2) { FactoryGirl.create(:team, league: league) }
    before { visit new_league_matchup_path(league) }

    let(:submit) { "Create matchup" }

    describe "with invalid information" do
      it "should not create a team" do
        expect { click_button submit }.not_to change(Matchup, :count)
      end
    end

    describe "with valid information" do
      before do
        select team1.name, from: 'Team1'
        select team2.name, from: 'Team2'
        select "1", from: 'Week'
      end

      it "should create a team" do
        expect { click_button submit }.to change(Matchup, :count).by(1)
      end

      describe "after saving the Matchup" do
        before { click_button submit }
        let(:matchup) { Matchup.find_by_team1_id_and_team2_id(team1.id, team2.id) }

        it { should have_content(matchup.get_display_name) }
        it { should have_selector('div.alert.alert-success', text: 'Created Matchup!') }
      end
    end
  end

  describe "edit" do
    let(:league) { FactoryGirl.create(:league) }
    let!(:team1) { FactoryGirl.create(:team, league: league) }
    let!(:team2) { FactoryGirl.create(:team, league: league) }
    let!(:matchup) { FactoryGirl.create(:matchup, league: league, team1: team1, team2: team2) }
    before { visit edit_league_matchup_path(league, matchup) }

    describe "page" do
      it { should have_selector('h1',    text: "Update Matchup") }
      it { should have_selector('title', text: "Update Matchup") }
    end

    describe "with valid information" do
      let(:new_week)  { 2 }
      before do
        select team1.name, from: 'Team1'
        select team2.name, from: 'Team2'
        select new_week.to_s, from: 'Week'
        click_button "Update matchup"
      end

      it { should have_content(matchup.reload.get_display_name) }
      it { should have_selector('div.alert.alert-success') }
      specify { matchup.reload.week.should  == new_week }
    end
  end

end