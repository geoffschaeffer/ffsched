class LeaguesController < ApplicationController

  def index
    @leagues = League.all
  end

  def show
    @league = League.find(params[:id])
  end

  def new
    @league = League.new
  end

  def create
    @league = League.new(params[:league])
    if @league.save
      # Handle a successful save.
      flash[:success] = "Created League!"
      redirect_to leagues_path
    else
      render 'new'
    end
  end

  def edit
    @league = League.find(params[:id])
  end

  def update
    @league = League.find(params[:id])
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
