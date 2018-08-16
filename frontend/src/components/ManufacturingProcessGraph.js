import React, { Component } from 'react';
import {Line} from 'react-chartjs-2';
import { locations } from '../globalVars'


const line =  {
  label: '',
  type:'line',
  data: [],
  fill: false,
  borderColor: '',
  backgroundColor: '',
  pointBorderColor: '',
  pointBackgroundColor: '',
  pointHoverBackgroundColor: '',
  pointHoverBorderColor: '',
  // borderColor: '#EC932F',
  // backgroundColor: '#EC932F',
  // pointBorderColor: '#EC932F',
  // pointBackgroundColor: '#EC932F',
  // pointHoverBackgroundColor: '#EC932F',
  // pointHoverBorderColor: '#EC932F',
  yAxisID: 'component-y-axis'
}



// const xMap = ['Step 1', 'Step 2', 'Step 3', 'Step 4', 'Step 5', 'Step 6', 'Step 7']
// const locations = ["GH9CV_00_03", "TG6IA_00_02", "YBSFJ_00_01", "VUFVH_00_00", "JX3UO_01_01", "5YU1V_01_02", "MRX5B_01_00", "ZZU3X_02_00", "ZAENM_02_01", "HUX1L_02_02", "29MSJ_03_01", "B57X3_03_00", "7EFLP_03_02", "assembly room"]

const mapDataPoint = function(xValue, yValue) {
  return {
    x: xValue,
    y: locations.indexOf(yValue)
  };
};

const colors = ['blue', 'green', 'orange', 'red']




export default class ManufacturingProcessGraph extends Component {

  state = {
    data: {
      xLabels: [1, 2, 3, 4, 5],
      yLabels: locations,
      datasets: [],
    },
    options: {
      responsive: true,
      tooltips: {
        mode: 'label'
      },
      elements: {
        line: {
          fill: false
        }
      },
      scales: {
        xAxes: [{
                type: 'linear',
                position: 'bottom',
                scaleLabel: {
                  display: true,
                  labelString: 'Manufacturing Step'
                },
                ticks: {
                  min: 1,
                  max: 5,
                  stepSize: 1,
                  // callback: function(value) {
                  //   return xMap[value];
                  // },
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
              max: locations.length - 1,
              callback: function(value) {
                return locations[value]
              },
            }
          }
        ]
      }
    }
  }

  componentDidMount = () => {
    // console.log('fetching')
    this.fetchData()
  }

  fetchData = () => {
    fetch("http://localhost:3000/manufacturing_process")
      .then(res => res.json())
      // .then(json => console.log(json))
      .then(res => {
        const lines = []
        const yAxis = new Set()
        let counter = 0
        for(const component in res) {
          yAxis.add(...res[component])
          const newLine = {
            ...line,
            borderColor: colors[counter],
            backgroundColor: colors[counter],
            pointBorderColor: colors[counter],
            pointBackgroundColor: colors[counter],
            pointHoverBackgroundColor: colors[counter],
            pointHoverBorderColor: colors[counter],
            label: component,
            data: res[component].map((location, index) => {
              return mapDataPoint(index + 1, location)
            }),
          }
          lines.push(newLine)
          counter++
        }

        this.setState({
          data: {
            ...this.state.data,
            datasets: lines,
          }
        })

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
