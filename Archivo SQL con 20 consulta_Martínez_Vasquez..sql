-- ============================================================
--  GUÍA DE CONSULTAS - Base de Datos: tourism (PostgreSQL 13)
--  Manejador: pgAdmin 4  |  Esquema: tourism
--  Esquema: tourism
--  Responsable: Ovidio Omar Martínez Vásquez
-- ============================================================

-- ============================================================
-- CONSULTA 01 | INSERT | Insertar propietario
-- Descripción: Agregar un nuevo propietario
-- ============================================================
INSERT INTO tourism.owners ( 
    first_name,
    last_name,
    company_name,
    email,
    phone,
    tax_id,
    address_line1,
    city,
    state,
    country,
    postal_code
)
VALUES (
    'Ovidio Omar',
    'Martínez vásquez',
    'Innovaciones MO S.A. de C.V.',
    'ovidio.omar.martinez@clases.edu.sv',
    '+503 2641-2025',
    '0614-150389-101-5',
    'Cantón Guachipilín, Km 155 Carretera Ruta Militar',
    'Jocoro',
    'Morazán Sur',
    'El Salvador',
    '03213'
);

-- ============================================================
-- CONSULTA 02 | INSERT | Insertar alojamiento
-- Descripción: Crear alojamiento vinculado a propietario existente
-- ============================================================







