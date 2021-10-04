--date — дата
--average_price — средняя цена одного авокадо
--total_volume — количество проданных авокадо
--plu4046 — количество проданных авокадо PLU* 4046
--plu4225 — количество проданных авокадо PLU 4225
--plu4770 — количество проданных авокадо PLU 4770
--total_bags — всего упаковок
--small_bags — маленькие упаковки
--large_bags — большие
--xlarge_bags — очень большие
--type — обычный или органический
--year — год
--region — город или регион (TotalUS – сразу по США)
--В таблице находятся данные не за каждый день, а за конец каждой недели. Для
--каждой даты есть несколько наблюдений, отличающихся по типу авокадо и
--региону продажи.

--*PLU — код товара (Product Lookup code)

--------------------------------------------------------------------------------

--Task: Посмотреть  сколько авокадо типа organic было продано в целом к концу
--каждой недели (накопительная сумма продаж), начиная с начала периода наблюдений


Solution:

SELECT

    region,
    date,
    total_volume,
    SUM(total_volume) OVER(
    PARTITION BY region
    ORDER BY date ASC)

FROM

(SELECT
    region,
    DATE(date) AS date,
    total_volume,
    SUM(total_volume) OVER(
    PARTITION BY region
    ORDER BY date ASC
    RANGE BETWEEN '7 day' PRECEDING AND '0 days' FOLLOWING) volume
  FROM
    avocado
WHERE
    (region =  'NewYork' OR region = 'LosAngeles') AND type = 'organic'

ORDER BY
    region DESC, date ASC) query_in

ORDER BY
    region DESC, date ASC


--------------------------------------------------------------------------------

--Task: Посмотрим, когда объемы продаж обычных (conventional) авокадо резко падали
--по сравнению с предыдущей неделей. Возьмите данные по США в целом, посчитайте
--разницу между объемом продаж в неделю x (total_volume) и количеством проданных
--авокадо в течение предыдущей недели. Значения запишите в новый столбец week_diff.

--type – тип авокадо (conventional)
--region – регион (TotalUS)
--total_volume – объем продаж за неделю

--Solution:

SELECT

    date,
    type,
    sum_volume - LAG(sum_volume, 1) OVER () week_diff
    -- данные в sum_volume сгруппированы по неделям, поэтому в LAG параметр 1
FROM

(SELECT
    date,
    type,
    SUM(total_volume) AS sum_volume

FROM
    avocado

GROUP BY
    date,
    type
HAVING
    type = 'conventional'

ORDER BY
    date ASC) sum_vol

--------------------------------------------------------------------------------

--Task:

--Посмотрим более подробно на объемы продаж авокадо в Нью-Йорке (NewYork) в 2018
--году. Создайте колонку с разницей объемов продаж за неделю и за неделю до этого
--для каждого типа авокадо. Найдите день, когда продажи авокадо типа organic
--увеличились по сравнению с предыдущей неделей, а conventional – наоборот упали.
--Если таких дней несколько, то укажите их через запятую с пробелом,
--формат – 31/12/2020.


--Solution:

SELECT
    year,
    date,
    type,
    sum_volume - LAG(sum_volume, 1) OVER () week_diff

FROM

(SELECT
    EXTRACT(YEAR FROM date) as year,
    date,
    type,
    SUM(total_volume) AS sum_volume

FROM
    avocado

GROUP BY
    date,
    type,
    region

HAVING
    region = 'NewYork' and DATE(date) > '2018-01-01'

ORDER BY
    date ASC) sum_vol

ORDER BY
    week_diff DESC

-- Дальше визуализирую в Redash: x- date, y - week_diff, group by - type

--------------------------------------------------------------------------------

--Task:

--Посчитать скользящее среднее цены авокадо (average_price) в Нью-Йорке с
--разбивкой по типу авокадо. В качестве окна используйте текущую неделю и
--предыдущие две (в строках содержатся данные за неделю, а не за один день).

--Solution:

SELECT
    DISTINCT date,
    average_price,
    region,
    type,
    AVG(avocado.average_price) OVER(
    ORDER BY date
    ROWS BETWEEN 2 PRECEDING AND 0 FOLLOWING) rolling_price

FROM
    avocado
WHERE
    region = 'NewYork' AND type = 'conventional' AND DATE(date) > '01/04/16'
ORDER BY
    date ASC
