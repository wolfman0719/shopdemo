Class Shop.Address Extends (%SerialObject, %JSON.Adaptor) [ ClassType = serial, ProcedureBlock ]
{

Parameter %JSONIGNOREINVALIDFIELD = 1;

Property Street As %String(TRUNCATE = 1);

Property City As %String(TRUNCATE = 1);

Property PostalCode As %String(TRUNCATE = 1);

Storage Default
{
<Data name="AddressState">
<Subscript>"Shop.Address"</Subscript>
<Value name="1">
<Value>City</Value>
</Value>
<Value name="2">
<Value>PostalCode</Value>
</Value>
<Value name="3">
<Value>Street</Value>
</Value>
</Data>
<State>AddressState</State>
<StreamLocation>^Shop.AddressS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
