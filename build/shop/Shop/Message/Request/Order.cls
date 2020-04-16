Class Shop.Message.Request.Order Extends Ens.Request
{

Property JSONText As %String(MAXLEN = 1000);

Storage Default
{
<Data name="OrderDefaultData">
<Subscript>"Order"</Subscript>
<Value name="1">
<Value>JSONText</Value>
</Value>
</Data>
<DefaultData>OrderDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
