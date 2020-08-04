
import { Controller } from "stimulus"

export default class extends Controller {

   connect(){
    // console.log('barChart');

  }
    static targets = [ "liver8", "liver1", "kidney10", "kidney7" ]


   liver8Effect() {
    let containerHeight, woodYinIndicatorHeight, woodYinCurrentValue, fireYinCurrentValue,
    fireYinIndicatorHeight, waterYinCurrentValue, waterYinIndicatorHeight;
    containerHeight = getComputedStyle(document.querySelector(".indicator_wrapper")).height;

    woodYinIndicatorHeight = getComputedStyle(document.querySelector("#w0")).height;
    woodYinCurrentValue = parseInt(woodYinIndicatorHeight)/parseInt(containerHeight)*100;

    fireYinIndicatorHeight = getComputedStyle(document.querySelector("#f0")).height;
    fireYinCurrentValue = parseInt(fireYinIndicatorHeight)/parseInt(containerHeight)*100;

    waterYinIndicatorHeight = getComputedStyle(document.querySelector("#wt0")).height;
    waterYinCurrentValue = parseInt(waterYinIndicatorHeight)/parseInt(containerHeight)*100;



    if (liver8.checked) {
      document.querySelector("#w0").style.height = (woodYinCurrentValue - 10) + "%";
      document.querySelector("#f0").style.height = (fireYinCurrentValue + 10) + "%";
      document.querySelector("#wt0").style.height = (waterYinCurrentValue - 5) + "%";
      }
    else {
      document.querySelector("#w0").style.height = (woodYinCurrentValue + 10) + "%";
      document.querySelector("#f0").style.height = (fireYinCurrentValue - 10) + "%";
      document.querySelector("#wt0").style.height = (waterYinCurrentValue + 5) + "%";

    }
    return (
      document.querySelector("#w0").style.height
      + document.querySelector("#f0").style.height
      + console.log('wood_yin= ' + document.querySelector("#w0").style.height)
      + console.log('fire_yin= ' + document.querySelector("#f0").style.height)
      + console.log('water_yin= ' + document.querySelector("#wt0").style.height)
      );
  }

  liver1Effect() {
    let containerHeight, woodYinIndicatorHeight, woodYinCurrentValue, fireYinCurrentValue,
    fireYinIndicatorHeight;
    containerHeight = getComputedStyle(document.querySelector(".indicator_wrapper")).height;

    woodYinIndicatorHeight = getComputedStyle(document.querySelector("#w0")).height;
    woodYinCurrentValue = parseInt(woodYinIndicatorHeight)/parseInt(containerHeight)*100;

    fireYinIndicatorHeight = getComputedStyle(document.querySelector("#f0")).height;
    fireYinCurrentValue = parseInt(fireYinIndicatorHeight)/parseInt(containerHeight)*100;

    if (liver1.checked) {
      document.querySelector("#w0").style.height = (woodYinCurrentValue - 5) + "%";
      document.querySelector("#f0").style.height = (fireYinCurrentValue + 5) + "%";
    } else {
      document.querySelector("#w0").style.height = (woodYinCurrentValue + 5) + "%";
      document.querySelector("#f0").style.height = (fireYinCurrentValue - 5) + "%";
    }
    return (
      document.querySelector("#w0").style.height
      + document.querySelector("#f0").style.height
      + console.log('wood_yin= ' + document.querySelector("#w0").style.height)
      + console.log('fire_yin= ' + document.querySelector("#f0").style.height)
        );
  }



  kidney10Effect() {
    let containerHeight, woodYinIndicatorHeight, woodYinCurrentValue, fireYinCurrentValue,
    fireYinIndicatorHeight, waterYinCurrentValue, waterYinIndicatorHeight;
    containerHeight = getComputedStyle(document.querySelector(".indicator_wrapper")).height;

    waterYinIndicatorHeight = getComputedStyle(document.querySelector("#wt0")).height;
    waterYinCurrentValue = parseInt(waterYinIndicatorHeight)/parseInt(containerHeight)*100;

    woodYinIndicatorHeight = getComputedStyle(document.querySelector("#w0")).height;
    woodYinCurrentValue = parseInt(woodYinIndicatorHeight)/parseInt(containerHeight)*100;

    fireYinIndicatorHeight = getComputedStyle(document.querySelector("#f0")).height;
    fireYinCurrentValue = parseInt(fireYinIndicatorHeight)/parseInt(containerHeight)*100;


    if (kidney10.checked) {
      document.querySelector("#wt0").style.height = (waterYinCurrentValue - 5) + "%";
      document.querySelector("#w0").style.height = (woodYinCurrentValue + 5) + "%";
      document.querySelector("#f0").style.height = (fireYinCurrentValue - 5) + "%";

    } else {
      document.querySelector("#wt0").style.height = (waterYinCurrentValue + 5) + "%";
      document.querySelector("#w0").style.height = (woodYinCurrentValue - 5) + "%";
      document.querySelector("#f0").style.height = (fireYinCurrentValue + 5) + "%";

    }
    return (
      document.querySelector("#w0").style.height
      + document.querySelector("#f0").style.height
      + console.log('water_yin= ' + document.querySelector("#wt0").style.height)
      + console.log('wood_yin= ' + document.querySelector("#w0").style.height)
      + console.log('fire_yin= ' + document.querySelector("#f0").style.height)
        );
  }

  kidney7Effect() {
    let containerHeight, woodYinIndicatorHeight, woodYinCurrentValue, fireYinCurrentValue,
    fireYinIndicatorHeight, waterYinCurrentValue, waterYinIndicatorHeight;
    containerHeight = getComputedStyle(document.querySelector(".indicator_wrapper")).height;

    waterYinIndicatorHeight = getComputedStyle(document.querySelector("#wt0")).height;
    waterYinCurrentValue = parseInt(waterYinIndicatorHeight)/parseInt(containerHeight)*100;

    woodYinIndicatorHeight = getComputedStyle(document.querySelector("#w0")).height;
    woodYinCurrentValue = parseInt(woodYinIndicatorHeight)/parseInt(containerHeight)*100;

    fireYinIndicatorHeight = getComputedStyle(document.querySelector("#f0")).height;
    fireYinCurrentValue = parseInt(fireYinIndicatorHeight)/parseInt(containerHeight)*100;

    if (kidney7.checked) {
      document.querySelector("#wt0").style.height = (waterYinCurrentValue - 10) + "%";
      document.querySelector("#w0").style.height = (woodYinCurrentValue + 10) + "%";
      document.querySelector("#f0").style.height = (fireYinCurrentValue - 5) + "%";
    } else {
      document.querySelector("#wt0").style.height = (waterYinCurrentValue + 10) + "%";
      document.querySelector("#w0").style.height = (woodYinCurrentValue - 10) + "%";
      document.querySelector("#f0").style.height = (fireYinCurrentValue + 5) + "%";
    }
    return (
      document.querySelector("#w0").style.height
      + document.querySelector("#f0").style.height
      + console.log('water_yin= ' + document.querySelector("#wt0").style.height)
      + console.log('wood_yin= ' + document.querySelector("#w0").style.height)
      + console.log('fire_yin= ' + document.querySelector("#f0").style.height)
        );
  }

};



