Class Shop.Operation.PlaceOrder Extends Ens.BusinessOperation
{

Parameter INVOCATION = "Queue";

Method PlaceOrder(pRequest As Shop.Message.Request.Order, Output pResponse As Ens.StringResponse) As %Status
{
  set status = $$$OK
	
  set status = ##class(Shop.POrder).createRecord(pRequest.JSONText)

  set pResponse = ##class(Ens.StringResponse).%New()
	  
  if status = $$$OK {
    set pResponse.StringValue = pRequest.JSONText_" のデータが追加されました。"
  }
  else {
    set pResponse.StringValue = pRequest.JSONText_" のデータが追加できませんでした。エラー: "_$system.Status.GetErrorText(status)
  }

  Quit status
}

XData MessageMap
{
<MapItems>
<MapItem MessageType="Ens.Request"> 
<Method>PlaceOrder</Method>
</MapItem>
</MapItems>
}

}
