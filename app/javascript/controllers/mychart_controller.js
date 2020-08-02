
import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ "chart"]

  connect() {
    // console.log('mychart');
      var chart = c3.generate({
          bindto: '#chart',
          data: {
            columns: [
              ['data1', 50, 50, 50, 50, 50, 50],
              ['data2', 100, 50, 40, 80, 45, 45]
            ],
            axes: {
              data2: 'y'
            },
            types: {
              data2: 'bar'
            },

          },
          axis: {
            y: {
              label: {
                text: 'Y Label',
                position: 'outer-middle'
              },
              tick: {
                format: d3.format("") // ADD
              }
            },
            y2: {
              show: true,
              label: {
                text: 'Y2 Label',
                position: 'outer-middle'
              }
            }
          }
      });

  }
};


