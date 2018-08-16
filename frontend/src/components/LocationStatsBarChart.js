import React, { Component } from 'react';
import { locations, components } from '../globalVars'
import {Bar} from 'react-chartjs-2';



const dataItem = {
  label: '',
  backgroundColor: 'rgba(255,99,132,0.2)',
  borderColor: 'rgba(255,99,132,1)',
  borderWidth: 1,
  hoverBackgroundColor: 'rgba(255,99,132,0.4)',
  hoverBorderColor: 'rgba(255,99,132,1)',
  data: []
}

export default class LocationStatsBarChart extends Component {
  state = {
    data: {
      labels: locations.filter(location => location !== 'assembly room'),
      datasets: components.map(component =>{
        return {...dataItem, label: component, data: Array(locations.length - 1).fill(0)}
      })
    },
    options: {
      responsive: true,
      scales: {
        xAxes: [
          {
            // type: 'bar',
            position: 'bottom',
            scaleLabel: {
              display: true,
              labelString: 'Location'
            },
          }
        ],
        yAxes: [
          {
            // type: 'bar',
            display: true,
            position: 'left',
            scaleLabel: {
              display: true,
              labelString: 'Components Produced per Day'
            }
          }
        ],
      }
    }
  }

  componentDidMount = () => {
    this.fetchData()
  }

  fetchData = () => {
    fetch("http://localhost:3000/location_stats")
      .then(res =>  res.json())
      .then(res => {

        const componentsCompletedPerDay = res.components_completed_per_day
        for(const location in componentsCompletedPerDay) {
          const componentsList = componentsCompletedPerDay[location]
          for(const component in componentsList) {
            const data = this.state.data.datasets.map(dataItem => {
              if(dataItem.label === component) {
                dataItem.data[locations.indexOf(location)] = componentsList[component]
              }
              // console.log(dataItem.data)
              return dataItem

            })


            this.setState({
              data: {
                ...this.state.data,
                datasets: data
              }
            },() => console.log(this.state.data))
          }
        }
      })
  }

  render() {
    // console.log(this.state.data)
    const { data, options } = this.state
    return (
      <div>
        <h2>Components Produced by Location per Day(151)</h2>
        <Bar
          data={data}
          options={options}
        />
      </div>
    )
  }
}
