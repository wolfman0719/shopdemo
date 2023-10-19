import React from 'react';
import axios from "axios";
import { ChangeEvent, useEffect, useState, useContext } from "react";
import { useWindowSize } from "../hooks/useWindowSize";
import configinfo from '../serverconfig.json';
import {ShopContext, shopItem} from "./Shop";


const tempCart: any = [];

  export const ProductList = (props: any) => {

  const {orderItems,setOrderItems} = useContext(ShopContext);
  const [productsList, setProductsList] = useState<any>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [errortext, setErrorText] = useState("");
  const [units, setUnits] = useState<any>([0,0,0,0,0]);

  const serverAddress = configinfo.ServerAddress;
  const serverPort = configinfo.ServerPort;
  const username = configinfo.Username;
  const password = configinfo.Password;
  const applicationName = configinfo.ApplicationName;

  const [width] = useWindowSize();

  const addShoppingCart = (index: number) => {
    
  	const item: any = {productCode: productsList[index].code,productName: productsList[index].name,price: productsList[index].listPrice,units: units[index].target};
  	
  	tempCart.push(item);
    setOrderItems(tempCart.slice(0, tempCart.length)); 
	
  };

  const unitsUpdate = (event: any, i: number) => {
    setUnits(
      // mapで更新対象オブジェクトのみを変更した新規配列を作成し、stateにセットする
      units.map((val: any, index: number) =>
        index === i ? { ...val, target: event.target.value } : { ...val }
      )
    );
   };
    
  useEffect( () => {

    setIsLoading(true);
    setIsError(false);
      
	axios
	  .get<any>(`http://${serverAddress}:${serverPort}${applicationName}/products?IRISUsername=${username}&IRISPassword=${password}`)
	  .then((result: any) => {
	  const products = result.data.map((product: any) => ({
	    code: product.Code,
		name: product.Name,
		listPrice: product.ListPrice,
		description: product.Description,
		image: product.Image
      }));
      setProductsList(products);
	  })
      .catch((error: any) => {
        setIsError(true)
        console.dir(error);
	  })
	  // eslint-disable-next-line react-hooks/exhaustive-deps
      .finally(() => setIsLoading(false));}, []);   
        
  return (
    <> 
	<table style = {{width: "100%"}} className="table table-info table-striped-columns"><tbody>
	  {isError && <p style={{ color: "red" }}>エラーが発生しました　{`${errortext}`}</p>}
	  {isLoading ? (<p>Data Loading</p>)
		 : (
		 productsList.map((product: any, index: number) => (
		 
		 <tr key={index}><td className="table-light"><img src={`http://${serverAddress}:${serverPort}/csp/user/images/${product.image}`} alt={product.name} /></td><td><div style = {{verticalAlign: "top"}}><p>{product.name}</p></div><div style = {{verticalAlign: "bottom"}}><p>{product.description}</p></div></td><td><div style = {{verticalAlign: "top"}}><p>商品コード:  {product.code}</p></div><div style = {{verticalAlign: "bottom"}}><p>{new Intl.NumberFormat('ja-JP').format(product.listPrice)}円</p></div></td><td><div style = {{verticalAlign: "top"}}><p>注文数</p><input name="units" type="text" onChange={(e) => unitsUpdate(e, index)}/></div><div style = {{verticalAlign: "bottom"}}><button className="btn btn-secondary" onClick={() => addShoppingCart(index)}>カートに入れる</button></div></td></tr>
		 )))
	  }
	</tbody></table>
    </>	
  );	
}
export default ProductList;