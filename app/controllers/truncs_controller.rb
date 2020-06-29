class TruncsController < ApplicationController

  def show
    @trunc = Truncs.find(params[:id])
  end

end