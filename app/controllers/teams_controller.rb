class TeamsController < ApplicationController
  respond_to :html
  respond_to :xml

  before_filter :league_fetch

  def index
    respond_with(@teams = @league.teams)
  end

  def show
    @team = Team.find(params[:id])
    @matchups = get_matchups
    respond_with(@team)
  end

  def new
    @team = @league.teams.build
    respond_with(@team)
  end

  def create
    @team = @league.teams.build( params[:team])

    respond_to do |format|
      if @team.save
        format.html {
          # Handle a successful save.
          flash[:success] = "Created Team!"
          redirect_to league_path(@league)
        }
        format.xml  { render xml: @team, status: :created, location: @team }
      else
        format.html { render 'new' }
        format.xml { render xml: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @team = @league.teams.find(params[:id])
    respond_with(@team)
  end

  def update
    @team = Team.find(params[:id])

    respond_to do |format|
      if @team.update_attributes(params[:team])
        format.html {
          # Handle a successful update.
          flash[:success] = "Team updated"
          redirect_to league_path(@league)
        }
        format.xml { head :ok }
      else
        format.html { render 'edit' }
        format.xml { render xml: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @team = @league.teams.find_by_id(params[:id])
    @team.destroy
    #flash[:success] = "Team destroyed."
    respond_to do |format|
      format.html { redirect_to league_path(@league) }
      format.xml { head :ok }
      format.js
    end
  end

  private

  def league_fetch
    @league = League.find(params[:league_id])
  end

  def get_matchups
    #@match_list = @team.home_matchups + @team.away_matchups
    @match_list = @team.matchups + @team.reverse_matchups
    @match_list.sort_by{ |match| match[:week] }
  end
end
