class LeaguesController < ApplicationController

  def create
    @league = League.new(params[:league])
    if @league.save
      # Handle a successful save.
      flash[:success] = "Created League!"
      redirect_to @league
    else
      render 'new'
    end
  end

  def new
    @league = League.new
  end

  def show
    @league = League.find(params[:id])
  end
end
