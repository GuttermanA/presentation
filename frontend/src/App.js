import React, { Component } from 'react';
import ManufacturingProcessGraph from './components/ManufacturingProcessGraph'
import LocationStatsTable from './components/LocationStatsTable'
import LocationStatsBarChart from './components/LocationStatsBarChart'
import logo from './logo.svg';
import './App.css';

class App extends Component {
  render() {
    return (
      <div className="App">
        {
          // <ManufacturingProcessGraph />
        }

        {
          // <LocationStatsBarChart />
        }

        {
          <LocationStatsTable />
        }

      </div>
    );
  }
}

export default App;
