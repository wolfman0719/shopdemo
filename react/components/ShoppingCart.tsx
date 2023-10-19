import React from 'react';
import axios from "axios";
import { useEffect, useState, useContext } from "react";
import { useNavigate } from 'react-router-dom';
import {ShopContext, shopItem} from "./Shop";


export const ShoppingCart = (props: any) => {

  const {orderItems,setOrderItems} = useContext(ShopContext);
  
  const {customerId} = props;

  const [isLoading, setIsLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [errortext, setErrorText] = useState("");
  const [units, setUnits] = useState("");
  const [totalAmount, setTotalAmount] = useState(0);
  const navigate = useNavigate();

  const orderEntry = (customerId: number,orderItems: any) => {
       
    navigate("/OrderEntry", {state: {shoppingList: orderItems, customerId: customerId}});
  }

  useEffect( () => {
  	
  	let amount: number = 0;
  	orderItems.map((item: any) => (
  	  amount = amount + item.price * item.units
  	))
  	setTotalAmount(amount);

},[orderItems]);   
        
  return (
    <>
	<table style = {{width: "50%"}} className="table table-info table-striped-columns"><tbody>
	<tr className="table table-default"><td>かごの内容</td></tr>
	<tr><td>合計金額</td><td>{new Intl.NumberFormat('ja-JP').format(totalAmount)}</td></tr>
	</tbody></table>
	<table style = {{width: "100%"}} className="table table-info table-striped-columns"><tbody>	
	<tr className="table table-default"><td>注文明細</td></tr>
	<tr className="table table-primary"><td>商品名</td><td>数量</td><td>小計</td></tr>
		 { orderItems.map((item: any, index: number) => (
		 <tr key={index}><td>{item.productName}</td><td> {item.units}</td><td> {new Intl.NumberFormat('ja-JP').format(item.price*item.units)}</td></tr>
		 )) }
	<tr className="table table-default"><td><button onClick={() => orderEntry(customerId, orderItems)}>注文</button></td></tr>
	</tbody></table>
    </>	
  );	
}
export default ShoppingCart;