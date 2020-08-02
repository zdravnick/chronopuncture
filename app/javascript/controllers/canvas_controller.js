
import { Controller } from "stimulus"

export default class extends Controller {
 static targets = ["output"]

  connect(){
    // console.log('canvas controller');
    // console.log(this.application);
    // console.log(this.outputTarget.style);
    // console.log(this.outputTarget.id);
    this.outputTarget.classList.add("canvas-style");
    // this.huiTarget.style.backgroundColor="green";
    let chart = this.outputTarget;
    let ctx = this.outputTarget.getContext('2d');
    ctx.lineWidth = 2.0;
    ctx.beginPath();
    ctx.moveTo(30, 50);
    ctx.lineTo(30, 460);
    ctx.lineTo(500, 460);
    ctx.stroke();

  }


probe(){
    let chart = this.outputTarget;
    let ctx = this.outputTarget.getContext('2d');
    this.outputTarget.classList.toggle("canvas-style-2");
    let data = [ 10, 53, 39, 54, 21 ];
    ctx.fillStyle = "green";
    for(let i = 0; i < 6; i++) {
    ctx.fillText((5 - i) * 20 + "", 4, i * 80 + 60);
    ctx.beginPath();
    ctx.moveTo(25, i * 80 + 60);
    ctx.lineTo(30, i * 80 + 60);
    ctx.stroke();
}

// Массив с меткам месяцев
let labels = ["wood", "fire", "earth", "metal", "water"];

// Выводим меток
    for(var i=0; i<5; i++) {
        ctx.fillText(labels[i], 50+ i*100, 475);
    }
    for(var i=0; i<data.length; i++) {
    var dp = data[i];
    ctx.fillRect(40 + i*100, 460-dp*5 , 50, dp*5);
    }

  }
};