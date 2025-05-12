Class Shop.Service.FileService Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.File.InboundAdapter";

Method OnProcessInput(pInput As %FileCharacterStream, Output pOutput As %RegisteredObject) As %Status
{
  Set request = ##class(Shop.Message.Request.Order).%New()
  while 'pInput.AtEnd {
    Set request.JSONText = pInput.ReadLine()
	  
    $$$LOGINFO("Read Text : " _ request.JSONText)

    // send request to BO
    Set tSC = ..SendRequestSync("Place Order",request,.pOutput)
  }
  Quit tSC
}

}
