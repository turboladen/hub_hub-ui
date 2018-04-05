import Ember from 'ember';
import Resolver from 'ember/resolver';
import loadInitializers from 'ember/load-initializers';
import config from './config/environment';

Ember.MODEL_FACTORY_INJECTIONS = true;

var App = Ember.Application.extend({
  modulePrefix: config.modulePrefix,
  podModulePrefix: config.podModulePrefix,
  Resolver: Resolver
});

loadInitializers(App, config.modulePrefix);

export default App;

import ApplicationRouteMixin from 'simple-auth/mixins/application-route-mixin';


import CustomAuthenticator from 'app/utils/auth/custom_authenticator';
import CustomAuthorizer from 'app/utils/auth/custom_authorizer';

export default Ember.Route.extend(ApplicationRouteMixin);
