import React, { Component } from 'react';
import {Line} from 'react-chartjs-2';

const data = {
  labels: ['Step 1', 'Step 2', 'Step 3', 'Step 4', 'step 5', 'Step 6', 'Step 7'],
  datasets: []
}

// const options = {
//   // responsive: true,
//   // tooltips: {
//   //   mode: 'label'
//   // },
//   // elements: {
//   //   line: {
//   //     fill: false
//   //   }
//   // },
//   scales: {
//     xAxes: [
//       {
//         display: true,
//         gridLines: {
//           display: false
//         },
//         labels: {
//           show: true
//         }
//       }
//     ],
//     yAxes: [
//       {
//         type: 'linear',
//         display: true,
//         position: 'left',
//         id: 'component-y-axis',
//         labels: {
//           show: true
//         },
//         ticks: {
//           reverse: true,
//           min: 0,
//           max: yMap.length - 1,
//           callback: function(value) {
//             return this.state.yLabels[value];
//           },
//         }
//       }
//     ]
//   }
// };

// const plugins = [{
//     afterDraw: (chartInstance, easing) => {
//         const ctx = chartInstance.chart.ctx;
//         ctx.fillText("This text drawn by a plugin", 100, 100);
//     }
// }];


const line = {
    label: '',
    type:'line',
    data: [],
    fill: false,
    borderColor: '#EC932F',
    backgroundColor: '#EC932F',
    pointBorderColor: '#EC932F',
    pointBackgroundColor: '#EC932F',
    pointHoverBackgroundColor: '#EC932F',
    pointHoverBorderColor: '#EC932F',
    yAxisID: 'component-y-axis'
  }



const xMap = ['Step 1', 'Step 2', 'Step 3', 'Step 4', 'Step 5', 'Step 6', 'Step 7']
const yMap = ["GH9CV_00_03", "TG6IA_00_02", "YBSFJ_00_01", "VUFVH_00_00", "JX3UO_01_01", "5YU1V_01_02", "MRX5B_01_00", "ZZU3X_02_00", "ZAENM_02_01", "HUX1L_02_02", "29MSJ_03_01", "B57X3_03_00", "7EFLP_03_02", "assembly room"]

const mapDataPoint = function(xValue, yValue) {
  return {
    x: xMap.indexOf(xValue),
    y: yMap.indexOf(yValue)
  };
};




export default class ManufacturingProcessGraph extends Component {

  state = {
    data: {
      xLabels: xMap,
      yLabels: yMap,
      datasets: [],
    },
    options: {
      scales: {
        xAxes: [{
                type: 'linear',
                position: 'bottom',
                scaleLabel: {
                  display: true,
                  labelString: 'Manufacturing Step'
                },
                ticks: {
                  min: 0,
                  max: xMap.length - 1,
                  stepSize: 1,
                  callback: function(value) {
                    return xMap[value];
                  },
                },
              }],
        yAxes: [
          {
            // type: 'linear',
            // display: true,
            // position: 'left',
            id: 'component-y-axis',
            // labels: {
            //   show: true
            // },
            scaleLabel: {
              display: true,
              labelString: 'Location'
            },
            ticks: {
              // reverse: true,
              min: 0,
              stepSize: 1,
              max: yMap.length - 1,
              callback: function(value) {
                console.log(value, yMap[value])
                return yMap[value]
              },
            }
          }
        ]
      }
    }
  }

  componentDidMount = () => {
    console.log('fetching')
    this.fetchData()
  }

  fetchData = () => {
    let data = null
    fetch("http://localhost:3000/logs")
      .then(res => res.json())
      // .then(json => console.log(json))
      .then(res => {
        const lines = []
        const yAxis = new Set()
        for(const component in res) {
          yAxis.add(...res[component])
          const newLine = {
            ...line,
            label: component,
            data: res[component].map((location, index) => {
              return mapDataPoint(`Step ${index + 1}`, location)
            }),
          }
          lines.push(newLine)
        }

        this.setState({
          data: {
            ...this.state.data,
            datasets: lines,
          }
        }, () => console.log(this.state))

      })
  }

  render() {
    const { data, options, plugins } = this.state
    return (
      <div>
        <h2>Manufacturing Process by Component</h2>
        {
          <Line
            data={data}
            options={options}
          />
        }

      </div>
    )
  }
}
