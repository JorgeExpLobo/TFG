import db from "../db/db"

export async function getIngredients() {

    const ingredientes = await db.any(`
        SELECT 
            nombre_original,
            cantidad,
            unidades.nombre AS unidad
        FROM ingrediente_usuario
        LEFT JOIN unidades
        ON ingrediente_usuario.unidad_id = unidades.id
    `)

    return ingredientes
}