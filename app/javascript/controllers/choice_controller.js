
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "name1", "probe" ]

  probe() {
    if (this.name1Target.checked) {
      this.probeTarget.style.heigth=((Math.round(slide_wood_yin.value)-10) + "%" );
      this.probeTarget.textContent =
      `Стало ${this.probeTarget.style.heigth}!`


    } else {
      this.probeTarget.style.heigth=((Math.round(slide_wood_yin.value)) + "%" );
        this.probeTarget.textContent =
      `А теперь: ${this.probeTarget.style.heigth}!, ${this.inputTargets}`


    }
  }
};