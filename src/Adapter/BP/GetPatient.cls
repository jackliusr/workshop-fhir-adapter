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
<property name='PatientObject' type='Adapter.Message.PatientSearchResponse' instantiate='1' />
<property name='PatientResponse' type='HS.FHIR.DTL.vR4.Model.Resource.Patient' instantiate='1' />
<property name='JSONPayloadStream' type='%Stream.GlobalCharacter' instantiate='1' />
</context>
<sequence xend='200' yend='850' >
<assign name="Resource Id" property="context.PatientId.id" value="$Piece(request.Request.RequestPath,&quot;/&quot;,2)" action="set" xpos='200' ypos='250' />
<call name='Get patient' target='FromAdapterToHIS' async='0' xpos='204' ypos='371' >
<request type='Adapter.Message.PatientSearchRequest' >
<assign property="callrequest" value="context.PatientId" action="set" />
</request>
<response type='Adapter.Message.PatientSearchResponse' >
<assign property="context.PatientObject" value="callresponse" action="set" />
</response>
</call>
<transform name='FHIR transform' class='Adapter.DT.PatientToFHIR' source='context.PatientObject' target='context.PatientResponse' xpos='200' ypos='550' />
<assign name="Assign resource to Stream" property="context.JSONPayloadStream" value="context.PatientResponse.ToJSON()" action="set" xpos='200' ypos='650' />
<code name='Transform to QuickStream' xpos='200' ypos='750' >
<![CDATA[ set qs=##class(HS.SDA3.QuickStream).%New()
 set response.QuickStreamId = qs.%Id()
 set copyStatus = qs.CopyFrom(context.JSONPayloadStream)
 set response.Response.ResponseFormatCode="JSON"
 set response.Response.Status=200
 set response.ContentType="application/fhir+json"
  ]]>
</code>
</sequence>
</process>
}

}
