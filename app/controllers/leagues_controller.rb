class LeaguesController < ApplicationController

  def new
  end

  def show
    @league = League.find(params[:id])
  end
end
