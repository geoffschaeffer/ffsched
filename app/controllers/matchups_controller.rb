class MatchupsController < ApplicationController
  respond_to :html
  respond_to :xml

  before_filter :league_fetch

  def index
    respond_with(@matchups = @league.matchups)
  end

  def show
    @matchup = Matchup.find(params[:id])
    respond_with(@matchup)
  end

  def new
    @matchup = @league.matchups.build
    respond_with(@matchup)
  end

  def create
    @matchup = @league.matchups.build( params[:matchup])

    respond_to do |format|
      if @matchup.save
        format.html {
          flash[:success] = "Created Matchup!"
          redirect_to league_matchups_path(@league)
        }
        format.xml  { render xml: @matchup, status: :created, location: @matchup }
      else
        format.html { render 'new' }
        format.xml { render xml: @matchup.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @matchup = @league.matchups.find(params[:id])
    respond_with(@matchup)
  end

  def update
    @matchup = Matchup.find(params[:id])

    respond_to do |format|
      if @matchup.update_attributes(params[:matchup])
        format.html {
          flash[:success] = "Matchup updated"
          redirect_to league_matchups_path(@league)
        }
        format.xml { head :ok }
      else
        format.html { render 'edit' }
        format.xml { render xml: @matchup.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @matchup = @league.matchups.find_by_id(params[:id])
    @matchup.destroy
    respond_to do |format|
      format.html {
        flash[:success] = "Matchup destroyed."
        redirect_to league_matchups_path(@league)
      }
      format.xml { head :ok }
    end
  end

  private

  def league_fetch
    @league = League.find(params[:league_id])
  end

end
