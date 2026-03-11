import pgPromise from "pg-promise"

const pgp = pgPromise()

const db = pgp("postgres://n8n:n8npassword@localhost:5432/tfg_cooking_app")


export default db