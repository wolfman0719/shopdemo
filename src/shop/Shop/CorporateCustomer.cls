Class Shop.CorporateCustomer Extends Shop.Customer [ ClassType = persistent, ProcedureBlock ]
{

Parameter EXTENTSIZE = 1;

Property RepName As %String(TRUNCATE = 1);

Method determinePrice(listprice As %Integer) As %Integer
{
  Set price = 0
  // これまでの購入金額に応じて割引
  If ..TotalOrderAmount > 1000 {
    Set price = listprice * 0.8
  } 
  Else {
    Set price = listprice		
  }
  Quit price
}

Storage Default
{
<Data name="CorporateCustomerDefaultData">
<Subscript>"CorporateCustomer"</Subscript>
<Value name="1">
<Value>RepName</Value>
</Value>
</Data>
<DefaultData>CorporateCustomerDefaultData</DefaultData>
<Property name="Location"/>
<Property name="Name"/>
<Property name="Passwd"/>
<Property name="RepName"/>
<Property name="UserName"/>
<Type>%Storage.Persistent</Type>
}

}
