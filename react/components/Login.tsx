import { useState } from "react";
import axios from "axios";
import { useNavigate } from 'react-router-dom'

import configinfo from '../serverconfig.json';

const serverAddress = configinfo.ServerAddress;
const serverPort = configinfo.ServerPort;
const username = configinfo.Username;
const password = configinfo.Password;
const applicationName = configinfo.ApplicationName;

const Login = () => {

  const navigate = useNavigate();
  
  const [isLoading, setIsLoading] = useState(false);
  const [isError, setIsError] = useState(false);
  const [errorText, setErrorText] = useState("");
  
  const login = {status: false, customerId: 0};

  const handleSubmit = (event: any) => {
    event.preventDefault();
    const { userid, password } = event.target.elements;
    userLoginCheck(userid.value, password.value).finally(() => 
    {
      if (login.status) {
        navigate("/Shop", { state: { customerId: login.customerId } })
      }
        
    })
  };

   const userLoginCheck =　async (userid: any, userpassword: any) => {
	
    let status = false;
    let customerId = 0;
    
    setIsLoading(true);
	setIsError(false);
	
    await axios
	  .get<any>(`http://${serverAddress}:${serverPort}${applicationName}/checkpassword/${userid}/${userpassword}?IRISUsername=${username}&IRISPassword=${password}`)
	  .then((result: any) => {
	    if (result.data.authorized === 'ok') {
	      login.status = true; 
	      login.customerId = result.data.ID;   
	    }
	    else {
	        setIsError(true);
	        setErrorText('ログインが失敗しました');
	    }
	   })
      .catch((error: any) => {
	     setIsError(true)
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
      .finally(() => setIsLoading(false))
  };

  return (
    <div>
      <h1>ログイン</h1>
      <form onSubmit={handleSubmit}>
      <table>
      <tbody>
      <tr>
      <td><label>利用者ID:</label></td>
      <td><input name="userid" type="text" placeholder="userid" /></td>
      </tr>
      <tr>
      <td><label>パスワード</label></td>
      <td><input name="password" type="password" placeholder="password" /></td>
      </tr>
      <tr><td><button type="submit">ログイン</button></td></tr>
      </tbody>
      </table>
      </form>
	  {isError && <p style={{ color: "red" }}>{`${errorText}`}</p>}
    </div>
  );
};

export default Login;