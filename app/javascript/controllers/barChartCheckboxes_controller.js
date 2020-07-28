
import { Controller } from "stimulus"

export default class extends Controller {
    static targets = [ "liver2.checkbox", "liver3.checkbox"]

   liver2Effect() {
  if (liver2.checked) {
      document.querySelector("#w0").style.height=((Math.round(slide_wood_yin.value)-10) + "%" );
      document.querySelector("#w1").style.height=((Math.round(slide_wood_yang.value)+10) + "%" );
      document.querySelector("#f0").style.height=((Math.round(slide_fire_yin.value)+10) + "%" );
      document.querySelector("#f1").style.height=((Math.round(slide_fire_yang.value)-10) + "%" );
      document.querySelector("#fe0").style.height=((Math.round(slide_fire_in_earth_yin.value)+5) + "%" );
      document.querySelector("#fe1").style.height=((Math.round(slide_fire_in_earth_yang.value)-5) + "%" );
      document.querySelector("#e0").style.height=((Math.round(slide_earth_yin.value)-5) + "%" );
    } else {
      document.querySelector("#w0").style.height=((Math.round(slide_wood_yin.value)) + "%" );
      document.querySelector("#w1").style.height=((Math.round(slide_wood_yang.value)) + "%" );
      document.querySelector("#f0").style.height=((Math.round(slide_fire_yin.value)) + "%" );
      document.querySelector("#f1").style.height=((Math.round(slide_fire_yang.value)) + "%" );
      document.querySelector("#fe0").style.height=((Math.round(slide_fire_in_earth_yin.value)) + "%" );
      document.querySelector("#fe1").style.height=((Math.round(slide_fire_in_earth_yang.value)) + "%" );
      document.querySelector("#e0").style.height=((Math.round(slide_earth_yin.value)) + "%" );


    }
  }

  liver3Effect() {
    if (liver3.checked) {
      document.querySelector("#w0").style.height=((Math.round(slide_wood_yin.value)-5) + "%" );
      document.querySelector("#w1").style.height=((Math.round(slide_wood_yang.value)+5) + "%" );
      document.querySelector("#f0").style.height=((Math.round(slide_fire_yin.value)+5) + "%" );
      document.querySelector("#f1").style.height=((Math.round(slide_fire_yang.value)-5) + "%" );
    } else {
      document.querySelector("#w0").style.height=((Math.round(slide_wood_yin.value)) + "%" );
      document.querySelector("#w1").style.height=((Math.round(slide_wood_yang.value)) + "%" );
      document.querySelector("#f0").style.height=((Math.round(slide_fire_yin.value)) + "%" );
      document.querySelector("#f1").style.height=((Math.round(slide_fire_yang.value)) + "%" );
    }
  }
};



