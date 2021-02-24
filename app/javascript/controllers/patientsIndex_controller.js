import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "output" ]

  connect() {
    console.log('patientsIndex_controller');
  }

  showPatients(){
    document.getElementById('patients_list').classList.toggle('patients_list_show');
    document.getElementById('patients_list').classList.toggle('patients_list_hide');
    document.getElementById('btn_patients_list_show').classList.toggle('btn_patients_list_show');
  }

  showHexagramsWithMeridians(){
    document.getElementById('hexagrams_with_meridians_list').classList.toggle('show_hexagrams_with_meridians_list');
    document.getElementById('hexagrams_with_meridians_list').classList.toggle('hide_hexagrams_with_meridians_list');
  }

  showCommonMethods(){
    document.getElementById('common_methods_list').classList.toggle('show_common_methods');
    document.getElementById('common_methods_list').classList.toggle('hide_common_methods');
  }

  findPatientForm(){
    document.getElementById('find_patient_form').classList.toggle('find_patient_form_show');
    document.getElementById('find_patient_form').classList.toggle('find_patient_form_hide');
  }

}