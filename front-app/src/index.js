import React from 'react';
import ReactDOM from 'react-dom/client';

import Renewable from './pages/Renewable.js';
import NonRenewable from './pages/NonRenewable.js';
import ElectricNetwork from './pages/ElectricNetwork.js';
import Consumer1 from './pages/Consumer1.js';
import Consumer2 from './pages/Consumer2.js';
import Regulator from './pages/Regulator.js';

import {
  BrowserRouter,
  Routes,
  Route
} from "react-router-dom";

const root = ReactDOM.createRoot(document.getElementById('root'));
root.render(
  <BrowserRouter>
    <Routes>
        <Route path="/renewable" element={<Renewable />} />
        <Route path="/nonrenewable" element={<NonRenewable />} />
        <Route path="/electricnetwork" element={<ElectricNetwork />} />
        <Route path="/consumer1" element={<Consumer1 />} />
        <Route path="/consumer2" element={<Consumer2 />} />
        <Route path="/regulator" element={<Regulator />} />
    </Routes>
  </BrowserRouter>
);

