
import { Controller } from "stimulus"

export default class extends Controller {

  connect(){
    console.log('hey')
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
}