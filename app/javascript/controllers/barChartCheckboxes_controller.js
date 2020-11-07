
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

  static targets = ["liver8",  "liver1", "lungCopy1", "lung8", "heart9", "spleen2", "spleen3", "stomach41", "stomach36",
  "smallInt3", "smallInt5", "smallInt8", "heartGuard9", "heartGuard8", "heartGuard7", "tripleHeater1",
  "tripleHeater3", "tripleHeater6", "kidney10", "kidney7", "gallBladder44", "woodYin", "woodYang",
  "fireYin", "fireYang", "earthYin", "earthYang", "metalYin", "metalYang", "waterYin", "waterYang",
  "indicator", "wood_yin_range", "indicatorWrapper" ]

//  кликаем меняем высоту столбиков-"энергий"
//
  IndicatorWrapperRange(){
    let container, containerOffset, containerCoords, box, boxTop, boxBottom, woodYinHeight,
    woodYangHeight, coordMouseY, target, targetHeight;
    this.indicatorWrapperTarget;
    containerOffset = this.indicatorWrapperTarget.offsetHeight;

    coordMouseY = event.pageY - event.currentTarget.offsetTop;;
    target = event.target.dataset.id;
    targetHeight = target + 'Height';
    targetHeight = Math.round((containerOffset-coordMouseY)/containerOffset*100);
    if (target == "woodYang") {
      this.woodYangTarget.style.height = targetHeight + "%" ;
    } else if (target == "woodYin"){
        this.woodYinTarget.style.height = targetHeight + "%" ;
    } else if (target == "fireYin"){
        this.fireYinTarget.style.height = targetHeight + "%" ;
    } else if (target == "fireYang"){
        this.fireYangTarget.style.height = targetHeight + "%" ;
    } else if (target == "earthYin"){
        this.earthYinTarget.style.height = targetHeight + "%" ;
    } else if (target == "earthYang"){
        this.earthYangTarget.style.height = targetHeight + "%" ;
    } else if (target == "metalYin"){
        this.metalYinTarget.style.height = targetHeight + "%" ;
    } else if (target == "metalYang"){
        this.metalYangTarget.style.height = targetHeight + "%" ;
    } else if (target == "waterYin"){
        this.waterYinTarget.style.height = targetHeight + "%" ;
    } else if (target == "waterYang"){
        this.waterYangTarget.style.height = targetHeight + "%" ;
    }
  }

// раскрашиваем изменившиеся при выборе чекбокса-"точки" столбики-"энергии"
//
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
    let point = event.target.dataset.name;
    this.colorateEnergies(point, energies);
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
    let point = event.target.dataset.name;
    this.colorateEnergies(point, energies);
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
    let point = event.target.dataset.name;
    this.colorateEnergies(point, energies);
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
