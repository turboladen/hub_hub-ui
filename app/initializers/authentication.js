export default {
  name: 'authentication',
  before: 'simple-auth',
  after: 'store',

  initialize: function(container, application) {
    application.register('authenticator:hub_hub', App.CustomAuthenticator);
    application.register('authorizer:hub_hub', App.CustomAuthorizer);
    application.inject('authenticator:hub_hub', 'store', 'store:main');
  }
};

if (window.ENV == null) {
  window.ENV = {};
}

window.ENV['simple-auth'] = {
  authorizer: 'authorizer:hub_hub'
};
