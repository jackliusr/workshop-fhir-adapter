Class Adapter.DT.EntryToBundle Extends Ens.DataTransformDTL [ DependsOn = (HS.FHIR.DTL.vR4.Model.Element.Bundle.entry, HS.FHIR.DTL.vR4.Model.Resource.Bundle) ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='HS.FHIR.DTL.vR4.Model.Element.Bundle.entry' targetClass='HS.FHIR.DTL.vR4.Model.Resource.Bundle' create='existing' language='objectscript' >
<assign value='source' property='target.entry' action='insert' key='target.entry.Size + 1' />
</transform>
}

}
