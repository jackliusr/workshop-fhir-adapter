Class Adapter.DT.PatientToFHIR Extends Ens.DataTransformDTL [ DependsOn = (Adapter.Message.PatientSearchResponse, HS.FHIR.DTL.vR4.Model.Resource.Patient) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Adapter.Message.FHIRResponse' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Patient' create='new' language='objectscript' >
<assign value='source.Resource.gender' property='target.gender' action='set' />
<assign value='source.Resource.lastname' property='target.name.(1).family' action='set' />
<assign value='source.Resource.name' property='target.name.(1).given.(1)' action='set' />
<assign value='source.Resource.birthDate' property='target.birthDate' action='set' />
<assign value='source.Resource.id' property='target.identifier.(1).value' action='set' />
<assign value='"HIS"' property='target.identifier.(1).assigner' action='set' />
<assign value='source.Resource.nhc' property='target.identifier.(2).value' action='set' />
<assign value='"HOSPITAL"' property='target.identifier.(2).assigner' action='set' />
<assign value='source.Resource.dni' property='target.identifier.(3).value' action='set' />
<assign value='"MI"' property='target.identifier.(3).assigner' action='set' />
<assign value='"ID"' property='target.identifier.(1).type.text' action='set' />
<assign value='"DNI"' property='target.identifier.(3).type.text' action='set' />
<assign value='"NHC"' property='target.identifier.(2).type.text' action='set' />
<assign value='source.Resource.address' property='target.address.(1).line' action='insert' key='"1"' />
<assign value='source.Resource.city' property='target.address.(1).city' action='set' />
<assign value='source.Resource.postalCode' property='target.address.(1).postalCode' action='set' />
<assign value='source.Resource.phone' property='target.telecom.(1).value' action='set' />
<assign value='"phone"' property='target.telecom.(1).system' action='set' />
<assign value='source.Resource.email' property='target.telecom.(2).value' action='set' />
<assign value='"email"' property='target.telecom.(2).system' action='set' />
</transform>
}

}
