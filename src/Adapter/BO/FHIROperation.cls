Class Adapter.BO.FHIROperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method GetPatient(patientId As Adapter.Message.PatientSearchRequest, patient As Adapter.Message.PatientSearchResponse) As %Status
{
  Set tSC = $$$OK

  set sql="SELECT id, name, lastname, phone, address, city, email, nhc, postal_code, birth_date, dni, gender FROM his.patient WHERE id = "_ patientId.id

  //perform the Select
  set tSC = ..Adapter.ExecuteQuery(.resultSet, sql)
  
  If resultSet.Next() {
     set personResult = {"id":(resultSet.GetData(1)), "name": (resultSet.GetData(2)), 
        "lastname": (resultSet.GetData(3)), "phone": (resultSet.GetData(4)), 
        "address": (resultSet.GetData(5)), "city": (resultSet.GetData(6)),
        "email": (resultSet.GetData(7)), "nhc": (resultSet.GetData(8)),
        "postalCode": (resultSet.GetData(9)), "birthDate": (resultSet.GetData(10)),
        "dni": (resultSet.GetData(11)), "gender": (resultSet.GetData(12))}
   } else {
     set personResult = {}
   }
  
  //create the response message
  set patient = ##class(Adapter.Message.PatientSearchResponse).%New()
  set patient.Resource = personResult
 
  if 'tSC write " failed ",tSC quit tSC
  quit 1
	
	Return tSC
}

Method InsertPatient(patientData As %Library.DynamicObject, patientId As %String) As %Status
{
  Set tSC = $$$OK
	
  kill pResp
  set pResp=$$$NULLOREF

  set sql="INSERT INTO his.patient (id, name, lastname, phone, address, city, email, nhc, postal_code, birth_date, dni, gender) values (NULL,?,?,?,?,?,?,?,?,?,?,?)"

  //perform the Insert
  set tSC = ..Adapter.ExecuteUpdate(.nrows, sql, patientData.id, patientData.name, patientData.lastname, patientData.phone, 
    patientData.address, patientData.city, patientData.email, patientData.nhc, patientData.postalCode, patientData.birthDate, patientData.dni, patientData.gender)

  //create the response message
  set sql="SELECT MAX(id) FROM his.patient WHERE nhc = ?"
  set tSC = ..Adapter.ExecuteQuery(.resultSet, sql, patientId)
  set personResult = ""
  if (resultSet.%SQLCODE = 0) {
    while (resultSet.%Next() '= 0) {
      set patientId = resultSet.GetData(1)
    }
  }

  if 'tSC write " failed ",tSC quit tSC
  quit 1
	
	Return tSC
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="Adapter.Message.PatientSearchRequest">
    <Method>GetPatient</Method>
  </MapItem>
</MapItems>
}

}
