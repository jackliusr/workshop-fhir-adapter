/// 
Class Adapter.BP.ProcessFHIR Extends Ens.BusinessProcessBPL
{

Storage Default
{
<Type>%Storage.Persistent</Type>
}

XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='HS.FHIRServer.Interop.Request' response='HS.FHIRServer.Interop.Response' height='2000' width='2000' >
<context>
<property name='FHIRObject' type='Adapter.Message.FHIRResponse' instantiate='1' />
<property name='PatientResponse' type='HS.FHIR.DTL.vR4.Model.Resource.Patient' instantiate='1' />
<property name='JSONPayloadStream' type='%Stream.GlobalCharacter' instantiate='1' />
<property name='OrganizationResponse' type='HS.FHIR.DTL.vR4.Model.Resource.Organization' instantiate='1' />
<property name='BundleResponse' type='HS.FHIR.DTL.vR4.Model.Resource.Bundle' instantiate='1' />
<property name='k1' type='%Integer' instantiate='0' />
<property name='temporalDO' type='%Library.DynamicObject' instantiate='0' />
<property name='OrganizationEntry' type='HS.FHIR.DTL.vR4.Model.Element.Bundle.entry' instantiate='1' />
<property name='PatientEntry' type='HS.FHIR.DTL.vR4.Model.Element.Bundle.entry' instantiate='1' />
</context>
<sequence xend='200' yend='1000' >
<call name='Manage FHIR object' target='FromAdapterToHIS' async='0' xpos='200' ypos='250' >
<request type='HS.FHIRServer.Interop.Request' >
<assign property="callrequest" value="request" action="set" />
</request>
<response type='Adapter.Message.FHIRResponse' >
<assign property="context.FHIRObject" value="callresponse" action="set" />
</response>
</call>
<if name='Check if Bundle' condition='context.FHIRObject.Resource.Size &gt; 1' xpos='200' ypos='350' xend='200' yend='800' >
<true>
<code name='Instantiate Bundle' xpos='470' ypos='500' >
<![CDATA[ set context.BundleResponse = ##class(HS.FHIR.DTL.vR4.Model.Resource.Bundle).%New()]]>
</code>
<foreach name='Bundle loop' property='context.FHIRObject.Resource' key='context.k1' xpos='470' ypos='600' xend='200' yend='1000' >
<assign name="Create Dynamic Object" property="context.temporalDO" value="##class(%DynamicAbstractObject).%FromJSON(context.FHIRObject.Resource.GetAt(context.k1))" action="set" xpos='200' ypos='250' />
<switch xpos='200' ypos='350' xend='200' yend='800' >
<case condition='context.temporalDO.type = "Patient"' name='Patient' >
<transform name='Tranform patient' class='Adapter.DT.PatientToFHIR' source='context.temporalDO' target='context.PatientResponse' xpos='335' ypos='500' />
<transform name='Create entry' class='Adapter.DT.PatientToEntry' source='context.PatientResponse' target='context.PatientEntry' xpos='335' ypos='600' />
<transform name='Entry to bundle' class='Adapter.DT.EntryToBundle' source='context.PatientEntry' target='context.BundleResponse' xpos='335' ypos='700' />
</case>
<case condition='context.temporalDO.type = "Organization"' name='Organization' >
<transform name='Transform organization' class='Adapter.DT.OrganizationToFHIR' source='context.temporalDO' target='context.OrganizationResponse' xpos='605' ypos='500' />
<transform name='Create entry' class='Adapter.DT.OrganizationToEntryFHIR' source='context.OrganizationResponse' target='context.OrganizationEntry' xpos='605' ypos='600' />
<transform name='Entry to bundle' class='Adapter.DT.EntryToBundle' source='context.OrganizationEntry' target='context.BundleResponse' xpos='605' ypos='700' />
</case>
<default name='default' />
</switch>
<trace value='"Paso por aqui"' xpos='200' ypos='900' />
</foreach>
<assign name="Assign resource to Stream" property="context.JSONPayloadStream" value="context.BundleResponse.ToJSON()" action="set" xpos='470' ypos='700' />
</true>
<false>
<assign name="Create Dynamic Object" property="context.temporalDO" value="##class(%DynamicAbstractObject).%FromJSON(context.FHIRObject.Resource.GetAt(1))" action="set" xpos='200' ypos='500' />
<transform name='FHIR transform' class='Adapter.DT.PatientToFHIR' source='context.temporalDO' target='context.PatientResponse' xpos='200' ypos='600' />
<assign name="Assign resource to Stream" property="context.JSONPayloadStream" value="context.PatientResponse.ToJSON()" action="set" xpos='200' ypos='700' />
</false>
</if>
<code name='Transform to QuickStream' xpos='200' ypos='900' >
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

/// BPL Definition

}
