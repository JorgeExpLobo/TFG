import { useEffect, useState } from "react"

interface Ingredient {
  nombre_original: string
  cantidad: number
  unidad: string
}

export default function Ingredients() {

  const [ingredients, setIngredients] = useState<Ingredient[]>([])

  useEffect(() => {

    async function fetchIngredients() {

      const res = await fetch("/api/ingredients")
      const data = await res.json()

      setIngredients(data)

    }

    fetchIngredients()

  }, [])

  return (

  <div className="page">
      <div className="page-content">
        <h2>Ingredientes</h2>
        <table>
          <thead>
            <tr>
              <th>Ingrediente</th>
              <th>Cantidad</th>
              <th>Unidad</th>
            </tr>
          </thead>
          <tbody>
            {ingredients.map((ingredient, index) => (
              <tr key={index}>
                <td>{ingredient.nombre_original}</td>
                <td>{ingredient.cantidad}</td>
                <td>{ingredient.unidad}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
)

}