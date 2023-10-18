Class Shop.Rest.POrder Extends %Base
{

// REST経由で呼び出されるメソッド集

ClassMethod createRecord() As %Status
{
	set status = $$$OK
	
	try {
		
	  if $data(%request) {
	    set len = 1000
        set %response.ContentType="application/json"
	    set %response.CharSet = "utf-8"
		set json = %request.Content.Read(.len,.status)
	  }
	  
	  set status = ##class(Shop.POrder).createRecord(json, .pid)
      if 'status $$$ThrowStatus(status)

	  set result = {}
	  set order = ##class(Shop.POrder).%OpenId(pid)
	  set result.orderDate = $zdate(order.PurchaseDt,8)
	  set result.orderNo = order.OrderNumber
	  set result.name = order.Customer.Name
	  set result.address = order.Customer.Location.PostalCode_" "_order.Customer.Location.City_" "_order.Customer.Location.Street
	  set result.amount = order.TotalPrice
	  set items = []
	  for i=1:1:order.Items.Count() {
	    set item = {}
	    set item.productCode = order.Items.GetAt(i).Product.Code
		set item.productName = order.Items.GetAt(i).Product.Name
		set item.price = order.Items.GetAt(i).Product.ListPrice
		set item.units = order.Items.GetAt(i).Amount
		do items.%Push(item)
	  }

	  set result.Items = items
	
	  do result.%ToJSON()
	}
	catch e {
		
	  set status = e.AsStatus()
	}
	    	
	Quit status
}

ClassMethod modifyRecord(pInfo As %String) As %Status
{
	set status = $$$OK
	
	try {
		
	  if $data(%request) {
	    set len = 1000
        set %response.ContentType="application/json"
	    set %response.CharSet = "utf-8"
		set json = %request.Content.Read(.len,.status)
	  }
	  
	  set status = ##class(Shop.POrder).modifyRecord(json)
	
	}
	catch e {
		
	  set status = e.AsStatus()
	}
	    		    	
	Quit status
}

ClassMethod listRecords() As %String
{
	set status = $$$OK
	
	try {
	
      if $data(%request) {
        set %response.ContentType="application/json"
	    set %response.CharSet = "utf-8"
	  }
	  
	  set status = ##class(Shop.POrder).listRecords()
	  
	}
	catch e {
		
	  set status = e.AsStatus()
	  
	}
	    	
	Quit status
}

ClassMethod getRecord(pCode As %String) As %String
{
	set status = $$$OK
		
	try {
	
      if $data(%request) {
        set %response.ContentType="application/json"
	    set %response.CharSet = "utf-8"
	  }
	  
	  set status = ##class(Shop.POrder).getRecord(pCode)
	  	  
	  }
	  catch e {
		
		set status = e.AsStatus()
		
	  }
	    	
	Quit status
}

ClassMethod deleteRecord(pCode As %String) As %String
{
	set status = $$$OK
		
	try {

	  if $data(%request) {
        set %response.ContentType="application/json"
	    set %response.CharSet = "utf-8"
	  }
	
	  set status = ##class(Shop.POrder).deleteRecord(pCode)
	  
	}
	catch e {
		
		set status = e.AsStatus()
	}
	    	
	Quit status
}

}
