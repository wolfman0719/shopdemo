import React from 'react';
import axios from "axios";
import { useEffect, useState } from "react";
import { useWindowSize } from "../hooks/useWindowSize";
import configinfo from '../serverconfig.json';

export const TopicList = (props: any) => {

const {keyword} = props;

const [topicList, setTopicList] = useState<any>([]);
const [isLoading, setIsLoading] = useState(false);
const [isError, setIsError] = useState(false);
const [errortext, setErrorText] = useState<any>("");

const ServerAddress = configinfo.ServerAddress;
const ServerPort = configinfo.ServerPort;
const Username = configinfo.Username;
const Password = configinfo.Password;
const ApplicationName = configinfo.ApplicationName;

const [width] = useWindowSize();

 
 useEffect( () => {

    if (keyword !== null && keyword !== "") {

	  setIsLoading(true);
      setIsError(false);
      
	  axios
	    .get<any>(`http://${ServerAddress}:${ServerPort}${ApplicationName}/Search/${keyword}?IRISUsername=${Username}&IRISPassword=${Password}`)
	    .then((result: any) => {
	    const topics = result.data.map((topic: any) => ({
		  id: topic.id,
		  title: topic.title,
		  url: topic.url
        }));
        setTopicList(topics);
	    })
        .catch((error: any) => {
          setIsError(true)
          console.dir(error);
	    })
	    // eslint-disable-next-line react-hooks/exhaustive-deps
        .finally(() => setIsLoading(false));}}, [keyword]);   
        
  return (
    <>
	<table style = {{width: "100%"}}><tbody>
	  {isError && <p style={{ color: "red" }}>エラーが発生しました　{`${errortext}`}</p>}
	  {isLoading ? (<p>Data Loading</p>)
		 : (
		 topicList.map((topic: any) => (
		 
		 <tr style = {{width: "100%"}}><a href={topic.url} target="_blank"><button className = "btn btn-outline-primary" style = {{textAlign: "left"}}><td><div style = {{whiteSpace: "nowrap",overflow: "hidden", width: width-40,textOverflow: "ellipsis"}}>{`${topic.title}`}</div></td><td><i className="bi bi-chevron-right float-end"></i></td></button></a></tr>
		 )))
	  }
	</tbody></table>
    </>	
  );	
}
export default TopicList;