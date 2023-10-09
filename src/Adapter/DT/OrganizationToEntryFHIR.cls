Class Adapter.DT.OrganizationToEntryFHIR Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Resource.Organization, HS.FHIR.DTL.vR4.Model.Element.Bundle.entry) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Resource.Organization' targetClass='HS.FHIR.DTL.vR4.Model.Element.Bundle.entry' create='new' language='objectscript' >
<assign value='source' property='target.resource' action='set' />
<assign value='"/organization/"_source.id' property='target.response.location' action='set' />
<assign value='"201"' property='target.response.status' action='set' />
</transform>
}

}
