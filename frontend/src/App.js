import React, { Component } from 'react';
import ManufacturingProcessGraph from './components/ManufacturingProcessGraph'
import LocationStatsTable from './components/LocationStatsTable'
import ComponentStatsTable from './components/ComponentStatsTable'
import logo from './logo.svg';
import './App.css';

class App extends Component {
  render() {
    return (
      <div className="App">
        {
          <ManufacturingProcessGraph />
        }

        {
          <ComponentStatsTable />
        }

        {
          <LocationStatsTable />
        }

      </div>
    );
  }
}

export default App;
