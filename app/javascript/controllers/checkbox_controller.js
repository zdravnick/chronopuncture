
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "input"  ]

  connect(){
    console.log('checkbox controller');

  }
  otherMethod(){
     console.log(this.inputTargets);
  }
};