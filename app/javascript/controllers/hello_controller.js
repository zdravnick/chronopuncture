
import { Controller } from "stimulus"


export default class extends Controller {
  switchTheme() {
    var mysite = document.querySelector("body");
    var themeButton = document.querySelector(".themeButton");
    var theme = mysite.classList.toggle('dark-theme');
  };

};







