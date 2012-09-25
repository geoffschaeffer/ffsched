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
        format.xml  { render xml: @league, status: :created, location: @person }
      else
        format.html { render 'new' }
        format.xml { render xml: @league.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @league = League.find(params[:id])
    #TODO - is this correct?
    respond_with(@league)
  end

  def update
    @league = League.find(params[:id])

    #TODO - rock this on Tues
    if @league.update_attributes(params[:league])
      # Handle a successful update.
      flash[:success] = "League updated"
      redirect_to leagues_path
    else
      render 'edit'
    end
  end

  def destroy
    League.find(params[:id]).destroy
    flash[:success] = "League destroyed."
    redirect_to leagues_path
  end
end
