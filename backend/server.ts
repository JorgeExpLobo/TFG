import express, { Request, Response } from "express"
import cors from "cors"
import ingredientsRouter from "./routes/ingredients"

const app = express()
app.use(cors())
app.use(express.json())

app.post("/api/message", (req: Request, res: Response) => {
  const { message } = req.body

  console.log("Mensaje recibido:", message)

  res.json({
    reply: "Recibido: " + message
  })
})
app.use("/api/ingredients", ingredientsRouter)

app.listen(3001, () => {
  console.log("Servidor corriendo en http://localhost:3001")
})