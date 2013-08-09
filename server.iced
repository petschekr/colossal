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