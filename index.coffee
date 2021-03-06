# initialization

fs = require 'fs'
http = require 'http'
express = require 'express'
ca = require 'connect-assets'
request = require 'request'
log = require('logule').init(module)
moment = require 'moment'

app = express()
server = http.createServer app

# error handling

process.on 'uncaughtException', (err) ->
  log.error err.stack

# configuration

app.configure ->
  app.set 'views', __dirname + '/app/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.favicon __dirname + '/public/img/favicon.ico'
  app.use express.static __dirname + '/public'
  app.use ca {
    src: 'app/assets'
    buildDir: 'public'
  }

app.configure 'development', ->
  app.set 'BASE_URL', 'http://localhost:3993'

app.configure 'production', ->
  app.set 'BASE_URL', 'http://www.gladysmusic.com'

# middlewares

logRequest = (req, res, next) ->
  log.info req.method + ' ' + req.url
  next()

setLocals = (req, res, next) ->
  app.locals.currentPath = req.path
  next()

# moment

moment.locale 'fr'

# routes

app.all '*', setLocals, logRequest, (req, res, next) ->
  next()

app.get '/', (req, res) ->
  res.render 'home'

app.get '/news', (req, res) ->
  res.render 'news'

app.get '/concerts', (req, res) ->
  res.render 'concerts'

app.get '/photos', (req, res) ->
  res.render 'photos'

app.get '/videos', (req, res) ->
  res.render 'videos'

app.get '/bio', (req, res) ->
  res.render 'bio'

app.get '/contact', (req, res) ->
  res.render 'contact'

app.get '/teaser', (req, res) ->
  res.render 'teaser'

# API

app.get '/api/concerts', (req, res) ->
  concerts = []
  request.get('http://api.bandsintown.com/artists/Gladys/events.json?api_version=2.0&app_id=Gladys', {
    json: true
  }, (error, response, body) ->
    body.forEach (item) ->
      concerts.push {
        date: moment(item.datetime).format 'LL'
        venue: item.venue.name
        location: item.formatted_location
        url: item.facebook_rsvp_url
      }
    res.send concerts
  )

# 404

app.all '*', (req, res) ->
  res.statusCode = 404
  res.render '404', {
    code: '404'
  }

# server creation

server.listen process.env.PORT ? '3993', ->
  log.info 'Express server listening on port ' + server.address().port + ' in ' + app.settings.env + ' mode'