Class Adapter.Message.PatientSearchRequest Extends (Ens.Request, %JSON.Adaptor)
{

/// Description
Property id As %String;

Storage Default
{
<Data name="PatientSearchRequestDefaultData">
<Subscript>"PatientSearchRequest"</Subscript>
<Value name="1">
<Value>id</Value>
</Value>
</Data>
<DefaultData>PatientSearchRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
