require 'spec_helper'

describe "League pages" do

  subject { page }

  describe "index" do

    let(:league) { FactoryGirl.create(:league) }
    before(:all) { 13.times { FactoryGirl.create(:league) } }
    after(:all)  { League.delete_all }

    before(:each) do
      visit leagues_path
    end

    it { should have_selector('title', text: 'All leagues') }
    it { should have_selector('h1',    text: 'All leagues') }
  end

  describe "show page" do
    let(:league) { FactoryGirl.create(:league) }
    let!(:team1) { FactoryGirl.create(:team, league: league) }
    let!(:team2) { FactoryGirl.create(:team, league: league) }

    before { visit league_path(league) }

    it { should have_selector('h1', text: league.name) }
    it { should have_selector('title', text: league.name) }

    describe "teams" do
      it { should have_content(team1.name) }
      it { should have_content(team2.name) }
      it { should have_content(league.teams.count) }
    end

    describe "while not at max teams" do
      it { should have_content("Add new team") }
    end

    describe "while at max teams" do
      before(:all) { 12.times { FactoryGirl.create(:team, league: league) } }
      after(:all)  { Team.delete_all }

      it { should_not have_content("Add new team") }
    end

    describe "delete team" do
      it "should decrement the number of teams" do
        expect do
          click_link "Delete"
        end.to change(league.teams, :count).by(-1)
      end
    end
  end

  describe "create league" do
    before { visit new_league_path }

    let(:submit) { "Create league" }

    describe "with invalid information" do
      it "should not create a league" do
        expect { click_button submit }.not_to change(League, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Valid League"
      end

      it "should create a league" do
        expect { click_button submit }.to change(League, :count).by(1)
      end

      describe "after saving the league" do
        before { click_button submit }
        let(:league) { League.find_by_name('Valid League') }

        it { should have_content(league.name) }
        it { should have_selector('div.alert.alert-success', text: 'Created League!') }
      end
    end
  end

  describe "edit" do
    let(:league) { FactoryGirl.create(:league) }
    before do
      visit edit_league_path(league)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update league") }
      it { should have_selector('title', text: "Update league") }
    end

    describe "with invalid information" do
      before do
        fill_in "Name", with: nil
        click_button "Update league"
      end

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      before do
        fill_in "Name", with: new_name
        click_button "Update league"
      end

      it { should have_content(new_name) }
      it { should have_selector('div.alert.alert-success') }
      specify { league.reload.name.should  == new_name }
    end
  end
end