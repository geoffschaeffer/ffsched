require 'spec_helper'

describe TeamsController do

  let(:league) { FactoryGirl.create(:league) }
  let!(:team) { FactoryGirl.create(:team, league: league) }

  describe "destroying a team with Ajax" do

    it "should decrement the Relationship count" do
      expect do
        xhr :delete, :destroy, id: team, league_id: league
      end.should change(Team, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: team, league_id: league
      response.should be_success
    end
  end
end