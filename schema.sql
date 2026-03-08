-- =====================================================
-- EXTENSIONS
-- =====================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =====================================================
-- USERS
-- =====================================================

CREATE TABLE usuarios (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email TEXT UNIQUE NOT NULL,
    nombre_usuario TEXT,
    ubicacion_lat NUMERIC,
    ubicacion_lng NUMERIC,
    created_at TIMESTAMP DEFAULT NOW()
);

-- =====================================================
-- USER SETTINGS
-- =====================================================

CREATE TABLE ajustes_usuario (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,

    tema TEXT DEFAULT 'light',
    idioma TEXT DEFAULT 'es',
    cookies BOOLEAN DEFAULT TRUE,
    preferencias_dietarias TEXT,

    created_at TIMESTAMP DEFAULT NOW()
);

-- =====================================================
-- INGREDIENT BASE
-- =====================================================

CREATE TABLE ingrediente_base (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre TEXT NOT NULL
);

ALTER TABLE ingrediente_base
ADD CONSTRAINT ingrediente_base_unique
UNIQUE (nombre);

-- =====================================================
-- INGREDIENT VARIANTS
-- =====================================================

CREATE TABLE ingrediente_variante (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ingrediente_base_id UUID REFERENCES ingrediente_base(id) ON DELETE CASCADE,
    nombre TEXT NOT NULL,
    UNIQUE (ingrediente_base_id, nombre)
);

-- =====================================================
-- INGREDIENT SYNONYMS
-- =====================================================

CREATE TABLE ingrediente_sinonimo (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    ingrediente_base_id UUID REFERENCES ingrediente_base(id) ON DELETE CASCADE,
    sinonimo TEXT NOT NULL
);

-- =====================================================
-- BRANDS
-- =====================================================

CREATE TABLE marcas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    nombre TEXT UNIQUE
);

-- =====================================================
-- UNITS
-- =====================================================

CREATE TABLE unidades (
    id SERIAL PRIMARY KEY,
    nombre TEXT UNIQUE,
    tipo TEXT,
    factor_base NUMERIC
);

-- =====================================================
-- CURRENCIES
-- =====================================================

CREATE TABLE currencies (
    code TEXT PRIMARY KEY,
    symbol TEXT,
    nombre TEXT
);

-- =====================================================
-- USER INGREDIENT INVENTORY
-- =====================================================

CREATE TABLE ingrediente_usuario (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,

    ingrediente_base_id UUID REFERENCES ingrediente_base(id),
    variante_id UUID REFERENCES ingrediente_variante(id),

    nombre_original TEXT NOT NULL,

    cantidad NUMERIC,

    unidad_id INTEGER REFERENCES unidades(id),

    marca_id UUID REFERENCES marcas(id),

    precio_unitario TEXT,
    precio_total TEXT,

    currency TEXT REFERENCES currencies(code),

    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_usuario_ingredientes
ON ingrediente_usuario(usuario_id);

-- =====================================================
-- RECIPE CATEGORIES
-- =====================================================

CREATE TABLE categorias_receta (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
    nombre TEXT NOT NULL
);

-- =====================================================
-- RECIPES
-- =====================================================

CREATE TABLE recetas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,
    categoria_id UUID REFERENCES categorias_receta(id),

    nombre TEXT NOT NULL,
    descripcion TEXT,
    instrucciones TEXT,

    created_at TIMESTAMP DEFAULT NOW()
);

-- =====================================================
-- RECIPE INGREDIENTS
-- =====================================================

CREATE TABLE receta_ingredientes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    receta_id UUID REFERENCES recetas(id) ON DELETE CASCADE,

    ingrediente_base_id UUID REFERENCES ingrediente_base(id),

    cantidad NUMERIC,

    unidad_id INTEGER REFERENCES unidades(id)
);

-- =====================================================
-- DIETS
-- =====================================================

CREATE TABLE dietas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    usuario_id UUID REFERENCES usuarios(id) ON DELETE CASCADE,

    nombre TEXT,

    pdf_blob BYTEA,

    created_at TIMESTAMP DEFAULT NOW()
);

-- =====================================================
-- DIET MEALS
-- =====================================================

CREATE TABLE dieta_comidas (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),

    dieta_id UUID REFERENCES dietas(id) ON DELETE CASCADE,

    semana INTEGER,
    dia TEXT,
    comida TEXT,

    receta_id UUID REFERENCES recetas(id)
);

-- =====================================================
-- VIEW USER EXPENSE
-- =====================================================

CREATE VIEW gasto_usuario AS
SELECT
    usuario_id,
    COUNT(*) AS ingredientes_registrados
FROM ingrediente_usuario
GROUP BY usuario_id;

-- =====================================================
-- USERS
-- =====================================================

INSERT INTO usuarios (email, nombre_usuario, ubicacion_lat, ubicacion_lng)
VALUES
('test@test.com', 'chefAI', 40.4168, -3.7038),
('user2@test.com', 'foodlover', 41.3874, 2.1686);

-- =====================================================
-- USER SETTINGS
-- =====================================================

INSERT INTO ajustes_usuario (usuario_id, preferencias_dietarias)
SELECT id, 'alta proteína'
FROM usuarios
WHERE email='test@test.com';

-- =====================================================
-- CURRENCIES
-- =====================================================

INSERT INTO currencies (code, symbol, nombre) VALUES
('EUR','€','Euro'),
('USD','$','US Dollar'),
('GBP','£','British Pound');

-- =====================================================
-- INGREDIENT BASE
-- =====================================================

INSERT INTO ingrediente_base (nombre) VALUES
('arroz'),
('pollo'),
('manzana'),
('leche'),
('huevo'),
('tomate'),
('pasta');

-- =====================================================
-- INGREDIENT SYNONYMS
-- =====================================================

INSERT INTO ingrediente_sinonimo (ingrediente_base_id, sinonimo)
SELECT id, 'rice'
FROM ingrediente_base WHERE nombre='arroz';

INSERT INTO ingrediente_sinonimo (ingrediente_base_id, sinonimo)
SELECT id, 'chicken'
FROM ingrediente_base WHERE nombre='pollo';

INSERT INTO ingrediente_sinonimo (ingrediente_base_id, sinonimo)
SELECT id, 'apple'
FROM ingrediente_base WHERE nombre='manzana';

-- =====================================================
-- INGREDIENT VARIANTS
-- =====================================================

INSERT INTO ingrediente_variante (ingrediente_base_id, nombre)
SELECT id, 'arroz basmati'
FROM ingrediente_base WHERE nombre='arroz';

INSERT INTO ingrediente_variante (ingrediente_base_id, nombre)
SELECT id, 'pollo fresco'
FROM ingrediente_base WHERE nombre='pollo';

INSERT INTO ingrediente_variante (ingrediente_base_id, nombre)
SELECT id, 'manzana roja'
FROM ingrediente_base WHERE nombre='manzana';

INSERT INTO ingrediente_variante (ingrediente_base_id, nombre)
SELECT id, 'tomate cherry'
FROM ingrediente_base WHERE nombre='tomate';

-- =====================================================
-- BRANDS
-- =====================================================

INSERT INTO marcas (nombre) VALUES
('Mercadona'),
('Carrefour'),
('BrandX'),
('Hacendado');

-- =====================================================
-- UNITS
-- =====================================================

INSERT INTO unidades (nombre, tipo, factor_base) VALUES
('unidad', 'cantidad', 1),
('g', 'peso', 1),
('kg', 'peso', 1000),
('ml', 'volumen', 1),
('l', 'volumen', 1000);

-- =====================================================
-- USER INGREDIENT INVENTORY
-- =====================================================

INSERT INTO ingrediente_usuario (
usuario_id,
ingrediente_base_id,
variante_id,
nombre_original,
cantidad,
unidad_id,
marca_id,
precio_unitario,
precio_total,
currency
)
VALUES (

(SELECT id FROM usuarios WHERE email='test@test.com'),

(SELECT id FROM ingrediente_base WHERE nombre='arroz'),

(SELECT id FROM ingrediente_variante WHERE nombre='arroz basmati'),

'arroz basmati',

1,

(SELECT id FROM unidades WHERE nombre='kg'),

(SELECT id FROM marcas WHERE nombre='Mercadona'),

'2.50€ / kg',

'2.50€',

'EUR'

);

INSERT INTO ingrediente_usuario (
usuario_id,
ingrediente_base_id,
variante_id,
nombre_original,
cantidad,
unidad_id,
marca_id,
precio_unitario,
precio_total,
currency
)
VALUES (

(SELECT id FROM usuarios WHERE email='test@test.com'),

(SELECT id FROM ingrediente_base WHERE nombre='pollo'),

(SELECT id FROM ingrediente_variante WHERE nombre='pollo fresco'),

'pollo fresco',

2,

(SELECT id FROM unidades WHERE nombre='unidad'),

(SELECT id FROM marcas WHERE nombre='Carrefour'),

'4€ / unidad',

'8€',

'EUR'

);

-- =====================================================
-- RECIPE CATEGORIES
-- =====================================================

INSERT INTO categorias_receta (usuario_id, nombre)
SELECT id, 'Comida'
FROM usuarios
WHERE email='test@test.com';

INSERT INTO categorias_receta (usuario_id, nombre)
SELECT id, 'Cena'
FROM usuarios
WHERE email='test@test.com';

-- =====================================================
-- RECIPES
-- =====================================================

INSERT INTO recetas (
usuario_id,
categoria_id,
nombre,
descripcion,
instrucciones
)
VALUES (

(SELECT id FROM usuarios WHERE email='test@test.com'),

(SELECT id FROM categorias_receta WHERE nombre='Comida'),

'Arroz con pollo',

'Receta clásica española',

'Cocer arroz, dorar pollo, mezclar y cocinar 20 minutos.'

);

-- =====================================================
-- RECIPE INGREDIENTS
-- =====================================================

INSERT INTO receta_ingredientes (
receta_id,
ingrediente_base_id,
cantidad,
unidad_id
)
VALUES
(
(SELECT id FROM recetas WHERE nombre='Arroz con pollo'),
(SELECT id FROM ingrediente_base WHERE nombre='arroz'),
200,
(SELECT id FROM unidades WHERE nombre='g')
),

(
(SELECT id FROM recetas WHERE nombre='Arroz con pollo'),
(SELECT id FROM ingrediente_base WHERE nombre='pollo'),
1,
(SELECT id FROM unidades WHERE nombre='unidad')
);

-- =====================================================
-- DIETS
-- =====================================================

INSERT INTO dietas (
usuario_id,
nombre
)
VALUES (
(SELECT id FROM usuarios WHERE email='test@test.com'),
'Dieta alta proteína'
);

-- =====================================================
-- DIET MEALS
-- =====================================================

INSERT INTO dieta_comidas (
dieta_id,
semana,
dia,
comida,
receta_id
)
VALUES (

(SELECT id FROM dietas WHERE nombre='Dieta alta proteína'),

1,
'Lunes',
'Almuerzo',

(SELECT id FROM recetas WHERE nombre='Arroz con pollo')

);