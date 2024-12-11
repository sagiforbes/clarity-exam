const express = require('express');
const app = express();

app.get('/clarity', (req, res) => {
  res.status(200).send('Clarity Lambda Function Response');
});

exports.handler = async (event) => {
  const result = await app.handle(event);
  return {
    statusCode: 200,
    body: result
  };
};
