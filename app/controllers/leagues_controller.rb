class LeaguesController < ApplicationController

  respond_to :html
  respond_to :xml

  def index
    respond_with(@leagues = League.all)
  end

  def show
    @league = League.find(params[:id])
    @teams = @league.teams
    respond_with(@league)
  end

  def new
    @league = League.new
    respond_with(@league)
  end

  def create
    @league = League.new(params[:league])

    respond_to do |format|
      if @league.save
        format.html {
          flash[:success] = "Created League!"
          redirect_to leagues_path
        }
        format.xml  { render xml: @league, status: :created, location: @league }
      else
        format.html { render 'new' }
        format.xml { render xml: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @league = League.find(params[:id])
    respond_with(@league)
  end

  def update
    @league = League.find(params[:id])

    respond_to do |format|
      if @league.update_attributes(params[:league])
        format.html {
          flash[:success] = "League updated"
          redirect_to leagues_path
        }
        format.xml { head :ok }
      else
        format.html { render 'edit' }
        format.xml { render xml: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    League.find(params[:id]).destroy
    respond_to do |format|
      format.html {
        flash[:success] = "League destroyed."
        redirect_to leagues_path
      }
      format.xml { head :ok }
    end
  end
end
