import React, { Component } from 'react';
import { locations, components } from '../globalVars'
import { Icon, Label, Menu, Table } from 'semantic-ui-react';

export default class LocationStatsTable extends Component {

  state = {

  }


  render() {

    const header = locations.map((location) => <Table.HeaderCell>{location}</Table.HeaderCell>)
    const rows = components.map((component, index)=> {
      return (
        <Table.Row>
          <Table.Cell>{component.location}</Table.Cell>
          <Table.Cell></Table.Cell>
          <Table.Cell>Cell</Table.Cell>
        </Table.Row>
      )

    })
    return (
      <Table celled definition>
        <Table.Header>
          <Table.Row>
            <Table.HeaderCell />
            {header}
          </Table.Row>
        </Table.Header>

        <Table.Body>
          <Table.Row>
            <Table.Cell>
              <Label ribbon>First</Label>
            </Table.Cell>
            <Table.Cell>Cell</Table.Cell>
            <Table.Cell>Cell</Table.Cell>
          </Table.Row>
          <Table.Row>
            <Table.Cell>Cell</Table.Cell>
            <Table.Cell>Cell</Table.Cell>
            <Table.Cell>Cell</Table.Cell>
          </Table.Row>
          <Table.Row>
            <Table.Cell>Cell</Table.Cell>
            <Table.Cell>Cell</Table.Cell>
            <Table.Cell>Cell</Table.Cell>
          </Table.Row>
        </Table.Body>

      </Table>
    )
  }
}
