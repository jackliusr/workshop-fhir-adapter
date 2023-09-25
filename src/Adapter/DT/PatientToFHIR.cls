Class Adapter.DT.PatientToFHIR Extends Ens.DataTransformDTL [ DependsOn = (Adapter.Message.PatientSearchResponse, HS.FHIR.DTL.vR4.Model.Resource.Patient) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Adapter.Message.PatientSearchResponse' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Patient' create='new' language='objectscript' >
<assign value='source.Resource.gender' property='target.gender' action='set' />
<assign value='source.Resource.lastname' property='target.name.(1).family' action='set' />
<assign value='source.Resource.name' property='target.name.(1).given.(1)' action='set' />
<assign value='source.Resource.birthDate' property='target.birthDate' action='set' />
<assign value='source.Resource.id' property='target.identifier.(1).value' action='set' />
</transform>
}

}
