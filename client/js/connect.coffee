generateURI = (host, username, password, database, port) ->
	unless host
		return ""
	uri = "mongodb://"
	if username
		creds = username
		if password
			creds += ":"
			creds += password
		creds += "@"
		uri += creds
	uri += host
	uri += ":"
	if port
		uri += port
	else
		uri += "27017"
	if database
		uri += "/"
		uri += database
	return uri

generateButton = document.querySelector ".generate button"
generateButton.onclick = ->
	host = document.getElementById("gen-uri").value
	username = document.getElementById("gen-username").value
	password = document.getElementById("gen-password").value
	database = document.getElementById("gen-db").value
	port = document.getElementById("gen-port").value
	document.querySelector(".string input").value = generateURI host, username, password, database, port
return