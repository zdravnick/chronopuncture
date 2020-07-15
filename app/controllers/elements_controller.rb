class ElementsController < ApplicationController
  def new
    @element = ELement.new
  end

  def show
    @element = Element.find(params[:id])
  end

end