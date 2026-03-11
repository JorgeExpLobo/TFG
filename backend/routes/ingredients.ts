import express from "express"
import { getIngredients } from "../queries/ingredients"

const router = express.Router()

router.get("/", async (req, res) => {

    try {

        const ingredients = await getIngredients()
        res.json(ingredients)

    } catch (error) {

        console.error(error)
        res.status(500).json({ error: "Database error" })

    }

})

export default router