class TrunksController < ApplicationController

  def show
    @trunc = Trunks.find(params[:id])
  end

end
