import React, { Component } from 'react';
import ManufacturingProcessGraph from './components/ManufacturingProcessGraph'
import logo from './logo.svg';
import './App.css';

class App extends Component {
  render() {
    return (
      <div className="App">
        <ManufacturingProcessGraph />
      </div>
    );
  }
}

export default App;
