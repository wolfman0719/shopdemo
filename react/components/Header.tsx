import React from 'react';
import axios from "axios";
import { useState, useEffect } from "react";
import configinfo from '../serverconfig.json';

const serverAddress = configinfo.ServerAddress;
const serverPort = configinfo.ServerPort;
const username = configinfo.Username;
const password = configinfo.Password;
const applicationName = configinfo.ApplicationName;

export const Header = (props: any) => {

  const [customerName, setCustomerName] = useState("");
  const [totalOrderAmount, setTotalOrderAmount] = useState(0);
  
  useEffect( () => {
  
	axios
	  .get<any>(`http://${serverAddress}:${serverPort}${applicationName}/customer/${props.customerId}?IRISUsername=${username}&IRISPassword=${password}`)
	  .then((result: any) => {
      setCustomerName(result.data.Name);
      setTotalOrderAmount(result.data.TotalOrderAmount);
	  })
      .catch((error: any) => {
        console.log('error = %o' ,error);
	  })      
  // eslint-disable-next-line react-hooks/exhaustive-deps    
      }, []);
        
  return (
    <>
    <a href="https://www.intersystems.co.jp" ><img src="https://www.intersystems.com/assets/intersystems-logo.png" alt="InterSystems Corporation" style = {{width: "200",height: "50",border: "0"}}/></a>
	<p className="text-primary fs-1"> オンライン・ショッピング</p>
	<p>{customerName}　様　いつもご利用いただきありがとうございます。</p>
	<div className="col-8"><p>これまでのお買い上げ金額 {new Intl.NumberFormat('ja-JP').format(totalOrderAmount)}円</p></div>
    </>	
  );	
}
export default Header;
