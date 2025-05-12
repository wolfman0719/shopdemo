Class Shop.IndvCustomer Extends Shop.Customer [ ClassType = persistent, ProcedureBlock ]
{

Property DOB As %Date;

Method determinePrice(listprice As %Integer) As %Integer
{
  // 割引なし
  Quit listprice
}

Storage Default
{
<Data name="IndvCustomerDefaultData">
<Subscript>"IndvCustomer"</Subscript>
<Value name="1">
<Value>DOB</Value>
</Value>
</Data>
<DefaultData>IndvCustomerDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
