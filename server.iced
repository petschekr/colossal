http = require "http"
fs = require "fs"
crypto = require "crypto"
path = require "path"

# Express
express = require "express"
app = express()
# Jade
require "coffee-script"
app.set "views", "client/"

# For POST parsing
app.configure ->
	app.use express.compress()
	app.use express.bodyParser()
	app.use express.cookieParser()
MongoClient = require("mongodb").MongoClient
app.use "/img", express.static("img")

WebSocketServer = require("ws").Server
wss = new WebSocketServer port: 8081

wss.on "connection", (ws) ->
	ws.on "message", (message) ->
		undefined

app.all "/", (request, response) ->
	# Check for session
	undefined
	response.redirect "/connect"
app.get "/connect", (request, response) ->
	response.render "connect.jade", (err, html) ->
		if err then throw err
		response.send html


PORT = 8080 
app.listen PORT, ->
	console.log "colossal is listening on port #{PORT}"