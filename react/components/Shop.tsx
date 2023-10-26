import React from 'react';
import { createContext, useState, Dispatch,SetStateAction } from "react";
import { Header } from './Header';
import { ShoppingCart } from './ShoppingCart';
import { ProductList } from './ProductList';
import { useLocation } from "react-router-dom"

export type shopItem = {
	    productCode: string;
		productName: string;
		price: number;
		units: number;
  };
  
export const ShopContext = createContext({} as {
    orderItems: shopItem[];
    setOrderItems: Dispatch<SetStateAction<shopItem[]>>;
    }
  ); 

export const Shop = () => {

  const [orderItems, setOrderItems] = useState<shopItem[]>([]);
  
  const location = useLocation();
        
  const values={orderItems,setOrderItems};
  
  return (
    <>
    <div className="title">
	<Header customerId = {location.state.customerId} /> 
	</div>
	<ShopContext.Provider value={values}>
    <div className="shoppingcart" style = {{ float: "left",width: "40%",height: "100%",overflow: "auto",border: "solid #000000 1px"}}>	
    <ShoppingCart customerId = {location.state.customerId} />
    </div>
    <div id="productlist" style = {{ width: "60%",height: "100%",overflow: "auto",border: "solid #000000 1px"}}>
    <ProductList />
    </div>
    </ShopContext.Provider>
    </>	
  );	
}
export default Shop;
