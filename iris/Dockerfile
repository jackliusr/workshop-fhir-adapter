ARG IMAGE=containers.intersystems.com/intersystems/irishealth-community:latest-cd
FROM $IMAGE

USER root

WORKDIR /opt/irisapp
RUN chown -R irisowner:irisowner /opt/irisapp

USER irisowner

# copy files to image
WORKDIR /opt/irisapp
COPY --chown=irisowner:irisowner src src

COPY --chown=$ISC_PACKAGE_MGRUSER:$ISC_PACKAGE_IRISGROUP /iris/irissession.sh /
RUN chmod +x /irissession.sh

# COPY --chown=$ISC_PACKAGE_MGRUSER:$ISC_PACKAGE_IRISGROUP /iris/webapp.xml /
# RUN chmod +x /webapp.xml

SHELL ["/irissession.sh"]

RUN \
zn "%SYS" \
set sc = $SYSTEM.OBJ.LoadDir("/opt/irisapp/src/Install", "ck", , 1) \
if sc do ##class(Install.Installer).Install() \
zn "ADAPTER" \
do ##class(Ens.Config.Credentials).SetCredential("Postgresql_User","testuser","testpassword") \
set sc = $SYSTEM.OBJ.LoadDir("/opt/irisapp/src/Adapter", "ck", , 1) \
# start production
set production = "Adapter.Production" \
set ^Ens.Configuration("csp","LastProduction") = production \
do ##class(Ens.Director).SetAutoStart(production) \
set sc = 1 \ 
set status = ##class(HS.FHIRServer.Installer).InteropAdapterConfig("/Adapter/r4") \