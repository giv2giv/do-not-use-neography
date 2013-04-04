
Welcome to the giv2giv API
===========================
This API provides simple REST endpoints for features shared by the front end applications (located next to this repo on GitHub, under the giv2giv organization).  

Getting Started
===============
The API uses Sinatra for serving up endpoints, and neo4j for managing data. 

Starting Neo4j
---------------
Neo4j must be running locally on port 7474 for the API to work correctly.  You can configure this to work differently in a sort of awkward way at the moment.

* Download the community edition of neo4j from http://www.neo4j.org/install
* Untar the downloaded file.
* Start up Neo4j

> ./bin/neo4j start

Starting the api
---------------
> bundle install

> shotgun

visit <http://localhost:9393>

