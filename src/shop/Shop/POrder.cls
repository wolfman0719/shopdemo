Class Shop.POrder Extends (%Persistent, %JSON.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

Parameter EXTENTSIZE = 8;

// オーダ番号

Property OrderNumber As %String(TRUNCATE = 1);

// 出荷先

Property ShipTo As Shop.Address;

// 購入日

Property PurchaseDt As %Date;

// 合計価格

Property TotalPrice As %Integer [ Calculated ];

// 明細

Relationship Items As Shop.OrderItem [ Cardinality = children, Inverse = POrder ];

// 顧客

Relationship Customer As Shop.Customer [ Cardinality = one, Inverse = POrders ];

// 処理中フラグ

Property IsProcessing As %Boolean;

Index OrderNumberIdx On OrderNumber [ Unique ];

Index PurchaseDtIndex On PurchaseDt;

Index CustomerIndex On Customer;

// 新規オーダ作成

ClassMethod create(cust As Shop.Customer, shipto As Shop.Address) As Shop.POrder
{
	Set po = ##class(Shop.POrder).%New()
	Set po.Customer = cust
	Set po.ShipTo = shipto
	Set po.IsProcessing = 1
	Quit po
}

// 明細追加

Method addItem(p As Shop.Product, amt As %Integer)
{
	Set item = ##class(Shop.OrderItem).%New()
	Set item.Product = p
	Set item.UnitPrice = ..Customer.determinePrice(p.ListPrice)
	Set item.Amount = amt
	Do ..Items.Insert(item)
}

// オーダ確定

Method place() As %Status
{
	Set ..PurchaseDt = +$horolog
	//Set ..OrderNumber = "O"_$Justify(..getSeqNum(), 9)
	Set ..IsProcessing = 0
	Quit ..%Save()
}

// 連続番号を取得

/// [Previously private]
ClassMethod getSeqNum() As %Integer
{
	Quit $Increment(^Shop.Order)
}

Method %OnBeforeSave(insert As %Boolean) As %Status [ Private, ServerOnly = 1 ]
{
    // body of method here...
	Set ..OrderNumber = "O"_$Justify(..getSeqNum(), 9)
	quit $$$OK
}

ClassMethod createRecord(pInfo As %String, ByRef pId As %Integer) As %Status
{
	set status = $$$OK

	try {
     
	  if $isobject(pInfo) {
	    set tempobj = pInfo
	  }
	  else {
	    set tempobj = ##class(%DynamicAbstractObject).%FromJSON(pInfo)
	  }
      
      set order = ##class(Shop.POrder).%New()
      
      set customerid = tempobj.CustomerId
            
      set cust = ##class(Shop.Customer).%OpenId(customerid,.status)
      
      if status'=$$$OK {
	     write "顧客が存在しない:" 
	     do $System.Status.DisplayError(status)
	     $$$ThrowStatus(status)
	   }
	   
	  set order.ShipTo.City = cust.Location.City
      set order.ShipTo.Street = cust.Location.Street
      set order.ShipTo.PostalCode = cust.Location.PostalCode
      set order.Customer = cust
	   
	   set order.PurchaseDt = $piece($h,",",1)
	   
	   set order.IsProcessing = 0
	   
	   set iter = tempobj.Items.%GetIterator()
	   
	   while iter.%GetNext(.key,.val) {
		   //set line = {}.%FromJSON(val)
		   set productid = val.ProductId
		   if productid = "" set productid = val.productCode
		   set amount = val.Amount
		   if amount = "" set amount = val.units
		   set product = ##class(Shop.Product).%OpenId(productid,.status)
           if status'=$$$OK {
	          write "商品が存在しない:" 
	          do $System.Status.DisplayError(status)
	          $$$ThrowStatus(status)
	       }
	       
	       set itemline = ##class(Shop.OrderItem).%New()
	       
	       set itemline.Product = product
	       set itemline.Amount = amount
	       set itemline.UnitPrice = product.ListPrice
	       set status = order.Items.Insert(itemline)
	   }
	   
	  set status = order.%Save()
      if status'=$$$OK {
	     write "注文エラー:" 
	     do $System.Status.DisplayError(status)
	     $$$ThrowStatus(status)
	   }
	 
	  set pId = order.%Id()

	  }
	  catch e {
		
		set status = e.AsStatus()
	  }
	    	
	Quit status
}

// 合計価格の計算ロジック

Method TotalPriceGet() As %Integer
{
	Set total = 0
	For i=1:1:..Items.Count() {
		Set total =total + ..Items.GetAt(i).Subtotal	
	}
	Quit total
}

Storage Default
{
<Data name="POrderDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrderNumber</Value>
</Value>
<Value name="3">
<Value>PurchseDt</Value>
</Value>
<Value name="4">
<Value>ShipTo</Value>
</Value>
<Value name="5">
<Value>TotalAmount</Value>
</Value>
<Value name="6">
<Value>Customer</Value>
</Value>
<Value name="7">
<Value>PurchaseDt</Value>
</Value>
<Value name="8">
<Value>IsProcessing</Value>
</Value>
</Data>
<DataLocation>^Shop.POrderD</DataLocation>
<DefaultData>POrderDefaultData</DefaultData>
<ExtentSize>8</ExtentSize>
<IdLocation>^Shop.POrderD</IdLocation>
<IndexLocation>^Shop.POrderI</IndexLocation>
<Property name="Customer"/>
<Property name="IsProcessing"/>
<Property name="OrderNumber"/>
<Property name="PurchaseDt"/>
<Property name="ShipTo"/>
<StreamLocation>^Shop.POrderS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
