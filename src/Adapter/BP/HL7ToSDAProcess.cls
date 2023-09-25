Class Adapter.BP.HL7ToSDAProcess Extends Ens.BusinessProcess [ ClassType = persistent, ProcedureBlock ]
{

Method OnRequest(pRequest As EnsLib.HL7.Message, Output pResponse As Ens.Response) As %Status
{
        do ##class(HS.Gateway.HL7.HL7ToSDA3).GetSDA(pRequest,.con)
        set streamContainer = ##class(Ens.StreamContainer).%New()
        set streamContainer.Stream = con
        set sc = ..SendRequestSync("SDAToFHIRProcess", streamContainer, .pResponse)
        Return $$$OK
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
