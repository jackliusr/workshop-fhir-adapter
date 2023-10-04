/// 
Class Adapter.BP.GetPatient Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='HS.FHIRServer.Interop.Request' response='HS.FHIRServer.Interop.Response' height='2000' width='2000' >
<context>
<property name='PatientId' type='Adapter.Message.PatientSearchRequest' instantiate='1' />
<property name='PatientObject' type='Adapter.Message.FHIRResponse' instantiate='1' />
<property name='PatientResponse' type='HS.FHIR.DTL.vR4.Model.Resource.Patient' instantiate='1' />
<property name='JSONPayloadStream' type='%Stream.GlobalCharacter' instantiate='1' />
</context>
<sequence xend='200' yend='1200' >
<call name='Manage FHIR object' target='FromAdapterToHIS' async='0' xpos='200' ypos='400' >
<request type='HS.FHIRServer.Interop.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Adapter.Message.FHIRResponse' >
<assign property="context.PatientObject" value="callresponse" action="set" />
</response>
</call>
<transform name='FHIR transform' class='Adapter.DT.PatientToFHIR' source='context.PatientObject' target='context.PatientResponse' xpos='200' ypos='800' />
<assign name="Assign resource to Stream" property="context.JSONPayloadStream" value="context.PatientResponse.ToJSON()" action="set" xpos='200' ypos='900' />
<trace value='"Stream assigned"' xpos='200' ypos='1000' />
<code name='Transform to QuickStream' xpos='200' ypos='1100' >
<![CDATA[ set qs=##class(HS.SDA3.QuickStream).%New()
 set response.QuickStreamId = qs.%Id()
 set copyStatus = qs.CopyFrom(context.JSONPayloadStream)
 set response.Response.ResponseFormatCode="JSON"
 set response.Response.Status=200
 set response.ContentType="application/fhir+json"
 set response.CharSet = "utf8"
  ]]>
</code>
</sequence>
</process>
}

}
