Class Adapter.DT.OrganizationToFHIR Extends Ens.DataTransformDTL [ DependsOn = (%Library.DynamicObject, HS.FHIR.DTL.vR4.Model.Resource.Organization) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='%Library.DynamicObject' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Organization' create='new' language='objectscript' >
<assign value='source.name' property='target.name' action='set' />
<assign value='source.address' property='target.address.(1).line' action='insert' key='1' />
<assign value='source.city' property='target.address.(1).city' action='set' />
<assign value='source.postalCode' property='target.address.(1).postalCode' action='set' />
<assign value='source.code' property='target.identifier.(1).value' action='set' />
<assign value='"SNS"' property='target.identifier.(1).system' action='set' />
<assign value='source.id' property='target.id' action='set' />
</transform>
}

}
