
import { Controller } from "stimulus"

export default class extends Controller {

   connect(){
    console.log('barChart');
  }
    static targets = [ "liver2", "liver3"]

   liver2Effect() {
  if (liver2.checked) {
      var a = document.querySelector("#w0").style.height=((Math.round(slide_wood_yin.value)-10) + "%" );
      document.querySelector("#w1").style.height=((Math.round(slide_wood_yang.value)+10) + "%" );
      document.querySelector("#f0").style.height=((Math.round(slide_fire_yin.value)+10) + "%" );
      document.querySelector("#f1").style.height=((Math.round(slide_fire_yang.value)-10) + "%" );
      document.querySelector("#fe0").style.height=((Math.round(slide_fire_in_earth_yin.value)+5) + "%" );
      document.querySelector("#fe1").style.height=((Math.round(slide_fire_in_earth_yang.value)-5) + "%" );
      document.querySelector("#e0").style.height=((Math.round(slide_earth_yin.value)-5) + "%" );
    }

    else {
      var a = document.querySelector("#w0").style.height=((Math.round(slide_wood_yin.value)) + "%" );
      document.querySelector("#w1").style.height=((Math.round(slide_wood_yang.value)) + "%" );
      document.querySelector("#f0").style.height=((Math.round(slide_fire_yin.value)) + "%" );
      document.querySelector("#f1").style.height=((Math.round(slide_fire_yang.value)) + "%" );
      document.querySelector("#fe0").style.height=((Math.round(slide_fire_in_earth_yin.value)) + "%" );
      document.querySelector("#fe1").style.height=((Math.round(slide_fire_in_earth_yang.value)) + "%" );
      document.querySelector("#e0").style.height=((Math.round(slide_earth_yin.value)) + "%" );
    }
      return (
        a
        + console.log('a= ' + a)
        );
  }

  liver3Effect(a) {
    if (liver3.checked) {
      a = document.querySelector("#w0").style.height;
     var  b = document.querySelector("#w0").style.height=((parseInt(a)-5) + "%");
      document.querySelector("#w1").style.height=((Math.round(slide_wood_yang.value)+5) + "%" );
      document.querySelector("#f0").style.height=((Math.round(slide_fire_yin.value)+5) + "%" );
      document.querySelector("#f1").style.height=((Math.round(slide_fire_yang.value)-5) + "%" );
    } else {
      b = document.querySelector("#w0").style.height=((Math.round(slide_wood_yin.value)) + "%" );
      document.querySelector("#w1").style.height=((Math.round(slide_wood_yang.value)) + "%" );
      document.querySelector("#f0").style.height=((Math.round(slide_fire_yin.value)) + "%" );
      document.querySelector("#f1").style.height=((Math.round(slide_fire_yang.value)) + "%" );
    }
    return (
        b
        + console.log('b= ' + b)
        );
  }

};



