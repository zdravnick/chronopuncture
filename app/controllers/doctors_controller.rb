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
      city: params[:city_id],
      password: params[:password]
    )
  end

def update
  Doctor.updame:
    name: params[:name],
    email: params[:email],
    city: params[:city_id]
end
