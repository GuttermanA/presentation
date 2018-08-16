import React, { Component } from 'react';
import { locations, components } from '../globalVars'
import { Table } from 'semantic-ui-react';

export default class LocationStatsTable extends Component {

  state = {
    data: []
  }

  componentDidMount = () => {
    this.fetchData()
  }

  fetchData = () => {
    fetch("http://localhost:3000/location_stats")
      .then(res => res.json())
      .then(data => {
        this.setState({ data })
      })
  }


  render() {
    const { data } = this.state
    // const header = locations.map((location) => <Table.HeaderCell>{location}</Table.HeaderCell>)
    const header = data.length && Object.keys(data[0]).reduce((accum, field) => {
      if (data[0][field] !== null && !Array.isArray(data[0][field])) {
        accum.push(<Table.HeaderCell>{field}</Table.HeaderCell>)
      }
      // console.log(accum)
      return accum

    }, [])
    // console.log(header)
    const rows = data.length && data.map((row, index)=> {
      return (
        <Table.Row>
          <Table.Cell>{row.location}</Table.Cell>
          <Table.Cell>{+row.total_active_time.toFixed(2)}</Table.Cell>
          <Table.Cell>{+row.average_time_to_complete_component.toFixed(2)}</Table.Cell>
          <Table.Cell>{+row.simultaneous_capacity.toFixed(2)}</Table.Cell>
          <Table.Cell>{+row.total_wait_time.toFixed(2)}</Table.Cell>
          <Table.Cell>{+row.average_total_wait_time.toFixed(2)}</Table.Cell>
        </Table.Row>
      )

    })
    return (
      <div>
        <h2>Location Status by Day(151)</h2>
        <Table celled definition>
          <Table.Header>
            <Table.Row>
              {
                header
              }
            </Table.Row>
          </Table.Header>

          <Table.Body>
            {rows}
          </Table.Body>

        </Table>
      </div>

    )
  }
}
