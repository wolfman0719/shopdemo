Class Shop.Product Extends (%Persistent, %JSON.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

Parameter EXTENTSIZE = 4;

Parameter %JSONIGNOREINVALIDFIELD = 1;

// 商品コード

Property Code As %String(TRUNCATE = 1);

Index CodeIdx On Code [ IdKey, PrimaryKey, Unique ];

// 商品名

Property Name As %String(TRUNCATE = 1);

// コメント

Property Description As %String(MAXLEN = 100, TRUNCATE = 1);

// 定価

Property ListPrice As %Integer;

Property Picture As %Stream.GlobalBinary;

// 販売終了フラグ（データは残す）

Property Deleteflg As %Boolean [ InitialExpression = 0 ];

// 画像

Index NameIdx On Name;

// For testing

ClassMethod createTestData(dir As %String)
{
	Set s=##class(%Stream.FileBinary).%New()
	Do s.LinkToFile(dir_"Image1.gif")
	
	Set p=##class(Shop.Product).%New()
	Set p.Code="PC001"
	Set p.Name="ThinkPad"
	Set p.Description="Intelテクノロジを採用。1.2kgのボディにDVDドライブを搭載"
 	Set p.ListPrice=199800
 	Do p.Picture.CopyFrom(s)
	Do p.%Save()
	
	Set s=##class(%Stream.FileBinary).%New()
	Do s.LinkToFile(dir_"Image2.gif")

	Set p=##class(Shop.Product).%New()
	Set p.Code="MNT001"
	Set p.Name="17インチ液晶モニタ"
	Set p.Description="厚さ1.5cmの超薄型液晶モニタ"
	Set p.ListPrice=89800
 	Do p.Picture.CopyFrom(s)
	Do p.%Save()
	
	Quit
}

ClassMethod createTestDataJSON() As %Status
{
	set status = $$$OK
	
	do ..%KillExtent()
	
	set json(1) = {"Code":"PC001","Name":"ノートPC","Description":"Intelテクノロジーを採用　1.2kgのボディにDVDドライブを搭載","ListPrice":199800,"ImageFile":"/intersystems/iris/shop/images/notepc.gif"}
    set json(2) = {"Code":"MOU001","Name":"2ボタンマウス","Description":"普通のマウスです。","ListPrice":2500,"ImageFile":"/intersystems/iris/shop/images/mouse.gif"}
    set json(3) = {"Code":"MNT001","Name":"17インチ液晶モニター","Description":"厚さ1.5cmの薄型モニター","ListPrice":19800,"ImageFile":"/intersystems/iris/shop/images/monitor.gif"}
    set json(4) = {"Code":"TEL001","Name":"電話機","Description":"シンプルかつ大きなボタンで押しやすい電話機","ListPrice":15000,"ImageFile":"/intersystems/iris/shop/images/telephone.gif"}
    
	
	for i = 1:1:4 {
		set status = ..createRecord(json(i))
	}
	
	Quit status
}

ClassMethod modifyTestData() As %Status
{
	set status = $$$OK
	
	set json(1) = {"Code":"PC001","Description":"AMDテクノロジーを採用　1.2kgのボディにDVDドライブを搭載"}
    set json(2) = {"Code":"MOU001","Name":"有線マウス","Description":"普通のマウスです。"}
    set json(3) = {"Code":"MNT001","ListPrice":15800}
    set json(4) = {"Code":"TEL001","ImageFile":"c:\\temp\\notepc.gif"}
    
	
	for i = 1:1:4 {
		set status = ..modifyRecord(json(i))
	}
	
	Quit status
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
	
	  set newrecord = ..%New()
	  
	  //画像情報は外部ファイルを指定し、ストリームオブジェクトを生成
	
	  if tempobj.ImageFile '= "" {
		set picture = ##class(%Stream.FileBinary).%New()
		do picture.LinkToFile(tempobj.ImageFile)
	  }
		
	  set status = newrecord.%JSONImport(pInfo)

      if $data(picture) {
 	    do newrecord.Picture.CopyFrom(picture)
      }
      
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
	  	  
	  set record = ..%OpenId(tempobj.Code)
	
	  //画像情報は外部ファイルを指定し、ストリームオブジェクトを生成
	
	  if tempobj.ImageFile '= "" {
		set picture = ##class(%Stream.FileBinary).%New()
		do picture.LinkToFile(tempobj.ImageFile)
	  }
		
	  set status = record.%JSONImport(pInfo)

      if $data(picture) {
 	    do record.Picture.CopyFrom(picture)
      }

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
	
      set allrecords = "select code,name,description,listprice from shop.product where deleteflg = 0"
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
        set dobj.Code = rset.code
        set dobj.Name = rset.name
        set dobj.Description = rset.description
        set dobj.ListPrice = rset.listprice
        do array.%Push(dobj)
      }
      
      write array.%ToJSON()
      
	  
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
	
      set onerecord = "select code,name,description,listprice from shop.product where code = ?"
      set statement1 = ##class(%SQL.Statement).%New()
      set qstatus = statement1.%Prepare(onerecord)
      if qstatus'=$$$OK {
	    write "%Prepare失敗:" 
	    do $System.Status.DisplayError(qstatus)
	    $$$ThrowStatus(qstatus)
	  }
      set rset = statement1.%Execute(pCode)
      while rset.%Next() {
	    set dobj = {}
        set dobj.Code = rset.code
        set dobj.Name = rset.name
        set dobj.Description = rset.description
        set dobj.ListPrice = rset.listprice
        write dobj.%ToJSON()
      }
      
	  
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
	
      set record = ..%OpenId(pCode)
      set record.Deleteflg = 1
      
	  set status = record.%Save()      
	  
	}
	catch e {
		
		set status = e.AsStatus()
	}
	    	
	Quit status
}

Storage Default
{
<Data name="ProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Picture</Value>
</Value>
<Value name="5">
<Value>Price</Value>
</Value>
<Value name="6">
<Value>ListPrice</Value>
</Value>
<Value name="7">
<Value>Description</Value>
</Value>
<Value name="8">
<Value>Deleteflg</Value>
</Value>
</Data>
<DataLocation>^Shop.ProductD</DataLocation>
<DefaultData>ProductDefaultData</DefaultData>
<ExtentSize>4</ExtentSize>
<IdLocation>^Shop.ProductD</IdLocation>
<IndexLocation>^Shop.ProductI</IndexLocation>
<Property name="Code"/>
<Property name="Description"/>
<Property name="ListPrice"/>
<Property name="Name"/>
<Property name="Picture"/>
<StreamLocation>^Shop.ProductS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
