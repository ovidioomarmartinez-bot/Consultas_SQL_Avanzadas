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
    'Martínez Vásquez',
    'Desafíos Superados AE S.A. de C.V.',
    'ovidio.omar.martinez@clases.edu.sv',
    '+503 2641-2025',
    '0614-150389-101-5',
    'Cantón Guachipilin',
    'Jocoro',
    'Morazán Sur',
    'El Salvador',
    '03213'
);

-- ============================================================
-- CONSULTA 02 | INSERT | Insertar alojamiento
-- Descripción: Crear alojamiento vinculado a propietario existente
-- ============================================================
INSERT INTO tourism.accommodations (
    owner_id,
    accommodation_type_id,
    location_id,
    name,
    description,
    max_guests,
    bedroom_count,
    bathroom_count,
    base_price_per_night,
    currency_code,
    check_in_time,
    check_out_time,
    is_active
)
VALUES (
    1,                         
    2,                          
    3,                          
    'Suite Vista al Volcán',
    'Acogedor apartamento con vista panorámica al Lago de Coatepeque.'
    || 'Incluye cocina equipada, WiFi de alta velocidad y parqueo privado.',
    4,
    2,
    1,
    90.00,
    'USD',
    '15:00',
    '11:00',
    TRUE
);

-- ============================================================
-- CONSULTA 03 | INSERT | Huésped y reserva
-- Descripción: Registrar huésped y su reserva en una transacción
-- ============================================================
BEGIN;
 
INSERT INTO tourism.guests (
    first_name,
    last_name,
    email,
    phone,
    date_of_birth,
    nationality,
    passport_number,
    emergency_contact_name,
    emergency_contact_phone
)
VALUES (
    'Olga Patricia',
    'Benítez López',
    'nadaimposible12@gmail.com',
    '+52 55 8901-2345',
    '1992-03-18',
    'Mexican',
    'G12345678',
    'Brayan Martínez',
    '+52 55 8901-9999'
);

INSERT INTO tourism.bookings (
    guest_id,
    accommodation_id,
    booking_status_id,
    check_in_date,
    check_out_date,
    adult_count,
    child_count,
    subtotal_amount,
    tax_amount,
    discount_amount,
    total_amount,
    special_requests,
    booking_reference
)
VALUES (
    currval(pg_get_serial_sequence('tourism.guests', 'guest_id')),
    1,                          
    1,                          
    '2025-07-15',
    '2025-07-20',
    2,
    0,
    425.00,                     -- 5 noches × $85.00
    55.25,                      -- 13% IVA
    0.00,
    480.25,
    'Preferimos habitación alejada de la calle. Llegamos tarde en la noche.',
    'BK-2025-00147'
);
 
COMMIT;

-- ============================================================
-- CONSULTA 04 | INSERT | Insertar pago
-- Descripción: Registrar pago de una reserva existente
-- ============================================================
INSERT INTO tourism.payments (
    booking_id,
    amount,
    payment_method,
    payment_status,
    transaction_reference,
    notes
)
VALUES (
    1,                          
    480.25,
    'credit_card',
    'completed',
    'TXN-20250715-8872634',
    'Pago completo realizado al momento de la reserva vía Visa terminación 4821'
);

-- ============================================================
-- CONSULTA 05 | SELECT | Alojamientos activos
-- Descripción: Filtrar solo alojamientos con is_active = TRUE
-- ============================================================
SELECT
    a.accommodation_id,
    a.name AS accommodation,
    at2.type_name AS type,
    a.base_price_per_night,
    a.max_guests,
    a.bedroom_count,
    a.bathroom_count,
    o.first_name || ' ' || o.last_name AS owner
FROM tourism.accommodations    a
INNER JOIN tourism.accommodation_types  at2 ON a.accommodation_type_id = at2.accommodation_type_id
INNER JOIN tourism.owners               o   ON a.owner_id = o.owner_id
WHERE a.is_active = TRUE
ORDER BY a.base_price_per_night DESC;

-- ============================================================
-- CONSULTA 06 | SELECT | Huéspedes por país
-- Descripción: Filtrar huéspedes por nacionalidad
-- ============================================================
SELECT
    guest_id,
    first_name || ' ' || last_name AS full_name,
    email,
    phone,
    nationality,
    passport_number,
    created_at::DATE     AS registered_on
FROM tourism.guests
WHERE nationality = 'Mexican'
ORDER BY last_name, first_name;

-- ============================================================
-- CONSULTA 07 | SELECT | Reservas por fechas
-- Descripción: Uso de BETWEEN para rango de fechas de check-in
-- ============================================================
SELECT
    b.booking_id,
    b.booking_reference,
    g.first_name || ' ' || g.last_name AS guest,
    a.name AS accommodation,
    b.check_in_date,
    b.check_out_date,
    b.total_nights,
    bs.status_name AS status,
    b.total_amount
FROM tourism.bookings b
INNER JOIN tourism.guests  g ON b.guest_id         = g.guest_id
INNER JOIN tourism.accommodations a ON b.accommodation_id = a.accommodation_id
INNER JOIN tourism.booking_statuses bs ON b.booking_status_id = bs.booking_status_id
WHERE b.check_in_date BETWEEN '2025-07-01' AND '2025-07-31'
ORDER BY b.check_in_date;

-- ============================================================
-- CONSULTA 08 | UPDATE | Actualizar precio
-- Descripción: Modificar precio base por noche de un alojamiento
-- ============================================================
UPDATE tourism.accommodations
SET
    base_price_per_night = 95.00,
    updated_at = CURRENT_TIMESTAMP
WHERE accommodation_id = 1;

-- ============================================================
-- CONSULTA 09 | UPDATE | Estado reserva
-- Descripción: Cambiar el estado de una reserva existente
-- ============================================================
UPDATE tourism.bookings
SET
    booking_status_id = 3,
    updated_at = CURRENT_TIMESTAMP
WHERE booking_id = 3;

-- ============================================================
-- CONSULTA 10 | DELETE | Eliminar reseña
-- Descripción: DELETE WHERE con condición sobre review_id
-- ============================================================
DELETE FROM tourism.reviews
WHERE review_id = 5;

-- ============================================================
-- CONSULTA 11 | JOIN | Reservas + huésped
-- Descripción: INNER JOIN entre bookings y guests
-- ============================================================
SELECT
    b.booking_id,
    b.booking_reference,
    g.first_name AS guest_first_name,
    g.last_name AS guest_last_name,
    g.nationality,
    b.check_in_date,
    b.check_out_date,
    b.total_nights,
    b.total_amount
FROM tourism.bookings b
INNER JOIN tourism.guests g ON b.guest_id = g.guest_id
ORDER BY b.booking_id;

-- ============================================================
-- CONSULTA 12 | JOIN | Alojamiento completo
-- Descripción: INNER JOIN múltiple (accommodations + type + owner + location)
-- ============================================================
SELECT
    a.accommodation_id,
    a.name AS accommodation,
    at2.type_name  AS type,
    o.first_name || ' ' || o.last_name  AS owner,
    o.email  AS owner_email,
    l.city,
    l.state,
    l.country,
    a.base_price_per_night,
    a.max_guests,
    a.is_active
FROM tourism.accommodations  a
INNER JOIN tourism.accommodation_types  at2 ON a.accommodation_type_id = at2.accommodation_type_id
INNER JOIN tourism.owners  o   ON a.owner_id = o.owner_id
INNER JOIN tourism.locations  l   ON a.location_id = l.location_id
ORDER BY a.accommodation_id;

-- ============================================================
-- CONSULTA 13 | JOIN | Pagos + reservas
-- Descripción: JOIN combinado (payments → bookings → guests → accommodations)
-- ============================================================
SELECT
    p.payment_id,
    p.payment_date,
    p.amount,
    p.payment_method,
    p.payment_status,
    p.transaction_reference,
    b.booking_id,
    b.booking_reference,
    b.check_in_date,
    b.check_out_date,
    g.first_name || ' ' || g.last_name AS guest,
    a.name AS accommodation
FROM tourism.payments p
INNER JOIN tourism.bookings b ON p.booking_id = b.booking_id
INNER JOIN tourism.guests g ON b.guest_id = g.guest_id
INNER JOIN tourism.accommodations a ON b.accommodation_id  = a.accommodation_id
ORDER BY p.payment_date DESC;

-- ============================================================
-- CONSULTA 14 | LEFT JOIN | Sin reseñas
-- Descripción: Alojamientos que no tienen ninguna reseña (incluye NULLs)
-- ============================================================
SELECT
    a.accommodation_id,
    a.name  AS accommodation,
    r.review_id,
    r.rating,
    r.review_title
FROM tourism.accommodations a
LEFT JOIN tourism.reviews r ON a.accommodation_id = r.accommodation_id
WHERE r.review_id IS NULL
ORDER BY a.accommodation_id;

-- ============================================================
-- CONSULTA 15 | LEFT JOIN | Sin reservas
-- Descripción: Huéspedes que nunca han hecho una reserva (filtrar NULLs)
-- ============================================================
SELECT
    g.guest_id,
    g.first_name || ' ' || g.last_name AS guest,
    g.email,
    g.nationality,
    b.booking_id
FROM tourism.guests g
LEFT JOIN tourism.bookings b ON g.guest_id = b.guest_id
WHERE b.booking_id IS NULL
ORDER BY g.guest_id;

-- ============================================================
-- CONSULTA 16 | AGG | Total ingresos
-- Descripción: SUM del monto total de pagos con estado 'completed'
-- ============================================================
SELECT
    SUM(amount) AS total_revenue,
    COUNT(*)  AS total_payments,
    ROUND(AVG(amount), 2)  AS avg_payment,
    MIN(amount) AS min_payment,
    MAX(amount) AS max_payment
FROM tourism.payments
WHERE payment_status = 'completed';

-- ============================================================
-- CONSULTA 17 | AGG | Promedio rating
-- Descripción: AVG del rating de reviews agrupado por alojamiento
-- ============================================================
SELECT
    a.accommodation_id,
    a.name AS accommodation,
    ROUND(AVG(r.rating), 2) AS avg_rating,
    COUNT(r.review_id) AS total_reviews
FROM tourism.accommodations a
INNER JOIN tourism.reviews r ON a.accommodation_id = r.accommodation_id
GROUP BY a.accommodation_id, a.name
ORDER BY avg_rating DESC;

-- ============================================================
-- CONSULTA 18 | AGG | Top alojamientos
-- Descripción: COUNT + LIMIT — top 5 alojamientos con más reservas
-- ============================================================
SELECT
    a.accommodation_id,
    a.name AS accommodation,
    COUNT(b.booking_id) AS total_bookings
FROM tourism.accommodations a
INNER JOIN tourism.bookings b ON a.accommodation_id = b.accommodation_id
GROUP BY a.accommodation_id, a.name
ORDER BY total_bookings DESC
LIMIT 5;

-- ============================================================
-- CONSULTA 19 | HAVING | Más de 3 reservas
-- Descripción: GROUP BY + HAVING — alojamientos con más de 3 reservas
-- ============================================================
SELECT
    a.accommodation_id,
    a.name AS accommodation,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_amount) AS total_revenue
FROM tourism.accommodations a
INNER JOIN tourism.bookings b ON a.accommodation_id = b.accommodation_id
GROUP BY a.accommodation_id, a.name
HAVING COUNT(b.booking_id) > 3
ORDER BY total_bookings DESC;

-- ============================================================
-- CONSULTA 20 | Subconsulta | Alojamiento más caro
-- Descripción: Subquery para encontrar el alojamiento con mayor
--              precio base por noche entre los activos
-- ============================================================
SELECT
    a.accommodation_id,
    a.name AS accommodation,
    a.base_price_per_night,
    o.first_name || ' ' || o.last_name AS owner,
    at2.type_name AS type,
    l.city,
    l.country
FROM tourism.accommodations a
INNER JOIN tourism.owners o ON a.owner_id = o.owner_id
INNER JOIN tourism.accommodation_types  at2 ON a.accommodation_type_id = at2.accommodation_type_id
INNER JOIN tourism.locations l  ON a.location_id = l.location_id
WHERE a.base_price_per_night = (
    SELECT MAX(base_price_per_night)
    FROM tourism.accommodations
    WHERE is_active = TRUE
);
