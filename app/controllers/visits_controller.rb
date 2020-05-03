class VisitsController < ApplicationController

  def new
    @visit = Visit.new
  end


  def edit

  end

  def create
    Visit.create(
      patient_id: params["patient_id"],
      visited_at: DateTime.civil(params["visited_at(1i)"].to_i,
      params["visited_at(2i)"].to_i, params["visited_at(3i)"].to_i,
      params["visited_at(4i)"].to_i,params["visited_at(5i)"].to_i),
      treatment: params["treatment"]
    )
    redirect_to patient_path(params["patient_id"])
  end

  def index
    @visit = @patient.visit
  end

  def show
      @visit = Visit.find.patient(params[:id])
    end


  def destroy
    Visit.find(params[:id]).destroy
    respond_to do |format|
      format.html { redirect_back(fallback_location: patients_path)}
      flash[:notice] = 'Визит успешно удален'
      format.json { head :no_content }
    end
  end

end