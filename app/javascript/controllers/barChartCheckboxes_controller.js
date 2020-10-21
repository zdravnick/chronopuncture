
import { Controller } from "stimulus"

export default class extends Controller {

  connect(){
    // подсветка и блокировка алиасов каждой выбранной точки-чекбокса
    //
    const blockPoints = (function(){
      document.querySelectorAll("input[type=checkbox]").forEach((checkbox) => {
        checkbox.addEventListener(
          'click', (event) => {
            if (event.currentTarget.parentElement.parentElement.classList.contains("similar_points")){
              event.preventDefault();
            } else {
              document.querySelectorAll("."+ event.currentTarget.classList[0] + '_wrapper').forEach((point)  => {
              point.classList.toggle('similar_points');
            })
              event.currentTarget.parentElement.parentElement.classList.toggle("checked_point");
              event.currentTarget.parentElement.parentElement.classList.remove("similar_points");
            }
          }
        );
        })
    })();
  }

  static targets = ["input22",  "w0Indicator",  "myRange", "liver8",
  "liver1", "lung9", "lungCopy", "lung8", "heart9", "spleen2", "spleen3", "stomach41", "stomach36", "smallInt3",
  "smallInt5", "smallInt8", "heartGuard9", "heartGuard8", "heartGuard7", "tripleHeater1",
  "tripleHeater3", "tripleHeater6", "kidney10", "kidney7", "gallBladder44", "woodYin",
  "indicator", "wood_yin_range", "indicatorWrapper" ]

  IndicatorWrapperRange(){
    let container, containerOffset, containerCoords, box, boxTop, boxBottom, woodYinHeight, coordMouseY;
    this.indicatorWrapperTarget;
    containerOffset = this.indicatorWrapperTarget.offsetHeight;

    coordMouseY = event.pageY - event.currentTarget.offsetTop;

    woodYinHeight = Math.round((containerOffset-coordMouseY)/containerOffset*100);
    this.woodYinTarget.style.height = (parseInt(woodYinHeight) + "%" );
    return this.woodYinTarget.style.height
    + console.log('woodYinheight: ' + woodYinHeight)
    + console.log('Мышь: ' + coordMouseY)
    + console.log('Фаза: ' + event.eventPhase)
    + console.log('woodYinTarget: ' + this.woodYinTarget.style.height);
  }
// pointDefininion(pointAttr, energies){
  //   var pointsGroup = document.querySelectorAll("[" + "data-same-name-points =" + pointAttr + "]");
  //   let pointsArray = Array.prototype.slice.call(pointsGroup);
  //   var point =  pointsArray.filter(function(point) {
  //     if (point.checked){
  //       point.setAttribute((pointAttr + '-data-checked'), 'checked');
  //       return  point
  //      + console.log("point= " + point.id);
  //    } else if (point.checked == false){
  //     point.setAttribute((pointAttr + '-data-checked'), 'unchecked');
  //      console.log("unchecked point= " + point.id);
  //    }
  //   })
  // this.colorateEnergies(energies);
  // }

  colorateEnergies(point, energies) {
    let containerHeight = getComputedStyle(document.querySelector(".indicator_wrapper")).height;
    for (let energy in energies) {
      let percentage = energies[energy];
      let energyIndicatorHeight = getComputedStyle(document.querySelector("#" + energy)).height;
      let energyCurrentValue = parseInt(energyIndicatorHeight)/parseInt(containerHeight)*100;
      if (document.querySelector("#" + point).checked == false){
        percentage = percentage * -1
      }
    document.querySelector("#" + energy).style.height = (energyCurrentValue + percentage) + "%";
    document.querySelector("#" + energy + "_range").classList.toggle(point + "_selected");
    }
  }

  lung9Effect() {
     let energies = {
        wood_yin: -10,
        fire_yin: 10,
        fire_yang:  -10,
        earth_yin: 10,
        metal_yang: -5,
        water_yin: 10,
        water_yang: -5
      }
    if (event.target.dataset.name == "lung9"){
      this.colorateEnergies('lung9', energies);
    } else if (event.target.dataset.name == "lung9Copy1"){
        this.colorateEnergies('lung9Copy1', energies);
    } else if (event.target.dataset.name == "lung9Copy2"){
      this.colorateEnergies('lung9Copy2', energies);
    }
    console.log("точка: " + event.target.dataset.name)
  }

  lung8Effect() {
    let energies = {
      wood_yin: -10,
      fire_yin: 10,
      fire_yang:  -10,
      earth_yin: 10,
      metal_yin: 10,
      metal_yang: -5,
      water_yin: 10,
      water_yang: -5
    }
    this.colorateEnergies('lung8', energies);
  }

  liver8Effect() {

    let energies = {
      wood_yang: -10,
      fire_yin: 10,
      fire_yang: -10,
      fire_in_earth_yin: 10,
      earth_yin: 10,
      metal_yang: -10,
      water_yang: 10
    }
    this.colorateEnergies('liver8', energies);
  }

  liver1Effect() {
    let energies = {
      wood_yin: 10,
      wood_yang: -10,
      fire_yin: -10,
      fire_in_earth_yin: 10,
      earth_yin: 10,
      metal_yang: -10,
      water_yin: 10,
      water_yang: 10
    }
    this.colorateEnergies('liver1', energies);
  }

  gallBladder44Effect() {
    let energies = {
      wood_yin: -10,
      metal_yin: 10,
      metal_yang: 10,
      fire_yin: -10,
      fire_yang: 10,
      earth_yin: -10,
      fire_in_earth_yin: -10,
      fire_in_earth_yang: 10
    }
    this.colorateEnergies('gallBladder44', energies);
  }

  stomach41Effect() {
    let energies = {
      metal_yang: 10,
      fire_yin: 10,
      fire_in_earth_yin: -5,
      water_yin: 5,
      water_yang: 10
    }
    this.colorateEnergies('stomach41', energies);
  }

  stomach36Effect() {
    let energies = {
      earth_yang: 10,
      metal_yang: 10,
      fire_yin: 10,
      fire_in_earth_yin: -5,
      water_yin: 5,
      water_yang: 10
    }
    this.colorateEnergies('stomach36', energies);
  }

  spleen2Effect() {
   let energies = {
    wood_yin: 10,
    wood_yang: -10,
    metal_yin: 10,
    fire_in_earth_yin: 10,
    fire_in_earth_yang: -10,
    fire_yang: 10,
    earth_yang: 5
    }
    this.colorateEnergies('spleen2', energies);
  }

  spleen3Effect() {
   let energies = {
    wood_yang: -10,
    metal_yin: 10,
    fire_in_earth_yin: 10,
    fire_in_earth_yang: -10,
    fire_yang: 10,
    earth_yin: 10,
    earth_yang: 5
  }
  this.colorateEnergies('spleen3', energies);
  }



 heart9Effect() {
   let energies = {
    wood_yin: 10,
    wood_yang: -10,
    earth_yin: 10,
    earth_yang: 5,
    fire_yang: 10,
    fire_in_earth_yin: 10,
    water_yang: -10
  }
  this.colorateEnergies('heart9', energies)
  }

  smallInt3Effect() {
   let energies = {
    earth_yin: -10,
    earth_yang: 10
    }
    this.colorateEnergies('smallInt3', energies);
  }

  smallInt5Effect() {
   let energies = {
    wood_yin: -5,
    earth_yin: -10,
    earth_yang: 10,
    water_yin: 10,
    water_yang: 10
    }
    this.colorateEnergies('smallInt5', energies);
  }

  smallInt8Effect() {
   let energies = {
    wood_yin: -10,
    earth_yin: -10,
    earth_yang: 10,
    water_yin: 10,
    water_yang: 10
    }
    this.colorateEnergies('smallInt8', energies);
  }

  heartGuard9Effect() {
   let energies = {
    earth_yang: -10,
    earth_yin: 10,
    metal_yang: -10
    }
    this.colorateEnergies('heartGuard9', energies);
  }

  heartGuard8Effect() {
   let energies = {
    fire_in_earth_yin: 10,
    earth_yin: 10,
    earth_yang: -10,
    metal_yin: -10,
    metal_yang: -10,
    water_yin: 10,
    water_yang: 10
    }
    this.colorateEnergies('heartGuard8', energies);
  }

  heartGuard7Effect() {
   let energies = {
    earth_yang: -15,
    earth_yin: 10,
    metal_yin: -10,
    fire_in_earth_yin: 10
    }
    this.colorateEnergies('heartGuard7', energies);
  }

  tripleHeater1Effect() {
   let energies = {
    earth_yang: 10,
    earth_yin: -10
    }
    this.colorateEnergies('tripleHeater1', energies);
  }

  tripleHeater3Effect() {
   let energies = {
    earth_yang: 10,
    earth_yin: -10,
    metal_yin: -10
    }
    this.colorateEnergies('tripleHeater3', energies);
  }

  tripleHeater6Effect() {
    let energies = {
      earth_yang: 10,
      earth_yin: -10,
      metal_yin: -10,
      fire_in_earth_yang: 10
      }
    this.colorateEnergies('tripleHeater6', energies);
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
    this.colorateEnergies('kidney7', energies);
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
    this.colorateEnergies('kidney10', energies);
  }

  // end of controller
};
