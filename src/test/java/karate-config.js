function fn() {
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  if (!env) {
    env = 'dev';
  }
  var config = {
    apiUrl: 'https://conduit-api.bondaracademy.com/api/'
  }
  if (env == 'dev') {
    config.userEmail = 'karate@test12.com'
    config.userPassword = 'karate123'
  } else if (env == 'qa') {
    config.userEmail = 'karate@test12.com'
    config.userPassword = 'karate123'
  }

  var accessToken = karate.callSingle('classpath:helpers/CreateToken.feature', config).token
  karate.configure('headers', { Authorization: 'Token ' + accessToken })

  return config;
}