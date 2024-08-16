# workshop-fhir-adapter
Example about a project based on InterSystems IRIS and FHIR Adapter capabilities work with FHIR.

You can find more in-depth information in https://learning.intersystems.com.


# What do you need to install? 
* [Git](https://git-scm.com/downloads) 
* [Docker](https://www.docker.com/products/docker-desktop) (if you are using Windows, make sure you set your Docker installation to use "Linux containers").
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Visual Studio Code](https://code.visualstudio.com/download) + [InterSystems ObjectScript VSCode Extension](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript)

# Setup
Build the image that we will use during the workshop:

```console
$ git clone https://github.com/intersystems-ib/workshop-fhir-adapter
$ cd workshop-fhir-adapter
$ docker-compose build
```

# Introduction
With FHIR Adapter you can leverage the capability of InterSystems IRIS for Health to work with FHIR objects. You will be able to create a FHIR Façade to communicate your legacy systems and the new app based on FHIR definitions.

# How to run the container?
Very easy! Just run the following command to start the IRIS instance:

```console
$ mkdir -p shared
$ chown -R 51773:51773 shared
$ docker-compose up -d
```

# What are you going to find in this project?
* An IRIS for Health Community version with FHIR Adapter installed and accesible from the [Management Portal](http://localhost:52774/csp/sys/UtilHome.csp) (user: SuperUser / password: SYS):
* A PostgreSQL database running some basic tables to test the FHIR Adapter functionality.
* A database explorer called [Adminer](http://localhost:8080/?pgsql=postgres&username=testuser&db=testuser&ns=his) (user: testuser / password: testpassword) with namespace and database pre-configured.
* A Postman json file to launch the test directly from your own Postman

# How to test this project?
## Adding patient resouce
* Check the PostgreSQL tables preloaded from [Adminer](http://localhost:8080/?pgsql=postgres&username=testuser&db=testuser&ns=his)
![image](https://github.com/intersystems-ib/workshop-fhir-adapter/blob/main/assets/adminer.png)
* Open your Postman and import file /postman/FHIR Adapter.postman_collection.json
![image](https://github.com/intersystems-ib/workshop-fhir-adapter/blob/main/assets/import.png)
* Select *Add person* and click on *Send*. You will receive as response the new resource of type *Patient* added into PostgreSQL database.
![image](https://github.com/intersystems-ib/workshop-fhir-adapter/blob/main/assets/add.png)
* Confirm that the patient has been saved into Patient table.
![image](https://github.com/intersystems-ib/workshop-fhir-adapter/blob/main/assets/new_patient.png)
## Searching patient resource
* From Postman click on *Search person* and update URL with the ID returned for the patient from the previous point (ie.: http://localhost:52774/Adapter/r4/Patient/4)
* Click on *Send* and confirm that the resource returned belongs to the patient created previously.
![image](https://github.com/intersystems-ib/workshop-fhir-adapter/blob/main/assets/search.png)
## Adding patient and organization from a Bundle
* From Postman select *Add person bundle* and check the Bundle. You will notice that we have 2 type of resources, Organization and Patient, we are going to save both of them in just one transaction.
![image](https://github.com/intersystems-ib/workshop-fhir-adapter/blob/main/assets/add_bundle.png)
* Click on *Send* again and confirm that the response from IRIS is a new Bundle:
![image](https://github.com/intersystems-ib/workshop-fhir-adapter/blob/main/assets/search_bundle.png)



  
