Class Shop.OrderItem Extends (%Persistent, %JSON.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

Index IndexProduct On Product;

Property Product As Shop.Product;

Property UnitPrice As %Integer;

Property Amount As %String(TRUNCATE = 1);

Property Subtotal As %Integer [ Calculated ];

Relationship POrder As Shop.POrder [ Cardinality = parent, Inverse = Items ];

Method SubtotalGet() As %Integer
{
	Quit ..UnitPrice * ..Amount
}

Storage Default
{
<Data name="OrderItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Amount</Value>
</Value>
<Value name="3">
<Value>Product</Value>
</Value>
<Value name="4">
<Value>UnitPrice</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("Items")</DataLocation>
<DefaultData>OrderItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^Shop.POrderC("Items")</IdLocation>
<IndexLocation>^Shop.OrderItemI</IndexLocation>
<StreamLocation>^Shop.OrderItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
