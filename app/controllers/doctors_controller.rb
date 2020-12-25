class DoctorsController < ApplicationController
  def new
    @doctor = Doctor.new
    @doctor.paid_until = DateTime.current+1.days
  end

  def show
    @doctor = Doctor.find(params[:id])
  end

end