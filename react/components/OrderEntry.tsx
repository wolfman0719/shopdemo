import React from 'react';
import axios from "axios";
import { useEffect, useState } from "react";
import { Link, useLocation } from 'react-router-dom';
import configinfo from '../serverconfig.json';

export const OrderEntry = (props: any) => {

  const location = useLocation();
  const customerId = location.state.customerId;
  const orderItems = location.state.shoppingList;
  
  const [isLoading, setIsLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [errortext, setErrorText] = useState("");
  const [orderDate, setOrderDate] = useState("");
  const [orderNo, setOrderNo] = useState("");
  const [name, setName] = useState("");
  const [address, setAddress] = useState("");
  const [amount, setAmount] = useState(0);
  const [orderItems2, setOrderItems2] = useState<any>([]);

  const serverAddress = configinfo.ServerAddress;
  const serverPort = configinfo.ServerPort;
  const username = configinfo.Username;
  const password = configinfo.Password;
  const applicationName = configinfo.ApplicationName;

  useEffect( () => {

    setIsLoading(true);
    setIsError(false);
    
      const senddata: any =  {};
	  senddata.CustomerId = customerId;
	  senddata.Items = orderItems;
      
	axios
	  .post<any>(`http://${serverAddress}:${serverPort}${applicationName}/addorder?IRISUsername=${username}&IRISPassword=${password}`, senddata)
	  .then((result: any) => {
	  setOrderDate(result.data.orderDate)	
	  setOrderNo(result.data.orderNo)	
	  setName(result.data.name)	
	  setAddress(result.data.address)	
	  setAmount(result.data.amount)	
	  const items = result.data.Items.map((item: any) => ({
	    productCode: item.productCode,
		productName: item.productName,
		price: item.price,
		units: item.units
      }));
      setOrderItems2(items);
	  })
      .catch((error: any) => {
        setIsError(true)
        console.dir(error);
		if (error.response) {			
		  setErrorText(error.response.data.summary);
		}
		else if (error.request) {
		  setErrorText(error.request);
		} 
		else {
		  setErrorText(error.message);
		}
	  })
	  // eslint-disable-next-line react-hooks/exhaustive-deps
      .finally(() => setIsLoading(false));}, []);   
        
  return (
      <>
	  {isLoading ? (<p>Data Loading</p>)
		 : (
		 <>
		 <p>以下の注文を受け付けました</p>
		 <p>ご利用ありがとうございました</p>
		 <table className="table table-info table-striped-columns"><tbody>
		 <tr><td>注文番号</td><td>{orderNo}</td></tr>
		 <tr><td>注文日</td><td>{orderDate}</td></tr>
		 <tr><td>お名前</td><td>{name} 様</td></tr>
		 <tr><td>ご住所</td><td>{address}</td></tr>
		 <tr><td>合計金額</td><td>{new Intl.NumberFormat('ja-JP').format(amount)}</td></tr>
		 </tbody></table>
		 <p>ご注文内容</p>
		 <table className="table table-info table-striped-columns"><tbody>
		 <tr className="table table-primary"><td>注文コード</td><td>品名</td><td>価格</td><td>数量</td></tr>
		 {orderItems2.map((orderItem: any) => (
		 
		 <tr><td>{orderItem.productCode}</td><td>{orderItem.productName}</td><td>{new Intl.NumberFormat('ja-JP').format(orderItem.price)}</td><td>{orderItem.units}</td></tr>
		 ))}</tbody></table><Link to="/">ログインページへ</Link>
		{isError && <p style={{ color: "red" }}>エラーが発生しました　{`${errortext}`}</p>} 
		 </>)}

  </>
  );
}
export default OrderEntry;