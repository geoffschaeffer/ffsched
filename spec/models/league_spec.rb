require 'spec_helper'

describe League do
  before { @league = League.new(name: "Example League") }

  subject { @league }

  it { should respond_to(:name) }
  it { should respond_to(:get_max_teams) }
  it { should respond_to(:has_room?) }
  it { should respond_to(:team_index_even?) }
  it { should respond_to(:team_index_last) }
  it { should respond_to(:teams) }

  it { should be_valid }

  describe "when name is not present" do
    before { @league.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @league.name = "a" * 26 }
    it { should_not be_valid }
  end

  describe "when name is already taken" do
    before do
      league_with_same_name = @league.dup
      league_with_same_name.save
    end
    it { should_not be_valid }
  end

  describe "team associations" do
    before { @league.save }
    let!(:team) { FactoryGirl.create(:team, league: @league) }

    it "should destroy associated teams" do
      teams = @league.teams
      @league.destroy
      teams.each do |team|
        Team.find_by_id(team.id).should be_nil
      end
    end


  end
end
