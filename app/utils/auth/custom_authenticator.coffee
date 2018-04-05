`import Base from 'simple-auth/authenticators/base';`

###
Authenticator that conforms to HubHub's session auth.

This authenticator supports refreshing the access token automatically and
will trigger the `'ember-simple-auth:session-updated'` event each time the
token was refreshed.

@class CustomAuthenticator
@namespace App
@extends Ember.SimpleAuth.Authenticators.Base
###
CustomAuthenticator = Base.extend

  ###
  The endpoint on the server the authenticator acquires the access token
  from.

  @property serverTokenEndpoint
  @type String
  @default '/api/sessions'
  ###
  serverTokenEndpoint: "/api/sessions"

  ###
  Restores the session from a set of session properties; __will return a
  resolving promise when there's a non-empty `authToken` in the
  `properties`__ and a rejecting promise otherwise.

  @method restore
  @param {Object} properties The properties to restore the session from.
  @return {Ember.RSVP.Promise} A promise that when it resolves results in the session being authenticated.
  ###
  restore: (properties) ->
    log.debug 'restoring, user id: ' + properties.userId

    new Ember.RSVP.Promise((resolve, reject) =>
      if Ember.isEmpty(properties.accessToken) or Ember.isEmpty(properties.userId)
        reject()
      else
        resolve properties
    )


  ###
  Authenticates the session with the specified `credentials`; the credentials
  are `POST`ed to the `serverTokenEndpoint` and if they are valid the server
  returns an access token in response.  __If the credentials are
  valid and authentication succeeds, a promise that resolves with the
  server's response is returned__, otherwise a promise that rejects with the
  error is returned.

  @method authenticate
  @param {Object} options The credentials to authenticate the session with
  @return {Ember.RSVP.Promise} A promise that resolves when an access token is successfully acquired from the server
    and rejects otherwise
  ###
  authenticate: (credentials) ->
    Ember.Logger.debug "MEOW: authenticating"

    new Ember.RSVP.Promise((resolve, reject) =>
      data =
        email: credentials.identification
        password: credentials.password

      @makeRequest(data).then ((response) ->
        Ember.Logger.debug 'Making request'

        Ember.run ->
          #log.debug 'response user id: ' + response.user_id
          #@store.find('user', response.user_id)
          resolve response
      ), (xhr, status, error) ->
        Ember.run ->
          reject xhr.responseText
    )


  ###
  Cancels any outstanding automatic token refreshes.

  @method invalidate
  @return {Ember.RSVP.Promise} A resolving promise
  ###
  invalidate: ->
    new Ember.RSVP.Promise((resolve) ->
      resolve()
    )


  ###
  @method makeRequest
  @private
  ###
  makeRequest: (data) ->
    Ember.$.ajax
      url: @serverTokenEndpoint
      type: "POST"
      data: JSON.stringify(data)
      dataType: "json"
      contentType: "application/json"
