var meet = require('./gmeet'),
  connection;

let ping = async (req,res) => {
  return res.send('ping!!')
};

let join = async (req, res) => {
  if(connection != null) connection = null;
  connection = new meet();
  let result = await connection.join(req.query.count);
  return res.send('join');
}

let message = async (req, res) => {
  let result = await connection.message(req.query.text);
  return res.send(result);
}

let exit = async (req, res) => {
  await connection.close();
  connection = null;
  return res.send('exit');
}

module.exports = {
  ping,
  join,
  message,
  exit
}