You are assisting with the AI Cooking App TFG project.

This project uses:

n8n for automation
PostgreSQL database
Docker deployment

Important rules:

ingredient_base.nombre is UNIQUE

ingredient variants belong to a base ingredient

prices are stored as TEXT

examples:
"2€"
"3.50€"
"$4.20"

currency is stored separately.

The database schema must not be changed unless explicitly requested.