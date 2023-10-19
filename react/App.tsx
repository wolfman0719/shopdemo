import React from 'react';
import Login from './components/Login';
import Shop from './components/Shop';
import OrderEntry from './components/OrderEntry';
import { BrowserRouter, Routes, Route } from 'react-router-dom';

export const App = () => {
 
  return (
    <BrowserRouter>
	<Routes>
	  <Route path='/' element={<Login />} />
	  <Route path='/Shop' element={<Shop />} />
	  <Route path='/OrderEntry' element={<OrderEntry />} />
	</Routes>
   </BrowserRouter>   
  );	
}
export default App;
