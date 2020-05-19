class CitiesController < ApplicationController

  def new
    @city = City.new
  end

  def show
    @cities = City.all
  end

  def create

  end

  def update
    @city = City.find(params[:id])
    @city.update(
      name: params["name"]
    )
  end

  def destroy

  end

end