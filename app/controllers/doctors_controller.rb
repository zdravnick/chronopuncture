class DoctorsController < ApplicationController
  def new
    @doctor = Doctor.new
  end


  def show
    @doctor = Doctor.find(params[:id])
  end

  def create
    Doctor.create(
      name: params[:name],
      email: params[:email],
      # password: params[:password]
    )
  end





end
