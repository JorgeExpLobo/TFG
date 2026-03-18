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


-- =====================================================
-- FUNCIÓN ACTUALIZADA (CÁLCULO + REDONDEO)
-- =====================================================

CREATE OR REPLACE FUNCTION add_ingrediente_usuario(
    p_usuario_id UUID,
    p_nombre_original TEXT,
    p_base TEXT,
    p_variante TEXT,
    p_cantidad NUMERIC,
    p_unidad TEXT,
    p_marca TEXT,
    p_precio_unitario NUMERIC,
    p_precio_total NUMERIC,
    p_currency TEXT
)
RETURNS UUID AS $$

DECLARE
    v_base_id UUID;
    v_variante_id UUID;
    v_unidad_id INTEGER;
    v_marca_id UUID;

    v_existing_id UUID;
    v_existing_cantidad NUMERIC;
    v_existing_factor NUMERIC;

    v_new_factor NUMERIC;
    v_cantidad_convertida NUMERIC;

BEGIN

    -- =========================
    -- NORMALIZAR CURRENCY
    -- =========================
    IF p_currency = '€' THEN
        p_currency := 'EUR';
    ELSIF p_currency = '$' THEN
        p_currency := 'USD';
    ELSIF p_currency = '£' THEN
        p_currency := 'GBP';
    END IF;

    IF p_currency IS NULL OR p_currency NOT IN (SELECT code FROM currencies) THEN
        p_currency := 'EUR';
    END IF;

    -- =========================
    -- BASE
    -- =========================
    SELECT id INTO v_base_id
    FROM ingrediente_base
    WHERE LOWER(nombre) = LOWER(p_base)
    LIMIT 1;

    IF v_base_id IS NULL THEN
        INSERT INTO ingrediente_base(nombre)
        VALUES (LOWER(p_base))
        RETURNING id INTO v_base_id;
    END IF;

    -- =========================
    -- VARIANTE
    -- =========================
    IF p_variante IS NOT NULL AND p_variante <> '' THEN

        SELECT id INTO v_variante_id
        FROM ingrediente_variante
        WHERE ingrediente_base_id = v_base_id
        AND LOWER(nombre) = LOWER(p_variante)
        LIMIT 1;

        IF v_variante_id IS NULL THEN
            INSERT INTO ingrediente_variante(ingrediente_base_id, nombre)
            VALUES (v_base_id, LOWER(p_variante))
            RETURNING id INTO v_variante_id;
        END IF;

    END IF;

    -- =========================
    -- UNIDAD
    -- =========================
    SELECT id, factor_base INTO v_unidad_id, v_new_factor
    FROM unidades
    WHERE LOWER(nombre) = LOWER(p_unidad)
    LIMIT 1;

    IF v_unidad_id IS NULL THEN
        RAISE EXCEPTION 'Unidad no encontrada: %', p_unidad;
    END IF;

    -- =========================
    -- MARCA
    -- =========================
    IF p_marca IS NOT NULL AND p_marca <> '' THEN

        SELECT id INTO v_marca_id
        FROM marcas
        WHERE LOWER(nombre) = LOWER(p_marca)
        LIMIT 1;

        IF v_marca_id IS NULL THEN
            INSERT INTO marcas(nombre)
            VALUES (p_marca)
            RETURNING id INTO v_marca_id;
        END IF;

    END IF;

    -- =========================
    -- BUSCAR EXISTENTE
    -- =========================
    SELECT iu.id, iu.cantidad, u.factor_base
    INTO v_existing_id, v_existing_cantidad, v_existing_factor
    FROM ingrediente_usuario iu
    JOIN unidades u ON iu.unidad_id = u.id
    WHERE iu.usuario_id = p_usuario_id
    AND iu.ingrediente_base_id = v_base_id
    AND (
        (iu.variante_id IS NULL AND v_variante_id IS NULL)
        OR iu.variante_id = v_variante_id
    )
    AND (
        (iu.marca_id IS NULL AND v_marca_id IS NULL)
        OR iu.marca_id = v_marca_id
    )
    LIMIT 1;

    -- =========================
    -- SI EXISTE → SUMAR + REDONDEAR
    -- =========================
    IF v_existing_id IS NOT NULL THEN

        v_cantidad_convertida :=
            ROUND((p_cantidad * v_new_factor) / v_existing_factor, 2);

        UPDATE ingrediente_usuario
        SET 
            cantidad = ROUND(COALESCE(cantidad, 0) + v_cantidad_convertida, 2),
            precio_total = ROUND(COALESCE(precio_total, 0) + p_precio_total, 2)
        WHERE id = v_existing_id;

        RETURN v_existing_id;

    END IF;

    -- =========================
    -- INSERT NUEVO
    -- =========================
    INSERT INTO ingrediente_usuario(
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
        p_usuario_id,
        v_base_id,
        v_variante_id,
        p_nombre_original,
        ROUND(p_cantidad, 2),
        v_unidad_id,
        v_marca_id,
        ROUND(p_precio_unitario, 2),
        ROUND(p_precio_total, 2),
        p_currency
    )
    RETURNING id INTO v_existing_id;

    RETURN v_existing_id;

END;

$$ LANGUAGE plpgsql;


-- =========================
-- INDEX (INCLUYE MARCA)
-- =========================
CREATE INDEX IF NOT EXISTS idx_ingrediente_lookup
ON ingrediente_usuario (
  usuario_id,
  ingrediente_base_id,
  variante_id,
  marca_id
);