Class Adapter.Production Extends Ens.Production [ Not ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="Adapter.Production" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="EnsLib.JavaGateway.Service" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Address">jgw</Setting>
    <Setting Target="Host" Name="ClassPath">/jgw/postgresql-42.6.0.jar</Setting>
    <Setting Target="Host" Name="JavaHome">/usr/local/openjdk-8</Setting>
    <Setting Target="Host" Name="Port">44444</Setting>
  </Item>
  <Item Name="InteropService" Category="" ClassName="HS.FHIRServer.Interop.Service" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">ProcessFHIRBP</Setting>
  </Item>
  <Item Name="ProcessFHIRBP" Category="" ClassName="Adapter.BP.ProcessFHIR" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="FromAdapterToHIS" Category="" ClassName="Adapter.BO.FHIROperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Adapter" Name="DSN">jdbc:postgresql://postgres:5432/testuser</Setting>
    <Setting Target="Adapter" Name="JDBCDriver">org.postgresql.Driver</Setting>
    <Setting Target="Adapter" Name="JGService">EnsLib.JavaGateway.Service</Setting>
    <Setting Target="Adapter" Name="Credentials">Postgresql_User</Setting>
    <Setting Target="Adapter" Name="JDBCClasspath">/jgw/postgresql-42.6.0.jar</Setting>
  </Item>
</Production>
}

}
