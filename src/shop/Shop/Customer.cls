Class Shop.Customer Extends (%Persistent, %JSON.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

Parameter EXTENTSIZE = 3;

Parameter %JSONIGNOREINVALIDFIELD = 1;

Property Name As %String(TRUNCATE = 1);

Property UserName As %String(TRUNCATE = 1);

Property Passwd As %String(TRUNCATE = 1);

Property Location As Shop.Address;

Relationship POrders As Shop.POrder [ Cardinality = many, Inverse = Customer ];

Property TotalOrderAmount As %Integer [ Calculated, SqlComputeCode = { Set {TotalOrderAmount}=##class(Shop.Customer).TotalOrderAmount({ID})
}, SqlComputed ];

// 削除フラグ（データは残す）

Property Deleteflg As %Boolean [ InitialExpression = 0 ];

Index CheckPwdIdx On (UserName As Exact, Passwd As Exact);

Index NameIdx On Name;

/// パスワードのチェック
ClassMethod CheckPasswd(user As %String, passwd As %String) As Shop.Customer
{
  quit:$get(user)="" ""

  set statement = ##class(%SQL.Statement).%New()
  set qstatus = statement.%Prepare("SELECT ID FROM Shop.Customer Where UserName = ? AND Passwd = ?")
  set res = statement.%Execute(user,passwd)
	
  quit:'res.%Next() ""
	
  set cid=res.ID
	
  quit ..%OpenId(cid)
}

Method determinePrice(listprice As %Integer) As %Integer
{
  Quit 0
}

// これまでの購入金額を計算

ClassMethod TotalOrderAmount(pId As %Integer) As %Integer
{
  Set Order = ..%OpenId(pId)
  Set total = 0
  For i=1:1:Order.POrders.Count() {
    Set o = Order.POrders.GetAt(i)
		
   // 処理中のオーダを除いて計算する
   If o.IsProcessing = 0 { Set total = total + o.TotalPrice }
  }
  Quit total
}

ClassMethod createTestData()
{
  do ##class(Shop.Customer).%KillExtent()

  // 個人顧客
  Set c=##class(Shop.IndvCustomer).%New()
  Set c.Name="日本 太郎"
  Set c.Location.Street="丸の内"
  Set c.Location.City="東京"
  Set c.Location.PostalCode="100-0001"
  Set c.DOB=$zdh("2/4/2003")
  Set c.UserName="taro"
  Set c.Passwd="taro"
  Do c.%Save()

  // 個人顧客
  Set c=##class(Shop.IndvCustomer).%New()
  Set c.Name="日本 花子"
  Set c.Location.Street="赤坂"
  Set c.Location.City="東京"
  Set c.Location.PostalCode="100-0001"
  Set c.DOB=$zdh("2/4/2001")
  Set c.UserName="hanako"
  Set c.Passwd="hanako"
  Do c.%Save()

  // 法人顧客
  Set c=##class(Shop.CorporateCustomer).%New()
  Set c.Name="インターシステムズジャパン"
  Set c.Location.Street="西新宿"
  Set c.Location.City="東京"
  Set c.Location.PostalCode="160-0023"
  Set c.RepName="速井 一郎"
  Set c.UserName="intersystems"
  Set c.Passwd="intersystems"
  Do c.%Save()
	
  do ##class(Shop.POrder).%KillExtent()
  do ##class(Shop.OrderItem).%KillExtent()
  kill ^Shop.Order
}

ClassMethod createTestDataJSON()
{
  do ##class(Shop.Customer).%KillExtent()

  // 個人顧客
	
  set json(1) = {"Name":"日本 太郎","UserName":"taro","Passwd":"taro","Location":{"Street":"丸の内","City":"東京","PostalCode":"100-0001"},"DOB":"59204"}
  set json(2) = {"Name":"日本 花子","UserName":"hanako","Passwd":"hanako","Location":{"Street":"赤坂","City":"東京","PostalCode":"100-0001"},"DOB":"58474"}
  set json(3) = {"Name":"インターシステムズジャパン","UserName":"intersystems","Passwd":"intersystems","Location":{"Street":"西新宿","City":"東京","PostalCode":"160-0023"},"RepName":"速井 一郎"}

  for i = 1:1:3 {
    set status = ..createRecord(json(i))
  }

	
  do ##class(Shop.POrder).%KillExtent()
  do ##class(Shop.OrderItem).%KillExtent()
  kill ^Shop.Order
}

ClassMethod createRecord(pInfo As %String) As %Status
{
  set status = $$$OK
	
  try {
			
    if $isobject(pInfo) {
      set tempobj = pInfo
    }
    else {
      set tempobj = ##class(%DynamicAbstractObject).%FromJSON(pInfo)
    }
      
    if tempobj.DOB {
      set newrecord = ##class(Shop.IndvCustomer).%New()
    }
    else {
      set newrecord = ##class(Shop.CorporateCustomer).%New()
    }
	  		
    set status = newrecord.%JSONImport(pInfo)

    set status = newrecord.%Save()
	  
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
			
    if $isobject(pInfo) {
      set tempobj = pInfo
    }
    else {
      set tempobj = ##class(%DynamicAbstractObject).%FromJSON(pInfo)
    }

    set id = tempobj.ID 
      
    if tempobj.Type = "Indv" {
      set record = ##class(Shop.IndvCustomer).%OpenId(id)
    }
    elseif tempobj.Type = "Corporate" {
      set record = ##class(Shop.CorporateCustomer).%OpenId(id)
    }
    else {
      set record = ##class(Shop.Customer).%OpenId(id)
    }
	  		
    set status = record.%JSONImport(pInfo)

    set status = record.%Save()
	  
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
	
    set allrecords = "select name,username,totalorderamount,Location_City as city,Location_PostalCode as postalcode,Location_Street as street from shop.customer where deleteflg = 0"
    set statement1 = ##class(%SQL.Statement).%New()
    set qstatus = statement1.%Prepare(allrecords)
    if qstatus'=$$$OK {
      write "%Prepare失敗:" 
      do $System.Status.DisplayError(qstatus)
      $$$ThrowStatus(qstatus)
    }
    set rset = statement1.%Execute()
    set array = []
    while rset.%Next() {
      set dobj = {}
      set dobj.Name = rset.name
      set dobj.UserName = rset.username
      set dobj.TotalOrderAmount = rset.totalorderamount
      set dobj.Location.City = rset.city
      set dobj.Location.PostalCode = rset.postalcode
      set dobj.Location.Street = rset.street
      do array.%Push(dobj)
    }
      
    write array.%ToJSON()
      	  
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
	
    set onerecord = "select name,username,totalorderamount,Location_City as city,Location_PostalCode as postalcode,Location_Street as street from shop.customer where id = ?"
    set statement1 = ##class(%SQL.Statement).%New()
    set qstatus = statement1.%Prepare(onerecord)
    if qstatus'=$$$OK {
      write "%Prepare失敗:" 
      do $System.Status.DisplayError(qstatus)
      $$$ThrowStatus(qstatus)
    }
    set rset = statement1.%Execute(pId)

    while rset.%Next() {
      set dobj = {}
      set dobj.Name = rset.name
      set dobj.UserName = rset.username
      set dobj.TotalOrderAmount = rset.totalorderamount
      set location = {}
      set location.City = rset.city
      set location.PostalCode = rset.postalcode
      set location.Street = rset.street
      set dobj.Location = location
      write dobj.%ToJSON()
    }
      	  
  }
  catch e {
		
    set status = e.AsStatus()
  }
	    	
  Quit status
}

ClassMethod deleteRecord(pId As %String) As %String
{
  set status = $$$OK
		
  try {
	
    set record = ..%OpenId(pId)
    set record.Deleteflg = 1
      
    set status = record.%Save()      
	  
  }
  catch e {
		
    set status = e.AsStatus()
  }
	    	
  Quit status
}

Query ByName(Param1 As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT %ID,Name,UserName FROM Customer
 WHERE (Name %STARTSWITH :Param1)
 ORDER BY %ID
}

Storage Default
{
<Data name="CustomerDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Location</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>TotalOrderAmount</Value>
</Value>
<Value name="5">
<Value>Passwd</Value>
</Value>
<Value name="6">
<Value>UserName</Value>
</Value>
<Value name="7">
<Value>Deleteflg</Value>
</Value>
</Data>
<DataLocation>^Shop.CustomerD</DataLocation>
<DefaultData>CustomerDefaultData</DefaultData>
<ExtentSize>3</ExtentSize>
<IdLocation>^Shop.CustomerD</IdLocation>
<IndexLocation>^Shop.CustomerI</IndexLocation>
<Property name="Location"/>
<Property name="Name"/>
<Property name="Passwd"/>
<Property name="UserName"/>
<StreamLocation>^Shop.CustomerS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
