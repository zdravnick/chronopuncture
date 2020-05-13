def new
  @city = City.new
  doctor: current_doctor
  patient: current_doctor(@patient)
end


def create
  doctor: current_doctor
end

def update
  doctor: current_doctor
end

def destroy
  doctor: current_doctor
end