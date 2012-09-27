class MatchupsController < ApplicationController
  before_filter :league_fetch

  def index
    @matchups = @league.matchups
  end

  def new
    @matchup = @league.matchups.build
  end

  def create
    @matchup = @league.matchups.build( params[:matchup])
    if @matchup.save
      flash[:success] = "Created Matchup!"
      redirect_to league_matchups_path(@league)
    else
      render 'new'
    end
  end

  def edit
    @matchup = @league.matchups.find(params[:id])
  end

  def update
    @matchup = Matchup.find(params[:id])
    if @matchup.update_attributes(params[:matchup])
      flash[:success] = "Matchup updated"
      redirect_to league_matchups_path(@league)
    else
      render 'edit'
    end
  end

  def destroy
    @matchup = @league.matchups.find_by_id(params[:id])
    @matchup.destroy
    flash[:success] = "Matchup destroyed."
    redirect_to league_matchups_path(@league)
  end

  private

  def league_fetch
    @league = League.find(params[:league_id])
  end

end
