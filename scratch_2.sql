-- 1
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    employee_id INT,
    sale_amount NUMERIC
);

INSERT INTO sales (employee_id, sale_amount)
VALUES
    (1, 100),
    (1, 200),
    (2, 150),
    (2, 300),                  -- PARTITION : אומר איך לחלק את הקבוצות של  column_name .
                               -- ובנוסף יוצר חישוב נפרד לכל קבוצה .
    (1, 50),
    (2, 100);

SELECT
    employee_id,
    sale_amount,
    SUM(sale_amount) OVER (PARTITION BY employee_id ORDER BY id) AS running_total
FROM sales;


-- 2

CREATE TABLE products (                    -- ->  שולף ערך מתוך אובייקט JSON או מערךבומשאיר אותו ב-. לרוב משתמשים בזה אם רוצים להמשיך לעבוד עם הערך אבל כנתון JSON
    id SERIAL PRIMARY KEY,
    details JSONB                          -- ->> שולף ערך מתוך אובייקט JSON או מערך , ומחזיר אותו כמחרוזת, ומשתמשים בזה שרוצים לקבל את המערך שצורת מחרוזת.
);

INSERT INTO products (details)
VALUES
    ('{"name": "Laptop", "price": 1200, "features": {"RAM": "16GB", "Storage": "512GB"}}'),
    ('{"name": "Phone", "price": 800, "features": {"RAM": "8GB", "Storage": "256GB"}}');

-- Query specific keys in the JSON
SELECT
    details->>'name' AS product_name,
    details->'features'->>'RAM' AS ram
FROM products;


-- 3

CREATE TABLE array_example (
    id SERIAL PRIMARY KEY,
    numbers INT[]
);
       -- הקוד מחזיר מחזירה עמודה אחת בשם first_element, שבה האיבר הראשון של המערך מכל שורה
      -- והדבר השני שהקוד מחזיר זה אם המספר 3 נמצא בתוך המערך השאליתה תחזיר את המערך במידה ולא נמצא היא לא תחזיר



INSERT INTO array_example (numbers)
VALUES
    ('{1, 2, 3}'),
    ('{4, 5, 6}');

-- Query specific array elements
SELECT numbers[1] AS first_element FROM array_example;

-- Search for rows containing a specific number
SELECT * FROM array_example WHERE 3 = ANY(numbers);

-- 4

-- Automatically calculate column values
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    price NUMERIC,                                          -- משמעות ALWAYS GENERATED הוא  להגדרת עמודה בטבלה כעמודה מחושבת או כעמודת זהות
    tax NUMERIC GENERATED ALWAYS AS (price * 0.2) STORED    --  ALWAYS GENERATED ממוחשבת בצורה אוטומטית עם נוסחא price * 0.2  הערך של העמודה עם
);

INSERT INTO products (price) VALUES (100), (200);

-- Tax is automatically calculated
SELECT * FROM products;