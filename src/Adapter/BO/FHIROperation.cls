Class Adapter.BO.FHIROperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method ManageFHIR(requestData As HS.FHIRServer.Interop.Request, response As Adapter.Message.FHIRResponse) As %Status
{
  set sc = $$$OK

  if (requestData.Request.RequestPath = "Bundle")
  {
    $$$TRACE("TBD")
  }
  elseif (requestData.Request.RequestPath [ "Patient")
  {
    if (requestData.Request.RequestMethod = "POST")
    {
      set sc = ..InsertPatient(requestData, .response)
    }
    elseif (requestData.Request.RequestMethod = "GET")
    {
      set patientId = $Piece(requestData.Request.RequestPath,"/",2)
      set sc = ..GetPatient(patientId, .response)
    }

  }

  Return sc
}

Method GetPatient(patientId As %String, Output patient As Adapter.Message.FHIRResponse) As %Status
{
  Set tSC = $$$OK

  set sql="SELECT id, name, lastname, phone, address, city, email, nhc, postal_code, birth_date, dni, gender FROM his.patient WHERE id = ?"

  //perform the Select
  set tSC = ..Adapter.ExecuteQuery(.resultSet, sql, patientId)
  
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
  set patient = ##class(Adapter.Message.FHIRResponse).%New()
  set patient.Resource = personResult
 
	Return tSC
}

Method InsertPatient(patientData As HS.FHIRServer.Interop.Request, Output patient As Adapter.Message.FHIRResponse) As %Status
{
  Set tSC = $$$OK

  If patientData.QuickStreamId '= "" {
			Set quickStreamIn = ##class(HS.SDA3.QuickStream).%OpenId(patientData.QuickStreamId,, .tSC)
			
      set dynamicPatient = ##class(%DynamicAbstractObject).%FromJSON(quickStreamIn)
		
      kill pResp
      set pResp=$$$NULLOREF

      set sqlInsert="INSERT INTO his.patient (name, lastname, phone, address, city, email, nhc, postal_code, birth_date, dni, gender) values (?,?,?,?,?,?,?,?,?,?,?)"
      //perform the Insert
      set tSC = ..Adapter.ExecuteUpdate(.nrows, sqlInsert, dynamicPatient.%Get("name").%Get(0).%Get("given").%Get(0), dynamicPatient.%Get("name").%Get(0).%Get("family"), dynamicPatient.%Get("telecom").%Get(0).value, 
        dynamicPatient.%Get("address").%Get(0).%Get("line").%Get(0), dynamicPatient.%Get("address").%Get(0).%Get("city"), dynamicPatient.%Get("telecom").%Get(1).value, dynamicPatient.%Get("identifier").%Get(1).value, 
        dynamicPatient.%Get("address").%Get(0).%Get("postalCode"), dynamicPatient.%Get("birthDate"), dynamicPatient.%Get("identifier").%Get(2).value, dynamicPatient.%Get("gender"))

      set sql="SELECT id, name, lastname, phone, address, city, email, nhc, postal_code, birth_date, dni, gender FROM his.patient WHERE nhc = ?"

      //perform the Select
      set tSC = ..Adapter.ExecuteQuery(.resultSet, sql, dynamicPatient.%Get("identifier").%Get(1).value)
      
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
      set patient = ##class(Adapter.Message.FHIRResponse).%New()
      set patient.Resource = personResult
    
    }
	
	Return tSC
}

XData MessageMap
{
<MapItems>
  <MapItem MessageType="HS.FHIRServer.Interop.Request">
    <Method>ManageFHIR</Method>
  </MapItem>
</MapItems>
}

}
