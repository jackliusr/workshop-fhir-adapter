Class Adapter.Message.PatientSearchResponse Extends (Ens.Response, %JSON.Adaptor)
{

/// Description
Property Resource As %DynamicObject;

Storage Default
{
<Data name="Resource">
<Attribute>Resource</Attribute>
<Structure>node</Structure>
<Subscript>"Adapter.Message.PatientSearchResponse.Resource"</Subscript>
</Data>
<Type>%Storage.Persistent</Type>
}

}
