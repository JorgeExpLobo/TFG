const express = require("express");
const app = express();

app.use(express.json());

app.post("/api/message", (req, res) => {
  const { message } = req.body;

  console.log("Mensaje recibido:", message);

  res.json({
    reply: "Recibido: " + message
  });
});

app.listen(3001, () => {
  console.log("Servidor corriendo en http://localhost:3001");
});