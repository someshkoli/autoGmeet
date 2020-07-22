const express = require('express'),
  bodyParser = require('body-parser'),
  app = express(),
  controllers = {
    PING: require('./lib/routes').ping,
    JOIN: require('./lib/routes').join,
    MESSAGE: require('./lib/routes').message,
    EXIT: require('./lib/routes').exit,
  };
  
require('dotenv').config(),
app.use(bodyParser.urlencoded({extended : false}));

app.get('/', controllers.PING);

// app.get('/lectures', controllers.MEETINGS);

app.get('/join', controllers.JOIN);

app.get('/message', controllers.MESSAGE);

app.get('/exit', controllers.EXIT)

app.listen(process.env.PORT, () => {
  console.log('App is listening on port ' + process.env.PORT);
})