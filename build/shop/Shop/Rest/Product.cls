Class Shop.Rest.Product Extends %Base
{

// REST経由で呼び出されるメソッド集

ClassMethod createRecord() As %Status
{
	set status = $$$OK
	
	try {
		
	  if $data(%request) {
	    set len = 1000
		set json = %request.Content.Read(.len,.status)
	  }
	  
	  set status = ##class(Shop.Product).createRecord(json)
	
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
		set json = %request.Content.Read(.len,.status)
	  }
	  
	  set status = ##class(Shop.Product).modifyRecord(json)
	
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
	    set %response.CharSet = %request.CharSet
	  }
	  
	  set status = ##class(Shop.Product).listRecords()
	  
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
	    set %response.CharSet = %request.CharSet
	  }
	  
	  set status = ##class(Shop.Product).getRecord(pCode)
	  	  
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
	    set %response.CharSet = %request.CharSet
	  }
	
	  set status = ##class(Shop.Product).deleteRecord(pCode)
	  
	}
	catch e {
		
		set status = e.AsStatus()
	}
	    	
	Quit status
}

}
