require 'spec_helper'

describe "Team pages" do

  subject { page }

  describe "show page" do
    let(:league) { FactoryGirl.create(:league) }
    let!(:team1) { FactoryGirl.create(:team, league: league) }
    let!(:team2) { FactoryGirl.create(:team, league: league) }
    let!(:matchup) { FactoryGirl.create(:matchup, league: league, team1: team1, team2: team2) }
    before { visit league_team_path(league, team1) }

    it { should have_selector('h1', text: team1.name) }
    it { should have_selector('title', text: team1.name) }
    it { should have_selector('h2', text: team1.owner) }

    describe "matchups" do
      it { should have_content(matchup.get_display_name) }
    end
  end

  describe "create team" do
    let(:league) { FactoryGirl.create(:league) }
    before { visit new_league_team_path(league) }

    let(:submit) { "Create team" }

    describe "with invalid information" do
      it "should not create a team" do
        expect { click_button submit }.not_to change(Team, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Valid Team"
        fill_in "Owner", with: "Valid Owner"
      end

      it "should create a team" do
        expect { click_button submit }.to change(Team, :count).by(1)
      end

      describe "after saving the team" do
        before { click_button submit }
        let(:team) { Team.find_by_name('Valid Team') }

        it { should have_content(team.name) }
        it { should have_selector('div.alert.alert-success', text: 'Created Team!') }
      end
    end
  end

  describe "edit" do
    let(:league) { FactoryGirl.create(:league) }
    let!(:team) { FactoryGirl.create(:team, league: league) }
    before { visit edit_league_team_path(league, team) }

    describe "page" do
      it { should have_selector('h1',    text: "Update team") }
      it { should have_selector('title', text: "Update team") }
    end

    describe "with invalid information" do
      before do
        fill_in "Name", with: nil
        click_button "Update team"
      end

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_owner)  { "New Owner" }
      before do
        fill_in "Name", with: new_name
        fill_in "Owner", with: new_owner
        click_button "Update team"
      end

      it { should have_content(new_name) }
      it { should have_selector('div.alert.alert-success') }
      specify { team.reload.name.should  == new_name }
    end
  end
end