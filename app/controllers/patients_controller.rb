class PatientsController < ApplicationController

  before_action :authenticate_doctor!, except: :color_mode_action
  # skip_before_action :require_payment

  def color_mode_action
    cookies.signed[:color_mode_cookie] = params[:color_mode_param]
    redirect_back fallback_location: root_path
  end

  def new
    @patient =  Patient.new
  end

  def create
    @patient =  Patient.create(
      doctor: current_doctor,
      name: params[:name],
      birthdate: DateTime.civil(params["birthdate(1i)"].to_i,
      params["birthdate(2i)"].to_i, params["birthdate(3i)"].to_i,
      params["birthdate(4i)"].to_i,params["birthdate(5i)"].to_i),
      diagnosis: params["diagnosis"],
      description: params["description"],
      city_id: params["city_id"]
    )
    redirect_to patient_path(@patient) rescue redirect_to patients_path flash.notice = 'Имени у пациента нет!'
  end

  def index
    @patients = current_doctor.patients.active.order(updated_at: :desc).page params[:page]
    name = Patient.arel_table[:name]
    Patient.where(name.matches("%#{params[:name]}%"))
    if params[:name].present?
      @patients = @patients.where(name.matches("%#{params[:name]}%"))
      if @patients.count == 1
        redirect_to patient_path(@patients.first)
      elsif @patients.count == 0
       redirect_to root_path, notice: 'Нет такого пациента, доктор!'
      end
    end

    diagnosis = Patient.arel_table[:diagnosis]
    Patient.where(diagnosis.matches("%#{params[:diagnosis]}%"))
    if params[:diagnosis].present?
      @patients = @patients.where(diagnosis.matches("%#{params[:diagnosis]}%"))
      if @patients.count == 1
        redirect_to patient_path(@patients.first)
      elsif @patients.count == 0
       redirect_to root_path, notice: 'Нет пациента с таким диагнозом, доктор!'
      end
    end
  end


  def display_point
    @point = Point.find(params[:id])
    render "points/ "
  end


  def show
    @patient = current_doctor.patients.active.find(params[:id])
    @visits = @patient.visits.order(visited_at: :desc).page params[:page]
    @cities = City.all
  end


  def update
    @patient = current_doctor.patients.active.find(params[:id])
    @patient.update(
      doctor: current_doctor,
      name: params[:patient][:name],
      birthdate: Time.zone.local(params[:patient]["birthdate(1i)"].to_i,
      params[:patient]["birthdate(2i)"].to_i, params[:patient]["birthdate(3i)"].to_i,
      params[:patient]["birthdate(4i)"].to_i,params[:patient]["birthdate(5i)"].to_i).in_time_zone('UTC'),
      diagnosis: params[:patient]["diagnosis"],
      description: params[:patient]["description"],
      city_id: params[:patient]["city_id"],
      pulse_chinese_disease_ids: params[:patient][:pulse_chinese_disease_ids],
      tongue_chinese_disease_ids: params[:patient][:tongue_chinese_disease_ids],
    )

    redirect_back(fallback_location: patients_path)
    # flash[:notice] = 'Данные пациента обновлены, доктор'
    end

  def destroy
    @patient = current_doctor.patients.active.find(params[:id])
    @patient.destroy!
    respond_to do |format|
      format.html { redirect_to patients_path, notice: 'Пациент удален, доктор' }
      format.json { head :no_content }
    end
  end

end
