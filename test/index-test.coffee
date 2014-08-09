assert = require 'power-assert'
Checkit = require 'checkit'
mongoose = require 'mongoose'
checkit = require '../'

Checkit.Validators.username = (value) ->
  unless /^[a-z][a-z0-9\-]{1,30}[a-z0-9]$/.test value
    throw new Error 'The username must only contain alpha-numeric characters and dashes.'


mongoose.connect 'mongodb://localhost/mongoose-checkit'

mongoose.connection.once 'error', (err) ->
  console.log "MongoDB connection error: #{err}"
  process.exit(1)


simpleSchema = new mongoose.Schema
  username:
    type: String
    checkit: ['required']
  email:
    type: String
    checkit: ['required', 'email']

simpleSchema.plugin checkit
Simple = mongoose.model 'Simple', simpleSchema


advancedSchema = new mongoose.Schema
  username:
    type: String
    checkit: ['required', 'username']

  email:
    type: String
    checkit: ['required', 'email']

  profile:
    firstname:
      type: String
      checkit:
        rule: 'required'
        message: 'You mast supply a firstname value!!!'

    lastname:
      type: String
      checkit:
        rule: 'required'
        message: 'You mast supply a lastname value!!!'


advancedSchema.plugin checkit, Checkit
Advanced = mongoose.model 'Advanced', advancedSchema


describe 'Mongoose Checkit Plugin', ->

  describe 'Simple Schema', ->

    it 'should be error', (done) ->

      Simple.create email: 'kei@example', (err) ->
        assert err instanceof Checkit.Error
        assert err.errors.username instanceof Checkit.FieldError
        assert err.errors.email instanceof Checkit.FieldError
        done()

    it 'should be ok', (done) ->

      Simple.create username: 'keifukuda', email: 'kei@example.com', (err, simple) ->
        assert err is null
        assert simple
        done()


  describe 'Advanced Schema', ->

    it 'should be error', (done) ->

      attrs =
        username: 'あいうえお'
        email: 'kei@example'
        profile:
          firstname: 'Kei'

      Advanced.create attrs, (err) ->
        assert err instanceof Checkit.Error
        assert err.errors.username instanceof Checkit.FieldError
        assert err.errors.username.message is 'The username must only contain alpha-numeric characters and dashes.'
        assert err.errors.email instanceof Checkit.FieldError
        assert err.errors['profile.lastname'] instanceof Checkit.FieldError
        assert err.errors['profile.lastname'].message is 'You mast supply a lastname value!!!'
        done()


    it 'should be ok', (done) ->

      attrs =
        username: 'keifukuda'
        email: 'kei@example.com'
        profile:
          firstname: 'Kei'
          lastname: 'Fukuda'

      Advanced.create attrs, (err, advanced) ->
        assert err is null
        assert advanced
        done()
