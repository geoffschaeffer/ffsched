class TeamsController < ApplicationController

  def index
    @teams = Team.all
  end

  def show
    @team = Team.find(params[:id])
  end

  def new
    @team = Team.new
  end

  def create
    @team = Team.new(params[:team])
    if @team.save
      # Handle a successful save.
      flash[:success] = "Created Team!"
      redirect_to teams_path
    else
      render 'new'
    end
  end

  def edit
    @team = Team.find(params[:id])
  end

  def update
    @team = Team.find(params[:id])
    if @team.update_attributes(params[:team])
      # Handle a successful update.
      flash[:success] = "Team updated"
      redirect_to teams_path
    else
      render 'edit'
    end
  end

  def destroy
    Team.find(params[:id]).destroy
    flash[:success] = "Team destroyed."
    redirect_to teams_path
  end
end
