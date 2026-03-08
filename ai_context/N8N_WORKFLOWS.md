# N8N WORKFLOWS

El sistema usa n8n como backend automation.

Principales workflows:

1. Importar ingredientes desde ticket
2. Normalizar ingredientes con IA
3. Insertar ingredientes en PostgreSQL
4. Generar recetas
5. Crear dietas semanales

---

Workflow: registrar ingrediente

Input:

{
 ingredient_name
 ingredient_variant
 quantity
 unit
 brand
 price_unit
 price_total
 currency
 user_id
}

El workflow ejecuta una query PostgreSQL que:

1. crea ingrediente_base si no existe
2. crea variante si no existe
3. crea marca si no existe
4. inserta ingrediente_usuario