# workshop-fhir-adapter
Example about a project based on InterSystems IRIS and FHIR Adapter capabilities work with FHIR.

You can find more in-depth information in https://learning.intersystems.com.


# What do you need to install? 
* [Git](https://git-scm.com/downloads) 
* [Docker](https://www.docker.com/products/docker-desktop) (if you are using Windows, make sure you set your Docker installation to use "Linux containers").
* [Docker Compose](https://docs.docker.com/compose/install/)
* [Visual Studio Code](https://code.visualstudio.com/download) + [InterSystems ObjectScript VSCode Extension](https://marketplace.visualstudio.com/items?itemName=daimor.vscode-objectscript)

# Setup
Build the image we will use during the workshop:

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
$ docker-compose up -d
```

# What are you going to find in this project?
* An IRIS for Health Community version with FHIR Adapter installed and accesible from the [Management Portal](http://localhost:52774/csp/sys/UtilHome.csp):
* A PostgreSQL database running some basic tables to test the FHIR Adapter functionality.
* A database explorer called [Adminer](http://localhost:8080/?pgsql=postgres&username=testuser&db=testuser&ns=his) with namespace and database pre-configured.
* A Postman json file to launch the test directly from your own Postman
