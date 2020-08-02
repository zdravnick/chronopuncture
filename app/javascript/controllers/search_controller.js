
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "result", "black", "output" ]

  connect(){
    // console.log('search controller');
  }

  check1(){
    if (this.blackTargets.checked) {
      this.outputTarget.textContent =
      `А вот: ${this.blackTarget.checked}!`
      } else {
      this.outputTarget.textContent =
      `Ну или: ${this.blackTarget.checked}!`
      }
  }



};