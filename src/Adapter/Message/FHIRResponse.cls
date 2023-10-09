Class Adapter.Message.FHIRResponse Extends (Ens.Response, %XML.Adaptor)
{

/// Description
Property Resource As list Of %String(MAXLEN = 50000);

Storage Default
{
<Data name="FHIRResponseDefaultData">
<Subscript>"FHIRResponse"</Subscript>
<Value name="1">
<Value>Resource</Value>
</Value>
</Data>
<DefaultData>FHIRResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
