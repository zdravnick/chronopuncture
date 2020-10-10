
import { Controller } from "stimulus"

export default class extends Controller {

   connect(){
    // console.log('barChart');

  }
    static targets = ["slider2Container", "input22",  "w0Indicator",  "myRange", "liver8", "liver1", "kidney10", "kidney7", "w0", "indicator", "wood_yin_range", "indicatorWrapper" ]


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
      this.w0Target.style.height = (parseInt(woodYinHeight) + "%" );
      return this.w0Target.style.height
      + console.log('woodYinheight: ' + woodYinHeight)
      + console.log('Мышь: ' + coordMouseY)
      + console.log('Фаза: ' + event.eventPhase)
      + console.log(this.w0Target.style.height);
  }

  kidneyPointsEffect(){
    let kidneyPoints = [kidney10, kidney7];
    for (let point of kidneyPoints){
      if (point.checked){
        console.log('ok');
      };
    }
  }


  liver8Effect(){
    let containerHeight, woodYangIndicatorHeight, woodYangCurrentValue, fireYinCurrentValue,
      fireYinIndicatorHeight, waterYinCurrentValue, waterYinIndicatorHeight,
      waterYangIndicatorHeight, fireInEarthYinIndicatorHeight, fireInEarthYinCurrentValue,
      metalYangIndicatorHeight, waterYangCurrentValue, metalYangCurrentValue,
      fireYangIndicatorHeight, fireYangCurrentValue;

    containerHeight = getComputedStyle(document.querySelector(".indicator_wrapper")).height;

    woodYangIndicatorHeight = getComputedStyle(document.querySelector("#w1")).height;
    woodYangCurrentValue = parseInt(woodYangIndicatorHeight)/parseInt(containerHeight)*100;

    fireYinIndicatorHeight = getComputedStyle(document.querySelector("#f0")).height;
    fireYinCurrentValue = parseInt(fireYinIndicatorHeight)/parseInt(containerHeight)*100;

    fireInEarthYinIndicatorHeight = getComputedStyle(document.querySelector("#fe0")).height;
    fireInEarthYinCurrentValue = parseInt(fireInEarthYinIndicatorHeight)/parseInt(containerHeight)*100;

    metalYangIndicatorHeight = getComputedStyle(document.querySelector("#m1")).height;
    metalYangCurrentValue = parseInt(metalYangIndicatorHeight)/parseInt(containerHeight)*100;

    fireYangIndicatorHeight = getComputedStyle(document.querySelector("#f1")).height;
    fireYangCurrentValue = parseInt(fireYangIndicatorHeight)/parseInt(containerHeight)*100;

    waterYinIndicatorHeight = getComputedStyle(document.querySelector("#wt0")).height;
    waterYinCurrentValue = parseInt(waterYinIndicatorHeight)/parseInt(containerHeight)*100;

    waterYangIndicatorHeight = getComputedStyle(document.querySelector("#wt1")).height;
    waterYangCurrentValue = parseInt(waterYangIndicatorHeight)/parseInt(containerHeight)*100;


    let changedIndicators = ["#wood_yang_range", "#fire_yin_range", "#fire_yang_range",
    "#fire_in_earth_yin_range", "#metal_yang_range", "#water_yin_range", "#water_yang_range"];


    if (liver8.checked){
      document.querySelector("#w1").style.height = (woodYangCurrentValue - 10) + "%";
      document.querySelector("#f0").style.height = (fireYinCurrentValue + 10) + "%";
      document.querySelector("#f1").style.height = (fireYangCurrentValue  - 5) + "%";
      document.querySelector("#fe0").style.height = (fireInEarthYinCurrentValue  + 10) + "%";
      document.querySelector("#m1").style.height = (metalYangCurrentValue  - 10) + "%";
      document.querySelector("#wt0").style.height = (waterYinCurrentValue + 10) + "%";
      document.querySelector("#wt1").style.height = (waterYangCurrentValue + 10) + "%";

      for (var element of changedIndicators) {
        document.querySelector(element).classList.add('indicator_selected');
      }
      }
    else {
      document.querySelector("#w1").style.height = (woodYangCurrentValue + 10) + "%";
      document.querySelector("#f0").style.height = (fireYinCurrentValue - 10) + "%";
      document.querySelector("#f1").style.height = (fireYangCurrentValue + 5) + "%";
      document.querySelector("#fe0").style.height = (fireInEarthYinCurrentValue  - 10) + "%";
      document.querySelector("#m1").style.height = (metalYangCurrentValue  + 10) + "%";
      document.querySelector("#wt0").style.height = (waterYinCurrentValue - 10) + "%";
      document.querySelector("#wt1").style.height = (waterYangCurrentValue - 10) + "%";


      for (var element of changedIndicators) {
        document.querySelector(element).classList.remove('indicator_selected');
      }
    }
    return (
      // document.querySelector("#w0").style.height
      // document.querySelector("#w1").style.height
      // + document.querySelector("#f0").style.height
      // + document.querySelector("#wt0").style.height
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
      // + console.log('wood_yin= ' + document.querySelector("#w0").style.height)
      // + console.log('fire_yin= ' + document.querySelector("#f0").style.height)
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



