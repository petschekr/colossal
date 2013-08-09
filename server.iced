http = require "http"
fs = require "fs"
crypto = require "crypto"

# Express
express = require "express"
app = express()

# For POST parsing
app.configure ->
	app.use express.compress()
	app.use express.bodyParser()
	app.use express.cookieParser()
MongoClient = require("mongodb").MongoClient

WebSocketServer = require("ws").Server
wss = new WebSocketServer port: 8081

wss.on "connection", (ws) ->
	ws.on "message", (message) ->
		undefined



PORT = 8080 
app.listen PORT, ->
	console.log "colossal is listening on port #{PORT}"