
import { Controller } from "stimulus"

export default class extends Controller {

   connect(){
    // console.log('barChart');

  }
    static targets = ["slider2Container", "input22",  "w0Indicator",  "myRange", "liver8",
    "liver1", "lung9", "kidney10", "kidney7", "woodYin", "indicator", "wood_yin_range", "indicatorWrapper" ]


sliderChange() {
    this.input22Target.style.background = 'linear-gradient(90deg, green 0%, lime ' + this.input22Target.value + '%, #fff ' + this.input22Target.value + '%, grey 100%)';
    console.log(this.input22Target.value);
}

// чужой слайдер

slider2() {
    // html elements
    var container = document.getElementById("slider2-container");
    var slider = document.getElementById("slider-bar");
    var handle = document.getElementById("slider-handle");
    var submitVal = document.getElementById("submit-value");

    // initial values
    var minVal = Number( document.getElementById("minimum-value").value );
    var maxVal = Number( document.getElementById("maximum-value").value );
    var range = maxVal - minVal;
    var isSliding = false;

    // recalculate range
    submitVal.onclick = function() {
      minVal = Number( document.getElementById("minimum-value").value );
      maxVal = Number( document.getElementById("maximum-value").value );
      range = maxVal - minVal;
    };

    // the sliding function
    var move = function(e) {

      var mouseY = 0;
      var containerTop = 0;
      var newHeight = 0;
      var containerHeight = 0;
      var percentHght = 0;
      var x = 0;
      var y = 0;
      var sliderValue = 0;

      if (!e) var e = window.event;

      if( e.pageY ){ // all browsers except IE before version 9
        mouseY = e.pageY;

      } else if ( e.clientY ) { // IE before version 9
        mouseY = e.clientY;
      }

      containerTop = container.offsetTop;
      newHeight = mouseY - containerTop;
      containerHeight = container.offsetHeight;
      percentHght = newHeight * 100 / containerHeight;

      if( (percentHght <= 100) && (percentHght >= 0) ) {
        slider.style.height = (percentHght) + '%';
        y = 100 - percentHght;
        x = y * range / 100;

      } else if( percentHght < 0 ) {
        percentHght = 0;
        slider.style.height = (percentHght) + '%';
        y = 100 - percentHght;
        x = y * range / 100;

      } else if( percentHght > 100 ) {
        percentHght = 100;
        slider.style.height = (percentHght) + '%';
        y = 100 - percentHght;
        x = y * range / 100;
      }
      sliderValue = Math.round(x);
      document.getElementById('sliderValue').innerHTML = sliderValue + minVal;
    };

    // adding the slide functionality
     var addSlide
     addSlide = function() {
      isSliding = true;
      if ( !window.addEventListener ){
        document.attachEvent('onmousemove',move);
      } else {
        document.addEventListener('mousemove', move, false);
      }
    };

    // removing the slide functionality
     var cancelSlide
     cancelSlide = function() {
      if( isSliding ) {
        if ( window.removeEventListener ) {
          document.removeEventListener('mousemove', move, false);
        } else if ( window.detachEvent ) {
          document.detachEvent('onmousemove', move );
        }
      }
    };

    // cancelling event bubbling
    // cancelling default event action
    var cancelBubble = function(e) {
      var evt = e ? e:window.event;

      if( evt.stopPropagation ){
        evt.stopPropagation();
      }

      if( evt.cancelBubble != null ){
        evt.cancelBubble = true;
      }

      if( evt.preventDefault ){
        evt.preventDefault();
      } else {
        evt.returnValue = false;
      }
    };

    // capture events
    //capturing the mousedown on the handle
    handle.onmousedown = function(e) {
      addSlide();
      cancelBubble(e);
    }

    //capture the mouseup on the handle
    handle.onmouseup = function(e) {
      cancelSlide();
      cancelBubble(e);
    }

    // capture the mouse up on the slider
    slider.onmouseup = function(e) {
      cancelSlide();
      cancelBubble(e);
    }

    // capture the mouse down on the slider
    slider.onmousedown = function(e) {
      move(e);
      cancelBubble(e);
    }

    // capture the mouse up on the container
    container.onmouseup = function(e) {
      cancelSlide();
      cancelBubble(e);
    }

    // capture the mouse down on the container
    container.onmousedown = function(e) {
      move(e);
      cancelBubble(e);
    }

    // capture the mouse up on the window
    document.onmouseup = function(e) {
      cancelSlide();
      cancelBubble(e);
    }

  }


// конец чужого слайдера


    slider(){
      var slider = document.getElementById("my_range");
      var output = document.getElementById("demo");
      output.innerHTML = slider.value;
      let a;
      a = slider.value;
      console.log(a);
      // this.myRangeTarget.style.background = `linear-gradient(90deg, black ${a}, #eee ${(a+1) + '%'}, red ${(a+2) + '%'})`;
      document.getElementById("my_range").style.background = `linear-gradient(90deg, #00b300 ${parseInt(a) + '%'}, #eee ${(parseInt(a)+1) + '%'}, #CCC0C0C0 ${(parseInt(a)+1) + '%'})`;
      slider.oninput = function() {
      output.innerHTML = this.value;
  }
    }


    IndicatorWrapperRange(){

      let container, containerOffset, containerCoords, box, boxTop, boxBottom, woodYinHeight, coordMouseY;
      this.indicatorWrapperTarget;
      containerOffset = this.indicatorWrapperTarget.offsetHeight;
      // box = this.indicatorWrapperTarget.getBoundingClientRect();
      // boxTop = Math.round(box.top);
      // boxBottom = Math.round(box.bottom);

        coordMouseY = event.pageY - event.currentTarget.offsetTop;


      woodYinHeight = Math.round((containerOffset-coordMouseY)/containerOffset*100);
      this.woodYinTarget.style.height = (parseInt(woodYinHeight) + "%" );
      return this.woodYinTarget.style.height
      + console.log('woodYinheight: ' + woodYinHeight)
      + console.log('Мышь: ' + coordMouseY)
      + console.log('Фаза: ' + event.eventPhase)
      + console.log('woodYinTarget: ' + this.woodYinTarget.style.height);
  }

  kidneyPointsEffect(){
    // let containerHeight, woodYinIndicatorHeight, woodYinCurrentValue, woodYangIndicatorHeight,
    // woodYangCurrentValue, fireYinIndicatorHeight, fireYinCurrentValue, fireYangIndicatorHeight,
    //  fireYangCurrentValue, fireInEarthYinIndicatorHeight, fireInEarthYinCurrentValue,
    // fireInEarthYangIndicatorHeight, fireInEarthYangCurrentValue, earthYinIndicatorHeight,
    // earthYinCurrentValue, earthYangIndicatorHeight, earthYangCurrentValue,
    // metalYangIndicatorHeight, metalYangCurrentValue, waterYinCurrentValue,
    // waterYinIndicatorHeight, waterYangCurrentValue, waterYangIndicatorHeight;

    // containerHeight = getComputedStyle(document.querySelector(".indicator_wrapper")).height;

    // let changedIndicatorsKidney7 = ["#wood_yin_range", "#wood_yang_range", "#water_yang_range",
    //  "#fire_in_earth_yang_range", "#earth_yin_range", "#earth_yang_range", "#metal_yang_range"];

    // let kidneyPoints = [kidney10, kidney7];



    // waterYinIndicatorHeight = getComputedStyle(document.querySelector("#water_yin")).height;
    // waterYinCurrentValue = parseInt(waterYinIndicatorHeight)/parseInt(containerHeight)*100;

    // waterYangIndicatorHeight = getComputedStyle(document.querySelector("#water_yang")).height;
    // waterYangCurrentValue = parseInt(waterYangIndicatorHeight)/parseInt(containerHeight)*100;

    // woodYinIndicatorHeight = getComputedStyle(document.querySelector("#wood_yin")).height;
    // woodYinCurrentValue = parseInt(woodYinIndicatorHeight)/parseInt(containerHeight)*100;

    // woodYangIndicatorHeight = getComputedStyle(document.querySelector("#wood_yang")).height;
    // woodYangCurrentValue = parseInt(woodYangIndicatorHeight)/parseInt(containerHeight)*100;

    // fireInEarthYangIndicatorHeight = getComputedStyle(document.querySelector("#fire_in_earth_yin")).height;
    // fireInEarthYangCurrentValue = parseInt(fireInEarthYangIndicatorHeight)/parseInt(containerHeight)*100;

    // earthYangIndicatorHeight = getComputedStyle(document.querySelector("#earth_yang")).height;
    // earthYangCurrentValue = parseInt(earthYangIndicatorHeight)/parseInt(containerHeight)*100;

    // metalYangIndicatorHeight = getComputedStyle(document.querySelector("#metal_yang")).height;
    // metalYangCurrentValue = parseInt(metalYangIndicatorHeight)/parseInt(containerHeight)*100;

    // if (kidney7.checked){

    //   document.querySelector("#wood_yin").style.height = (woodYinCurrentValue + 10) + "%";
    //   document.querySelector("#wood_yin_range").classList.add('indicator_selected_kidney')
    //   document.querySelector("#wood_yang").style.height = (woodYangCurrentValue + 10) + "%";
    //   document.querySelector("#wood_yang_range").classList.add('indicator_selected_kidney')
    //   document.querySelector("#fire_in_earth_yin").style.height = (fireInEarthYangCurrentValue + 10) + "%";
    //   document.querySelector("#fire_in_earth_yin_range").classList.add('indicator_selected_kidney')
    //   document.querySelector("#earth_yang").style.height = (earthYangCurrentValue - 10) + "%";
    //   document.querySelector("#earth_yang_range").classList.add('indicator_selected_kidney')
    //   document.querySelector("#metal_yang").style.height = (metalYangCurrentValue  - 10) + "%";
    //   document.querySelector("#metal_yang_range").classList.add('indicator_selected_kidney')
    //   document.querySelector("#water_yang").style.height = (waterYangCurrentValue  - 10) + "%";
    //   document.querySelector("#water_yang_range").classList.add('indicator_selected_kidney')
    // } else {
    //   document.querySelector("#wood_yin").style.height = (woodYinCurrentValue - 10) + "%";
    //   document.querySelector("#wood_yin_range").classList.remove('indicator_selected_kidney')
    //   document.querySelector("#wood_yang").style.height = (woodYangCurrentValue - 10) + "%";
    //   document.querySelector("#wood_yang_range").classList.remove('indicator_selected_kidney')
    //   document.querySelector("#fire_in_earth_yin").style.height = (fireInEarthYangCurrentValue - 10) + "%";
    //   document.querySelector("#fire_in_earth_yin_range").classList.remove('indicator_selected_kidney')
    //   document.querySelector("#earth_yang").style.height = (earthYangCurrentValue + 10) + "%";
    //   document.querySelector("#earth_yang_range").classList.remove('indicator_selected_kidney')
    //   document.querySelector("#metal_yang").style.height = (metalYangCurrentValue  + 10) + "%";
    //   document.querySelector("#metal_yang_range").classList.remove('indicator_selected_kidney')
    //   document.querySelector("#water_yang").style.height = (waterYangCurrentValue + 10) + "%";
    //   document.querySelector("#water_yang_range").classList.remove('indicator_selected_kidney')
    // }

  }

  liver8Effect(){
    let containerHeight, woodYangIndicatorHeight, woodYangCurrentValue, fireYinCurrentValue,
      fireYinIndicatorHeight, waterYinCurrentValue, waterYinIndicatorHeight,
      waterYangIndicatorHeight, fireInEarthYinIndicatorHeight, fireInEarthYinCurrentValue,
      metalYangIndicatorHeight, waterYangCurrentValue, metalYangCurrentValue,
      fireYangIndicatorHeight, fireYangCurrentValue;

    containerHeight = getComputedStyle(document.querySelector(".indicator_wrapper")).height;

    woodYangIndicatorHeight = getComputedStyle(document.querySelector("#wood_yang")).height;
    woodYangCurrentValue = parseInt(woodYangIndicatorHeight)/parseInt(containerHeight)*100;

    fireYinIndicatorHeight = getComputedStyle(document.querySelector("#fire_yin")).height;
    fireYinCurrentValue = parseInt(fireYinIndicatorHeight)/parseInt(containerHeight)*100;

    fireInEarthYinIndicatorHeight = getComputedStyle(document.querySelector("#fire_in_earth_yin")).height;
    fireInEarthYinCurrentValue = parseInt(fireInEarthYinIndicatorHeight)/parseInt(containerHeight)*100;

    metalYangIndicatorHeight = getComputedStyle(document.querySelector("#metal_yang")).height;
    metalYangCurrentValue = parseInt(metalYangIndicatorHeight)/parseInt(containerHeight)*100;

    fireYangIndicatorHeight = getComputedStyle(document.querySelector("#fire_yang")).height;
    fireYangCurrentValue = parseInt(fireYangIndicatorHeight)/parseInt(containerHeight)*100;

    waterYinIndicatorHeight = getComputedStyle(document.querySelector("#water_yin")).height;
    waterYinCurrentValue = parseInt(waterYinIndicatorHeight)/parseInt(containerHeight)*100;

    waterYangIndicatorHeight = getComputedStyle(document.querySelector("#water_yang")).height;
    waterYangCurrentValue = parseInt(waterYangIndicatorHeight)/parseInt(containerHeight)*100;


    let changedIndicatorsLiver8 = ["#wood_yang_range", "#fire_yin_range", "#fire_yang_range",
    "#fire_in_earth_yin_range", "#metal_yang_range", "#water_yin_range", "#water_yang_range"];


    if (liver8.checked){
      document.querySelector("#wood_yang").style.height = (woodYangCurrentValue - 10) + "%";
      document.querySelector("#fire_yin").style.height = (fireYinCurrentValue + 10) + "%";
      document.querySelector("#fire_yang").style.height = (fireYangCurrentValue  - 5) + "%";
      document.querySelector("#fire_in_earth_yin").style.height = (fireInEarthYinCurrentValue  + 10) + "%";
      document.querySelector("#metal_yang").style.height = (metalYangCurrentValue  - 10) + "%";
      document.querySelector("#water_yin").style.height = (waterYinCurrentValue + 10) + "%";
      document.querySelector("#water_yang").style.height = (waterYangCurrentValue + 10) + "%";

      for (var element of changedIndicatorsLiver8) {
        document.querySelector(element).classList.add('indicator_selected_liver');
      }
      }
    else  {
      document.querySelector("#wood_yang").style.height = (woodYangCurrentValue + 10) + "%";
      document.querySelector("#fire_yin").style.height = (fireYinCurrentValue - 10) + "%";
      document.querySelector("#fire_yang").style.height = (fireYangCurrentValue + 5) + "%";
      document.querySelector("#fire_in_earth_yin").style.height = (fireInEarthYinCurrentValue  - 10) + "%";
      document.querySelector("#metal_yang").style.height = (metalYangCurrentValue  + 10) + "%";
      document.querySelector("#water_yin").style.height = (waterYinCurrentValue - 10) + "%";
      document.querySelector("#water_yang").style.height = (waterYangCurrentValue - 10) + "%";

      for (var element of changedIndicatorsLiver8) {
        document.querySelector(element).classList.remove('indicator_selected_liver');
      }
    }
    // return (
    //   // document.querySelector("#w0").style.height
    //   // document.querySelector("#w1").style.height
    //   // + document.querySelector("#f0").style.height
    //   // + document.querySelector("#wt0").style.height
    //   + console.log('wood_yin= ' + document.querySelector("#wood_yin").style.height)
    //   + console.log('fire_yin= ' + document.querySelector("#f0").style.height)
    //   + console.log('water_yin= ' + document.querySelector("#wt0").style.height)
    //   );
  }

  liver1Effect() {
    let containerHeight, woodYinIndicatorHeight, woodYinCurrentValue, fireYinCurrentValue,
    fireYinIndicatorHeight;
    containerHeight = getComputedStyle(document.querySelector(".indicator_wrapper")).height;

    woodYinIndicatorHeight = getComputedStyle(document.querySelector("#wood_yin")).height;
    woodYinCurrentValue = parseInt(woodYinIndicatorHeight)/parseInt(containerHeight)*100;

    fireYinIndicatorHeight = getComputedStyle(document.querySelector("#fire_yin")).height;
    fireYinCurrentValue = parseInt(fireYinIndicatorHeight)/parseInt(containerHeight)*100;

    let changedIndicatorsLiver1 = ["#wood_yin_range", "#wood_yang_range", "#fire_yin_range", "#fire_yang_range",
    "#fire_in_earth_yin_range", "#metal_yang_range", "#water_yin_range", "#water_yang_range"];
    let liverPoints = [liver8, liver1];


    if (liver1.checked) {
      document.querySelector("#wood_yin").style.height = (woodYinCurrentValue - 5) + "%";
      document.querySelector("#fire_yin").style.height = (fireYinCurrentValue + 5) + "%";

      for (var element of changedIndicatorsLiver1) {
        let energy = document.querySelector(element).querySelector('.indicator').style.height
        if (energy != '50%') {
          document.querySelector(element).classList.add('indicator_selected_liver');
        }
      }

    } else if (liver1.checked == false) {
      document.querySelector("#wood_yin").style.height = (woodYinCurrentValue + 5) + "%";
      document.querySelector("#fire_yin").style.height = (fireYinCurrentValue - 5) + "%";

      for (var element of changedIndicatorsLiver1) {
        let energy = document.querySelector(element).querySelector('.indicator').style.height
        if (energy == '50%') {
          document.querySelector(element).classList.remove('indicator_selected_liver');
        }
      }

    }
    return (
      document.querySelector("#wood_yin").style.height
      + document.querySelector("#fire_yin").style.height
      // + console.log('wood_yin= ' + document.querySelector("#w0").style.height)
      // + console.log('fire_yin= ' + document.querySelector("#f0").style.height)
        );
  }

  colorateEnergies(point, energies) {
    let containerHeight = getComputedStyle(document.querySelector(".indicator_wrapper")).height;


    for (let energy in energies) {
      let percentage = energies[energy]
      let energyIndicatorHeight = getComputedStyle(document.querySelector("#" + energy)).height;
      let energyCurrentValue = parseInt(energyIndicatorHeight)/parseInt(containerHeight)*100;
      if (document.querySelector("#" + point).checked == false) {
        percentage = percentage * -1
      }

      document.querySelector("#" + energy).style.height = (energyCurrentValue + percentage) + "%";
      document.querySelector("#" + energy + "_range").classList.toggle(point + "_selected")
    }
  }

  lung9Effect() {
    let energies = {
      wood_yang: -5,
      fire_yin: 10,
      fire_yang:  -10,
      earth_yin: 10,
      metal_yang: -5,
      water_yin: 10,
      water_yang: -5
    }

    this.colorateEnergies('lung9', energies)
  }

  kidney7Effect() {
    let energies = {
      wood_yin: 10,
      wood_yang: 10,
      fire_in_earth_yang: 10,
      earth_yang: -10,
      metal_yang: -10,
      water_yang: -10
    }

    this.colorateEnergies('kidney7', energies)
  }

  kidney10Effect() {
    let energies = {
      wood_yin: 10,
      wood_yang: 10,
      fire_in_earth_yang: 10,
      earth_yang: -10,
      metal_yang: -10,
      water_yang: -10,
      water_yin: 5

    }
    this.colorateEnergies('kidney10', energies)
  }

    // let containerHeight = getComputedStyle(document.querySelector(".indicator_wrapper")).height;

    // let energies = {
    //  wood_yin: 10,
    //  earth_yang: -10
    // }


    // for (let energy in energies) {
    //   console.log energies[energy]

    //   let energyIndicatorHeight = getComputedStyle(document.querySelector("#" + energy)).height;
    //   let energyCurrentValue = parseInt(energyIndicatorHeight)/parseInt(containerHeight)*100;
    //   if (kidney10.checked == false) {
    //     percentage = percentage * -1
    //   }

    //   document.querySelector("#" + energy).style.height = (energyCurrentValue + percentage) + "%";
    //   document.querySelector("#" + energy + "_range").classList.toggle('indicator_selected_kidney')
    // }
    // if (kidney10.checked)
    // for (var element of changedIndicatorsKidney10) {
    // document.querySelector(element).classList.add('indicator_selected_kidney');
    // }
    // else if (kidney10.checked == false)
    // for (var element of changedIndicatorsKidney10) {
    //   document.querySelector(element).classList.remove('indicator_selected_kidney');
    // };

// if (kidney10.checked) {


//   document.querySelector("#wood_yang").style.height = (woodYangCurrentValue + 10) + "%";
//   document.querySelector("#fire_in_earth_yin").style.height = (fireInEarthYangCurrentValue + 10) + "%";
//   document.querySelector("#earth_yang").style.height = (earthYangCurrentValue - 10) + "%";
//   document.querySelector("#metal_yang").style.height = (metalYangCurrentValue  - 10) + "%";
//   document.querySelector("#water_yin").style.height = (waterYinCurrentValue  + 5 ) + "%";
//   document.querySelector("#water_yang").style.height = (waterYangCurrentValue  - 10) + "%";
// }  else {
//   document.querySelector("#wood_yin").style.height = (woodYinCurrentValue - 10) + "%";
//   document.querySelector("#wood_yang").style.height = (woodYangCurrentValue - 10) + "%";
//   document.querySelector("#fire_in_earth_yin").style.height = (fireInEarthYangCurrentValue - 10) + "%";
//   document.querySelector("#earth_yang").style.height = (earthYangCurrentValue + 10) + "%";
//   document.querySelector("#metal_yang").style.height = (metalYangCurrentValue  + 10) + "%";
//   document.querySelector("#water_yin").style.height = (waterYinCurrentValue  - 5 ) + "%";
//   document.querySelector("#water_yang").style.height = (waterYangCurrentValue + 10) + "%";
// }
  // return (
  //   document.querySelector("#wood_yin").style.height
  //   + document.querySelector("#fire_yin").style.height
  //   // + console.log('water_yin= ' + document.querySelector("#wt0").style.height)
  //     // + console.log('wood_yin= ' + document.querySelector("#wood_yin").style.height)
  //     // + console.log('fire_yin= ' + document.querySelector("#f0").style.height)
  //       );


  // kidney7Effect() {
  //   let containerHeight, woodYinIndicatorHeight, woodYinCurrentValue, fireYinCurrentValue,
  //   fireYinIndicatorHeight, waterYinCurrentValue, waterYinIndicatorHeight;
  //   containerHeight = getComputedStyle(document.querySelector(".indicator_wrapper")).height;

  //   waterYinIndicatorHeight = getComputedStyle(document.querySelector("#water_yin")).height;
  //   waterYinCurrentValue = parseInt(waterYinIndicatorHeight)/parseInt(containerHeight)*100;

  //   woodYinIndicatorHeight = getComputedStyle(document.querySelector("#wood_yin")).height;
  //   woodYinCurrentValue = parseInt(woodYinIndicatorHeight)/parseInt(containerHeight)*100;

  //   fireYinIndicatorHeight = getComputedStyle(document.querySelector("#fire_yin")).height;
  //   fireYinCurrentValue = parseInt(fireYinIndicatorHeight)/parseInt(containerHeight)*100;



  //   if (kidney7.checked) {
  //     document.querySelector("#water_yin").style.height = (waterYinCurrentValue - 10) + "%";
  //     document.querySelector("#wood_yin").style.height = (woodYinCurrentValue + 10) + "%";
  //     document.querySelector("#fire_yin").style.height = (fireYinCurrentValue - 5) + "%";
  //   } else {
  //     document.querySelector("#water_yin").style.height = (waterYinCurrentValue + 10) + "%";
  //     document.querySelector("#wood_yin").style.height = (woodYinCurrentValue - 10) + "%";
  //     document.querySelector("#fire_yin").style.height = (fireYinCurrentValue + 5) + "%";
  //   }
  //   return (
  //     document.querySelector("#wood_yin").style.height
  //     + document.querySelector("#fire_yin").style.height
  //     // + console.log('water_yin= ' + document.querySelector("#wt0").style.height)
  //     // + console.log('wood_yin= ' + document.querySelector("#woodYin").style.height)
  //     // + console.log('fire_yin= ' + document.querySelector("#f0").style.height)
  //       );
  // }

};



