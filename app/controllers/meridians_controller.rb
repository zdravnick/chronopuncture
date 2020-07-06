class MeridiansController < ApplicationController

  def show
    @meridian = Meridian.find(params[:id])
  end



end