--Имеются следующие таблицы:

--1. listings – информация о жилье, включая полные описания, характеристики и
--средние оценки в отзывах; поскольку столбцов очень много, нужные перечислены в
--текстах самих задач.

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
--Task: в какой месяц и год зарегистрировалось наибольшее количество новых хостов.
--В качестве ответа введите дату следующего формата: 2010-12

--Solution:

SELECT
    COUNT(DISTINCT host_id) AS num_reistrations,
    toStartOfMonth(toDateOrNull(host_since)) AS Date

FROM
    listings

GROUP BY
    Date

ORDER BY
    num_reistrations DESC

LIMIT 10

--------------------------------------------------------------------------------

--Task:

--Сгруппируйте данные из listings по хозяевам (host_id) и посчитайте, какую цену
--за ночь в среднем каждый из них устанавливает (у одного хоста может быть
--несколько объявлений). Идентификаторы сдаваемого жилья объедините в отдельный
--массив. Таблицу отсортируйте по убыванию средней цены и убыванию host_id (в таком
--порядке). В качестве ответа укажите первое значение в полученном массиве,
--состоящее из более чем двух id.

--Solution:

SELECT
    host_id,
    AVG(correct_price) as average_price,
    id_apartments_list

FROM

(SELECT
    host_id,
    groupArray(id) AS id_apartments_list,
    toFloat32OrZero(replaceAll(replaceAll(price,'$', ''), ',', '')) AS correct_price

FROM listings

GROUP BY host_id,
         price) host_id_and_correct_price

GROUP BY
    host_id,
    id_apartments_list

ORDER BY
    average_price DESC,
    host_id DESC

LIMIT 100



--------------------------------------------------------------------------------
--Task: разницу между максимальной и минимальной установленной ценой у каждого
--хозяина. В качестве ответа укажите идентификатор хоста, у которого разница
--оказалась наибольшей.

--Solution:

SELECT
    host_id,
    MIN(toFloat32OrZero(replaceAll(replaceAll(price,'$', ''), ',', ''))) AS min_correct_price,
    MAX(toFloat32OrZero(replaceAll(replaceAll(price,'$', ''), ',', ''))) AS max_correct_price,
    max_correct_price - min_correct_price AS difference

FROM listings

GROUP BY
    host_id

ORDER BY
    difference DESC

LIMIT 1


--------------------------------------------------------------------------------
--Task:

--Сгруппировать данные по типу жилья и выведите средние значения цены за ночь,
--размера депозита и цены уборки. Для какого типа жилья среднее значение залога
--наибольшее?

--Solution:

SELECT
    host_id,
    room_type,
    AVG(toFloat32OrZero(replaceAll(replaceAll(price,'$', ''), ',', ''))) AS correct_avg_price,
    AVG(toFloat32OrZero(replaceAll(replaceAll(security_deposit,'$', ''), ',', ''))) AS correct_avg_security_deposit,
    AVG(toFloat32OrZero(replaceAll(replaceAll(cleaning_fee,'$', ''), ',', ''))) AS correctavg_cleaning_fee

FROM
    listings

GROUP BY
    host_id,
    room_type

ORDER BY
    correct_avg_security_deposit DESC

LIMIT 3

--------------------------------------------------------------------------------

-- Task:

-- Посчитать среднюю цену за ночь в каждом районе. В качестве ответа введите
-- название места, где средняя стоимость за ночь ниже всего.

-- Solution:

SELECT
    neighbourhood_cleansed,
    AVG(toFloat32OrZero(replaceAll(replaceAll(price,'$', ''), ',', ''))) AS correct_avg_price

FROM
    listings

GROUP BY
    neighbourhood_cleansed

ORDER BY
    correct_avg_price ASC

LIMIT 1

--------------------------------------------------------------------------------

-- Task: В каких районах Берлина средняя площадь жилья, которое сдаётся целиком,
-- является наибольшей? Отсортируйте по среднему и выберите топ-3.

-- Solution:

SELECT
    neighbourhood_cleansed,
    AVG(toFloat32OrNull(square_feet)) AS average_square_feet

FROM
    listings

GROUP BY
    neighbourhood_cleansed

HAVING
    room_type = 'Entire home/apt'

ORDER BY
    average_square_feet DESC

LIMIT 3


--------------------------------------------------------------------------------

-- Task: Найти сдаваемую комнату, которая расположена ближе всего к центру
-- города и указать ее id.

Solution:

SELECT
    id,
    room_type,
    geoDistance(13.4050, 52.5200, toFloat64OrNull(longitude), toFloat64OrNull(latitude)) AS distance

FROM
    listings

WHERE
    room_type = 'Private room'

ORDER BY
    distance ASC

LIMIT 10

--------------------------------------------------------------------------------

-- Task:Посмотрим на среднюю частоту ответа среди хозяев (f) и суперхозяев (t).
-- Значения частоты ответа хранятся как строки и включают значок %, который
-- необходимо заменить на пустоту (''). После этого приведите столбец к нужному
-- типу данных с помощью toInt32OrNull() и посчитайте среднюю частоту отклика в
-- разбивке по тому, является ли хост суперхозяином или нет. В качестве ответа
-- укажите наибольшее среднее.

-- Solution:

SELECT
  host_is_superhost,
  AVG(host_response_rate) AS average_response_rate

FROM

(SELECT
    DISTINCT host_id,
    host_is_superhost,
    toInt32OrNull(replaceAll(host_response_rate, '%', '')) AS host_response_rate

FROM
    listings) query_in

GROUP BY
    host_is_superhost


LIMIT 10
