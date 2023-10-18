Class Shop.Rest.Customer Extends %Base
{

// REST経由で呼び出されるメソッド集

ClassMethod createRecord() As %Status
{
	set status = $$$OK
	
	try {
		
	  if $data(%request) {
        set %response.ContentType="application/json"
	    set %response.CharSet = "utf-8"
	    set len = 1000
		set json = %request.Content.Read(.len,.status)
	  }
	  
	  set status = ##class(Shop.Customer).createRecord(json)
	
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
        set %response.ContentType="application/json"
	    set %response.CharSet = "utf-8"
	    set len = 1000
		set json = %request.Content.Read(.len,.status)
	  }
	  
	  set status = ##class(Shop.Customer).modifyRecord(json)
	
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
	  
	  set status = ##class(Shop.Customer).listRecords()
	  
	}
	catch e {
		
	  set status = e.AsStatus()
	  
	}
	    	
	Quit status
}

ClassMethod getRecord(pId As %String) As %String
{
	set status = $$$OK
		
	try {
	
      if $data(%request) {
        set %response.ContentType="application/json"
	    set %response.CharSet = "utf-8"
	  }
	  
	  set status = ##class(Shop.Customer).getRecord(pId)
	  	  
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
	
	  set status = ##class(Shop.Customer).deleteRecord(pCode)
	  
	}
	catch e {
		
		set status = e.AsStatus()
	}
	    	
	Quit status
}

ClassMethod checkPassword(pUserId As %String, pPassword) As %Status
{
	set status = $$$OK
	
	try {
		
	  if $data(%request) {
        set %response.ContentType="application/json"
	    set %response.CharSet = "utf-8"
	  }
	  
	  set cust=##class(Shop.Customer).CheckPasswd(pUserId, pPassword)

	  set return = {}

	  if cust = "" {
		set return.authorized = "ng"

	  }
	  else {
		set return.authorized = "ok"
		set return.ID = cust.%Id()
	  }

	  do return.%ToJSON()
	
	}
	catch e {
		
	  set status = e.AsStatus()
	}
	    		    	
	Quit status
}

}
