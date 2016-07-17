# Teikametrics BEER
## Employee Earnings API

### Overview
This API provides a way to find average, minimum, and maximum salaries of Boston public employees by *position title*.  

Seeing as how Teikametrics runs a lot of ROR, I decided to write the API in ruby using the microframework, Sinatra.  Data went through some basic cleaning before being written into a simple SQLite3 database.  I chose sqlite because it allowed me to do SQL queries without having to set up a production database.  The process took more than a couple hours because I had to get re-acquainted with the awesomeness of Ruby and Sinatra.

Next steps would be to add ways to update and create new employee salary records. I refrained from doing that since authentification would be recommended as would a data Model for CRUD operations on the database, both things that could probably be more easily implemented in Rails.


### Requirements
* docker
* ruby 2.1
* sinatra
* sqlite3


### How to run
`docker build -t app .`

`docker run -d -p 4567:4567 --name boston app`


### API/UI Usage

POST http://<host>:4567/salary

|arg		|value			|default	|
|-----------|---------------|-----------|
|title  	|title to search|*required	|
|stat   	|avg, min, max  |avg 		|

Sample calls to API:

curl http://<host>:4567/salary/ -d "title=teacher"
curl http://<host>:4567/salary/ -d "title=assistant+counselor&stat=max"

OR visit http://#{host}:4567/ for the UI


#### Links
[Linked Profile](https://www.linkedin.com/in/tylereto)
Unfortunately, all of my projects at Porch are private
