# SYSTEM ARCHITECTURE

Stack tecnológico:

Frontend:
(no especificado aún)

Backend automation:
n8n

Database:
PostgreSQL

Deployment:
Docker

IA:
LLM para interpretación de ingredientes y precios

---

Arquitectura general:

User
 ↓
n8n Workflow
 ↓
LLM normalización ingredientes
 ↓
PostgreSQL database
 ↓
Inventario ingredientes
 ↓
IA generación recetas