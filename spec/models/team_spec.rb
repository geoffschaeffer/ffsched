require 'spec_helper'

describe Team do
  let(:league) { FactoryGirl.create(:league) }
  before { @team = league.teams.build(name: "Example Team", owner: "Example Owner") }

  subject { @team }

  it { should respond_to(:name) }
  it { should respond_to(:owner) }
  it { should respond_to(:league) }
  its(:league) { should == league }

  it { should be_valid }

  describe "when name is not present" do
    before { @team.name = " " }
    it { should_not be_valid }
  end

  describe "when owner is not present" do
    before { @team.owner = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @team.name = "a" * 26 }
    it { should_not be_valid }
  end

  describe "when owner is too long" do
    before { @team.owner = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when name is already taken" do
    before do
      team_with_same_name = @team.dup
      team_with_same_name.save
    end
    it { should_not be_valid }
  end

  describe "when league_id is not present" do
    before { @team.league_id = nil }
    it { should_not be_valid }
  end

  describe "accessible attributes" do
    it "should not allow access to league_id" do
      expect do
        Team.new(league_id: league.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
end
