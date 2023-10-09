Class Adapter.BO.FHIROperation Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Parameter INVOCATION = "Queue";

Method ManageFHIR(requestData As HS.FHIRServer.Interop.Request, response As Adapter.Message.FHIRResponse) As %Status
{
  set sc = $$$OK
  set response = ##class(Adapter.Message.FHIRResponse).%New()

  if (requestData.Request.RequestPath = "Bundle")
  {
    If requestData.QuickStreamId '= "" {
        Set quickStreamIn = ##class(HS.SDA3.QuickStream).%OpenId(requestData.QuickStreamId,, .tSC)
        
        set dynamicBundle = ##class(%DynamicAbstractObject).%FromJSON(quickStreamIn)

        set sc = ..GetBundle(dynamicBundle, .response)
      }
    
  }
  elseif (requestData.Request.RequestPath [ "Patient")
  {
    if (requestData.Request.RequestMethod = "POST")
    {
      If requestData.QuickStreamId '= "" {
        Set quickStreamIn = ##class(HS.SDA3.QuickStream).%OpenId(requestData.QuickStreamId,, .tSC)
        
        set dynamicPatient = ##class(%DynamicAbstractObject).%FromJSON(quickStreamIn)

        set sc = ..InsertPatient(dynamicPatient, .response)
      }      
    }
    elseif (requestData.Request.RequestMethod = "GET")
    {
      set patientId = $Piece(requestData.Request.RequestPath,"/",2)
      set sc = ..GetPatient(patientId, .response)
    }

  }
  Return sc
}

Method GetBundle(dynamicBundle As %DynamicAbstractObject, Output bundle As Adapter.Message.FHIRResponse) As %Status
{
  set sc = $$$OK

  set entryIterator = dynamicBundle.entry.%GetIterator()

  while entryIterator.%GetNext(.key, .value)
  {
    if (value.resource.resourceType = "Patient")
    {
      if (value.request.method = "POST")
      {
        set sc = ..InsertPatient(value.resource, .bundle)
      }
    }
    elseif (value.resource.resourceType = "Organization")
    {
      if (value.request.method = "POST")
      {
        set sc = ..InsertOrganization(value.resource, .bundle)
      }
    }
  }
  
  Return sc
}

Method InsertPatient(dynamicPatient As %DynamicAbstractObject, Output patient As Adapter.Message.FHIRResponse) As %Status
{
  Set tSC = $$$OK

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
        "dni": (resultSet.GetData(11)), "gender": (resultSet.GetData(12)), "type": ("Patient")}
  } else {
    set personResult = {}
  }
  
  //create the response message
  do patient.Resource.Insert(personResult.%ToJSON())
	
	Return tSC
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
        "dni": (resultSet.GetData(11)), "gender": (resultSet.GetData(12)), "type": ("Patient")}

   } else {
     set personResult = {}
   }
  
  //create the response message
  do patient.Resource.Insert(personResult.%ToJSON())
 
	Return tSC
}

Method InsertOrganization(dynamicOrganization As %DynamicAbstractObject, Output organization As Adapter.Message.FHIRResponse) As %Status
{
  Set tSC = $$$OK

  kill pResp
  set pResp=$$$NULLOREF

  set sqlInsert="INSERT INTO his.center (code, name, address, city, postal_code) values (?,?,?,?,?)"
  //perform the Insert
  set tSC = ..Adapter.ExecuteUpdate(.nrows, sqlInsert, dynamicOrganization.%Get("identifier").%Get(0).%Get("value"), dynamicOrganization.%Get("name"), 
    dynamicOrganization.%Get("address").%Get(0).%Get("line").%Get(0), dynamicOrganization.%Get("address").%Get(0).%Get("city"), dynamicOrganization.%Get("address").%Get(0).%Get("postalCode"))

  set sql="SELECT id, code, name, address, city, postal_code FROM his.center WHERE code = ?"

  //perform the Select
  set tSC = ..Adapter.ExecuteQuery(.resultSet, sql, dynamicOrganization.%Get("identifier").%Get(0).%Get("value"))
  
  If resultSet.Next() {
    set organizationResult = {"id":(resultSet.GetData(1)), "code": (resultSet.GetData(2)), 
        "name": (resultSet.GetData(3)), "address": (resultSet.GetData(4)), 
        "city": (resultSet.GetData(5)), "postalCode": (resultSet.GetData(6)), "type": ("Organization")}
  } else {
    set organizationResult = {}
  }
  //create the response message
  do organization.Resource.Insert(organizationResult.%ToJSON())
	Return tSC
}

Method GetOrganization(organizationId As %String, Output organization As Adapter.Message.FHIRResponse) As %Status
{
  Set tSC = $$$OK

  set sql="SELECT id, code, name, address, city, postal_code FROM his.center WHERE id = ?"

  //perform the Select
  set tSC = ..Adapter.ExecuteQuery(.resultSet, sql, organizationId)
  
  If resultSet.Next() {
    set organizationResult = {"id":(resultSet.GetData(1)), "code": (resultSet.GetData(2)), 
        "name": (resultSet.GetData(3)), "address": (resultSet.GetData(4)), 
        "city": (resultSet.GetData(5)), "postalCode": (resultSet.GetData(6)), "type": ("Organization")}
  } else {
    set organizationResult = {}
  }
  
  //create the response message
  do organization.Resource.Insert(organizationResult.%ToJSON())
	
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
