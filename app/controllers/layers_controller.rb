class LayersController < ApplicationController

  def show
    @layer = Layer.find(params[:id])
  end

end