# AI SYSTEM RULES

La IA debe seguir estas reglas:

1. ingrediente_base.nombre es único

2. Las variantes dependen del ingrediente_base

3. Los precios NO se interpretan en SQL

4. Los precios se guardan como texto

Ejemplos válidos:

"2.50€"
"4€ / kg"
"$3.20"

5. Currency se guarda en columna separada

Ejemplo:

currency = "EUR"