# DATABASE DESIGN

La base de datos sigue un sistema de normalización de ingredientes.

ingrediente_base
↓
ingrediente_variante
↓
ingrediente_sinonimo

Ejemplo:

ingrediente_base
tomate

variantes
tomate cherry
tomate seco

sinónimos
tomato
jitomate

Precios: Los precios NO se calculan en SQL. Se guardan como texto porque provienen de tickets.
Otra IA posterior interpretará esos valores.

Ejemplos:

"2.50€"
"3€ / kg"
"$4.99"

Currency

Se guarda en columna separada: currency TEXT
Ejemplo:

EUR
USD
GBP
