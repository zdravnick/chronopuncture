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
    redirect_to patients_path

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
      respond_to do |format|
      format.html { redirect_to patients_path, notice: 'patient was successfully destroyed.' }
      format.json { head :no_content }
    end
    end
  end

def update
    @patient = Patient.find(params[:id]).update(
      doctor: current_doctor,
      name: params[:name],
      birthdate: DateTime.civil(params["birthdate(1i)"].to_i,
      params["birthdate(2i)"].to_i, params["birthdate(3i)"].to_i,
      params["birthdate(4i)"].to_i,params["birthdate(5i)"].to_i),
      diagnosis: params["diagnosis"]
    )
    redirect_back(fallback_location: patients_path)
    flash[:notice] = 'Данные пациента обновлены, доктор'
  end
end
