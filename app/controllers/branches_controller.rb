class BranchesController < ApplicationController

  def show
    @branch = Branches.find(params[:id])
  end



end