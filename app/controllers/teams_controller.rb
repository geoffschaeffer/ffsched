class TeamsController < ApplicationController
  before_filter :league_fetch

  def index
    @teams = @league.teams
  end

  def show
    @team = Team.find(params[:id])
  end

  def new
    @team = @league.teams.build
  end

  def create
    @team = @league.teams.build( params[:team])
    if @team.save
      # Handle a successful save.
      flash[:success] = "Created Team!"
      redirect_to league_path(@league)
    else
      render 'new'
    end
  end

  def edit
    @team = @league.teams.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      # Handle a successful update.
      flash[:success] = "Team updated"
      redirect_to league_path(@league)
    else
      render 'edit'
    end
  end

  def destroy
    @team = @league.teams.find_by_id(params[:id])
    @team.destroy
    #flash[:success] = "Team destroyed."
    respond_to do |format|
      format.html { redirect_to league_path(@league) }
      format.js
    end
  end

  private

  def league_fetch
    @league = League.find(params[:league_id])
  end
end
