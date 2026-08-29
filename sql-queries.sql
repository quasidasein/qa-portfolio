-- ============================================================
-- 1. Описание: Найти клиентов, которые совершили более одного
--    завершенного заказа, и посчитать общую сумму этих заказов.
--    (Демонстрация INNER JOIN, GROUP BY и агрегации с HAVING).
-- ============================================================

SELECT
    customers.name,
    COUNT(*) AS completed_orders,
    SUM(orders.amount) AS total_amount
FROM customers
INNER JOIN orders
    ON customers.id = orders.customer_id
WHERE orders.status = 'completed'
GROUP BY customers.name
HAVING COUNT(*) >= 2
   AND SUM(orders.amount) > 1000;

-- ============================================================
-- 2. Описание: Найти города, в которых минимум два разных клиента
--    совершили завершенные заказы.
--    (Демонстрация работы с уникальными значениями DISTINCT).
-- ============================================================

SELECT
    users.city,
    COUNT(DISTINCT users.id) AS users_count,
    COUNT(*) AS completed_orders,
    SUM(orders.amount) AS total_amount
FROM users
INNER JOIN orders
    ON users.id = orders.user_id
WHERE orders.status = 'completed'
GROUP BY users.city
HAVING COUNT(DISTINCT users.id) >= 2;

-- ============================================================
-- 3. Описание: Найти всех клиентов, у которых нет ни одного заказа.
--    Классический QA-сценарий для проверки БД на наличие
--    осиротевших (orphaned) записей.
--    (Демонстрация LEFT JOIN и фильтрации по IS NULL).
-- ============================================================

SELECT
    customers.id,
    customers.name,
    customers.city
FROM customers
LEFT JOIN orders
    ON customers.id = orders.customer_id
WHERE orders.id IS NULL;

-- ============================================================
-- 4. Описание: Найти клиентов, сумма заказов которых выше 
--    средней суммы заказа по всей таблице.
--    (Демонстрация вложенных подзапросов SUBQUERY).
-- ============================================================

SELECT
    customers.name,
    SUM(orders.amount) AS total_amount
FROM customers
INNER JOIN orders
    ON customers.id = orders.customer_id
GROUP BY customers.id, customers.name
HAVING SUM(orders.amount) > (
    SELECT AVG(amount)
    FROM orders
);
