  
Welcome to the giv2giv API
===========================
This API provides simple REST endpoints for features shared by the front end applications (located next to this repo on GitHub, under the giv2giv organization).  

Getting Started
===============
The API uses Sinatra for serving up endpoints, and neo4j for managing data. 

Starting Neo4j
---------------
Neo4j must be running locally on port 7474 for the API to work correctly.  You can configure this to work differently in a sort of awkward way at the moment.

This is now included as rake tasks that can be run easily. If you do not have Neo4J installed, run

> rake neo4j:install

If it is installed, or after performing the above action, run

> rake neo4j:start

Load the Charities
------------------
ruby ./charity_import.rb

Buid the indexes
-------------------
ruby ./initial_seed.rb

Starting the api
---------------
> bundle install

> shotgun

visit <http://localhost:9393>


Running the Tests
=================

