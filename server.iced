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
	week = 1000 * 60 * 60 * 24 * 7
	app.use express.cookieSession {key: "sessionID", secret: crypto.randomBytes(32).toString("hex"), cookie: {path: "/", maxAge: week, httpOnly: true}}
MongoClient = require("mongodb").MongoClient
app.use "/img", express.static("img")

WebSocketServer = require("ws").Server
wss = new WebSocketServer port: 8081

wss.on "connection", (ws) ->
	ws.on "message", (message) ->
		undefined

CONNECTIONS = {}
createID = (cb, bytes = 32) ->
	crypto.randomBytes bytes, (err, buffer) ->
		cb buffer.toString "hex"

app.all "/", (request, response) ->
	# Check for session
	undefined
	response.redirect "/connect"
app.get "/connect", (request, response) ->
	response.render "connect.jade", (err, html) ->
		if err then throw err
		response.send html
app.post "/auth", (request, response) ->
	uri = request.body.uri
	unless uri
		uri = request.body.placeholder
	await MongoClient.connect uri, defer(err, db)
	if err
		response.type "text"
		response.send "There was an error connecting to the database\n\n#{err}"
		return
	await createID defer id
	CONNECTIONS[id] = db
	# Set the id into a cookie
	request.session.id = id
	# Redirect them to the main page
	response.redirect "/admin"
# Handler that is called upon connecting
app.get "/admin", (request, response) ->
	id = request.session.id
	unless id of CONNECTIONS
		return response.redirect "/connect"
	db = CONNECTIONS[id]
	dbName = db.databaseName
	await db.stats defer err, dbStats
	await db.admin().serverStatus defer err, dbStatus
	await db.collectionNames {namesOnly: true}, defer err, dbCollections
	# Shorten the collection names
	for collection, cIndex in dbCollections
		dbCollections[cIndex] = (collection.split(".")[1..]).join "."
	response.render "admin.jade", {dbName, dbStats, dbStatus, dbCollections}, (err, html) ->
		if err then throw err
		response.send html


PORT = 8080 
app.listen PORT, ->
	console.log "colossal is listening on port #{PORT}"