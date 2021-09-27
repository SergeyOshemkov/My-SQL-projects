--Имеются следующие таблицы:

--1. listings – информация о жилье, включая полные описания, характеристики и
--средние оценки в отзывах; поскольку столбцов очень много, нужные перечислены в
--текстах самих задач

--2. calendar_summary – информация о доступности и цене того или иного жилья по дням

--listing_id – идентификатор жилья (объявления)
--date – дата
--available – доступность жилья в данный день (t/f)
--price – цена за ночь
--3. reviews – отзывы

--listing_id –  идентификатор жилья
--id – id отзыва
--date – дата отзыва
--reviewer_id – id ревьюера (автора отзыва)
--reviewer_name – имя автора
--comments – сам отзыв

--------------------------------------------------------------------------------

-- Task: Сначала оставьте только те объявления, где оценка на основе отзывов выше
-- среднего, а число отзывов в месяц составляет строго меньше трёх. Затем
-- отсортируйте по убыванию две колонки: сначала по числу отзывов в месяц, потом по
-- оценке. В качестве ответа укажите id объявления из первой строки.


-- Solution:

SELECT
    id,
    toFloat32OrZero(review_scores_rating) AS review_scores_rating,
    reviews_per_month -- оценка на основе отзывов

FROM
    listings

WHERE
    review_scores_rating >

(SELECT
    AVG(toFloat32OrZero(review_scores_rating))
 FROM
    listings) AND reviews_per_month < 3

ORDER BY
    reviews_per_month DESC,
    review_scores_rating DESC

LIMIT 10

--------------------------------------------------------------------------------

--Task: Посчитайте среднее расстояние до центра города и выведите идентификаторы
--объявлений о сдаче отдельных комнат, для которых расстояние оказалось меньше
--среднего. Результат отсортируйте по убыванию, тем самым выбрав комнату, которая
--является наиболее удаленной от центра, но при этом расположена ближе, чем
--остальные комнаты в среднем.
--Указать идентификатор хозяина (host_id), сдающего данную комнату.

-- Solution:

SELECT
       host_id,
       id,
       geoDistance(13.4050, 52.5200, toFloat32OrZero(longitude), toFloat32OrZero(latitude)) AS distance

FROM
    listings

WHERE
    distance <
    (SELECT
       AVG(geoDistance(13.4050, 52.5200, toFloat32OrZero(longitude), toFloat32OrZero(latitude))) AS avg_distance_from_center

    FROM listings
    WHERE room_type = 'Private room')

GROUP BY
    host_id,
    id,
    distance

ORDER BY
    distance DESC

LIMIT 1

--------------------------------------------------------------------------------

--Task:
--Представим, что вы планируете снять жилье в Берлине на 7 дней, используя более
--хитрые фильтры, чем предлагаются на сайте.

--Отберите объявления из таблицы listings, которые:

--находятся на расстоянии от центра меньше среднего,
--обойдутся дешевле 100$ в день (price с учетом cleaning_fee, который добавляется
--к общей сумме за неделю, т.е его нужно делить на кол-во дней),
--имеют последние отзывы (last_review), начиная с 1 сентября 2018 года,
--имеют WiFi в списке удобств (amenities).

--Отсортировать полученные значения по убыванию review_scores_rating и в качестве
--ответа укажите host_id из первой строки.


-- Solution:

SELECT
    host_id,
    toFloat32OrNull(review_scores_rating) AS review_scores_rating,
    geoDistance(13.4050, 52.5200, toFloat32OrZero(longitude), toFloat32OrZero(latitude)) AS distance,
    -- здесь очищенная от символов цена с учетом cleaning_fee
    toFloat32OrZero(replaceAll(price, '$', '')) + toFloat32OrZero(replaceAll(cleaning_fee, '$','')) /7 AS price,
    -- здесь может быть тонкость Zero or NULL:
    toDateOrNull(last_review) AS date,
    multiSearchAnyCaseInsensitive(amenities, ['wifi']) AS wifi

FROM
    listings
-- здесь решил вопрос расстоянием от центра:

WHERE
    distance <
    (SELECT
       AVG(geoDistance(13.4050, 52.5200, toFloat32OrZero(longitude), toFloat32OrZero(latitude))) AS avg_distance_from_center
       FROM listings)

-- и с датой и wifi и ценой:

AND
    date >= DATE(2018-09-01)
AND
    wifi = 1
AND
    price < 100

ORDER BY
    review_scores_rating DESC

LIMIT 1

--------------------------------------------------------------------------------

--Task: разделите всех покупателей на сегменты:

--А — средний чек покупателя менее 5 ₽
--B — средний чек покупателя от 5-9 ₽
--C — средний чек покупателя от 10-19 ₽
--D — средний чек покупателя от 20 ₽
--Отсортируйте результирующую таблицу по возрастанию UserID и укажите сегмент четвертого пользователя.


--Solution:

SELECT
    UserID,
    CASE
        WHEN sum < 5 THEN 'A'
        WHEN sum >= 5 AND sum <= 9 THEN 'B'
        WHEN sum > 9 AND sum <= 19 THEN 'C'
        WHEN sum >= 20 THEN 'D'

    END AS segment

FROM

(SELECT UserID,
       AVG(Rub) AS sum
FROM
    checks

GROUP BY
    UserID)

ORDER BY
    UserID ASC

LIMIT 4

--------------------------------------------------------------------------------

--Task:

--в выборе жилья нас интересует только два параметра: наличие кухни (kitchen) и
--гибкой системы отмены (flexible), причем первый в приоритете.

--Создайте с помощью оператора CASE колонку с обозначением группы, в которую
--попадает жилье из таблицы listings:

--'good', если в удобствах (amenities) присутствует кухня и система отмены
--(cancellation_policy) гибкая
--'ok', если в удобствах есть кухня, но система отмены не гибкая
--'not ok' во всех остальных случаях
--Результат отсортируйте по новой колонке по возрастанию, установите ограничение
--в 5 строк, в качестве ответа укажите host_id первой строки.

--Solution:

SELECT
    host_id,
    CASE
        WHEN multiSearchAnyCaseInsensitive(amenities, ['kitchen']) AND cancellation_policy = 'flexible' THEN 'good'
        WHEN multiSearchAnyCaseInsensitive(amenities, ['kitchen']) AND cancellation_policy != 'flexible' THEN 'ok'
        ELSE 'not ok'
    END AS segment

FROM
    listings

ORDER BY
    segment ASC
LIMIT 5

--------------------------------------------------------------------------------

--Task:

--найдем в таблице calendar_summary те доступные (available='t') объявления, у
--которых число отзывов от уникальных пользователей в таблице reviews выше среднего.

--Для этого с помощью конструкции WITH посчитайте среднее число уникальных
--reviewer_id из таблицы reviews на каждое жильё, потом проведите джойн таблиц
--calendar_summary и reviews по полю listing_id (при этом из таблицы calendar_summary
--должны быть отобраны уникальные listing_id, отфильтрованные по правилу
--available='t'). Результат отфильтруйте так, чтобы остались только записи, у
--которых число отзывов от уникальных людей выше среднего.

--Отсортируйте результат по возрастанию listing_id и в качестве ответа впишите
--количество отзывов от уникальных пользователей из первой строки.


--Solution:

--------------------------------------------------------------------------------

WITH(

SELECT
    AVG(distinct_rev) AS average_by_listing_id

FROM

(SELECT
    (listing_id),
    COUNT(DISTINCT reviewer_id) AS distinct_rev
FROM
    reviews
GROUP BY listing_id)) AS average

--------------------------------------------------------------------------------

SELECT
    listing_id,
    COUNT(listing_id) AS num_listing_id

FROM

(SELECT *

FROM

reviews

INNER JOIN

(SELECT -- здесь готовлю calendar_summary для merge

    DISTINCT listing_id

FROM
    calendar_summary
WHERE
    available = 't') query_in

USING
    listing_id)

GROUP BY
    listing_id

HAVING num_listing_id > average

ORDER BY
    listing_id ASC

LIMIT 1
