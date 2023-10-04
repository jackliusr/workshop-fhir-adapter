Class Adapter.Message.FHIRResponse Extends %Persistent
{

/// Description
Property Resource As %DynamicObject;

Storage Default
{
<Data name="FHIRResponseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<Data name="Resource">
<Attribute>Resource</Attribute>
<Structure>node</Structure>
<Subscript>"Resource"</Subscript>
</Data>
<DataLocation>^Adapter.Message.FHIRResponseD</DataLocation>
<DefaultData>FHIRResponseDefaultData</DefaultData>
<IdLocation>^Adapter.Message.FHIRResponseD</IdLocation>
<IndexLocation>^Adapter.Message.FHIRResponseI</IndexLocation>
<StreamLocation>^Adapter.Message.FHIRResponseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
