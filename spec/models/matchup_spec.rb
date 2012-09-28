require 'spec_helper'

describe Matchup do
  let(:league) { FactoryGirl.create(:league) }
  let!(:team1) { FactoryGirl.create(:team, league: league) }
  let!(:team2) { FactoryGirl.create(:team, league: league) }
  let!(:team3) { FactoryGirl.create(:team, league: league) }
  before { @matchup = league.matchups.build(team1_id: team1.id, team2_id: team2.id, week: 1) }

  subject { @matchup }

  it { should respond_to(:team1_id) }
  it { should respond_to(:team2_id) }
  it { should respond_to(:week) }
  its(:league) { should == league }

  it { should respond_to(:get_display_name) }

  it { should be_valid }

  describe "when team1_id is not present" do
    before { @matchup.team1_id = nil }
    it { should_not be_valid }
  end

  describe "when team2_id is not present" do
    before { @matchup.team2_id = nil }
    it { should_not be_valid }
  end

  describe "when league_id is not present" do
    before { @matchup.league_id = nil }
    it { should_not be_valid }
  end

  describe "when week is not present" do
    before { @matchup.week = nil }
    it { should_not be_valid }
  end

  describe "when team plays self" do
    before { @matchup.team1_id = @matchup.team2_id }
    it { should_not be_valid }
  end

  describe "when matchup exists reversed" do
    before {
      other_matchup = league.matchups.build(team1_id: team2.id, team2_id: team1.id, week: 2)
      other_matchup.save
    }
    it { should_not be_valid }
  end

  describe "when team1 already has matchup that week" do
    before {
      other_matchup = league.matchups.build(team1_id: team1.id, team2_id: team3.id, week: 1)
      other_matchup.save
    }
    it { should_not be_valid }
  end

  describe "when team2 already has matchup that week" do
    before {
      other_matchup = league.matchups.build(team1_id: team3.id, team2_id: team2.id, week: 1)
      other_matchup.save
    }
    it { should_not be_valid }
  end

  describe "when team1 already has matchup that week (as team2)" do
    before {
      other_matchup = league.matchups.build(team1_id: team3.id, team2_id: team1.id, week: 1)
      other_matchup.save
    }
    it { should_not be_valid }
  end

  describe "when team2 already has matchup that week (as team1)" do
    before {
      other_matchup = league.matchups.build(team1_id: team2.id, team2_id: team3.id, week: 1)
      other_matchup.save
    }
    it { should_not be_valid }
  end

end
