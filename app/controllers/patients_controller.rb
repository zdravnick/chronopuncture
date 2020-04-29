class PatientsController < ApplicationController

  before_action :authenticate_doctor!

  def new
    @patient =  Patient.new
  end

def create
    Patient.create(
      doctor: current_doctor,
      name: params[:name],
      birthdate: DateTime.civil(params["birthdate(1i)"].to_i,
      params["birthdate(2i)"].to_i, params["birthdate(3i)"].to_i,
      params["birthdate(4i)"].to_i,params["birthdate(5i)"].to_i),
      diagnosis: params["diagnosis"]
    )
end

def index
  @patients = current_doctor.patients
end

  def show
    @patient = Patient.find(params[:id])
  end

  def destroy
    if doctor_signed_in?
      Patient.find(params[:id]).destroy
      flash[:success] = "Пацик убит!"
      redirect_to patients_path
    end
  end

end
