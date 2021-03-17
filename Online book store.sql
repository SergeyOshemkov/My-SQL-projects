/* Online book store. Mini project.

Description.

The online store sells books. Each book has a title, written by one author,
belongs to one genre, has a certain price. There are several copies of each
book in stock in the store.

The buyer registers on the website of the online store, fills in his name and
surname, e-mail and city of residence. He can form one or several orders, write
some wishes for each order. Each order includes one or more books, each book
can be ordered in several copies.

Then the order goes through a series of successive stages: paid, packed, handed
over to a courier or transport company for transportation, and finally delivered
to the buyer. The date of each operation is recorded. Standart average delivery
time is known for each city.

Then the order goes through a series of successive stages: paid, packed, handed
over to a courier or transport company for transportation, and finally delivered
to the buyer. The date of each operation is recorded. Standart average delivery
time is known for each city.

At the same time, the store keeps a record of books, when buying, their number
decreases, when the goods arrive, it increases, when the quantity is exhausted,
an order is placed, etc.


1. Select all orders of Pavel Baranov (which books, at what price and in what
quantity he ordered) sorted by order number and book names.
2. Calculate how many times each book was ordered. Find out the author for each
book. Sort the result by the name of authors, and then by title of books.
Name the last column Количество.
3. Find the cities where live the  customers who placed orders in the online store.
Calculate the number of orders for each city.
Information should be structured in descending order by the number of orders,
and then in alphabetical order by city name.
4. Select the id numbers of all paid orders and the date when they were paid.
5. Select information about each order: its number, who has created it (user
surname) and its value (the sum of the products of the number of ordered books
and their prices), sorted by the order number.
6. Select information about each order: its number, who has created it (user
surname) and its value (the sum of the products of the number of ordered books
and their prices), sorted by the order number.
7. Find out all orders and the names of the actual stages in ascending order by
buy_id. Do not include in the query the delivered orders.
The current stage is the stage for which the stage end date is not filled in.
8. The city table contains the number of delivery days to each city (the
"Transportation" stage).
For the orders that have passed the transportation stage, calculate the actual
delivry time in days.
In case the order is delivered with a delay, indicate the number of days of
delay, otherwise indicate 0. Sort the information by the order number.
9. Find out the most popular genre (or genres) by the number of the books sold.
10. Compare the monthly book sales for the current year and the previous one.
Select year, month, and amount of revenue sorted in ascending order of months,
then in ascending order of years. Name the columns: Year, Month, and  Amount.
11. Insert a new person Ilya Popov in the customer table. His email is
popov@test, he lives in Moscow.
12. Create a new order for Ilya Popov. His comment for the order:
"Contact me for shipping."
13. Add order number 5 to the buy_book table. This order must contain 2 copies
of Pasternak's book "Lyrics" and 1 copy of Bulgakov's book "White Guard".
14.  Reduce the amount of books in the stock by books included in the order #5.
15.  Create an invoice (table buy_pay) for payment of order number 5, which
includes the title of books, their author, price, number of ordered books and
cost. Fill in  information in the table sorted by book titles.
16. Create a general invoice (table buy_pay) to pay for order number 5. Include
the order number, the number of books  and the total cost. Use ONE query to solve.
17. Include all the stages from the table step which must go through the order #5.
Fill in with Null the date_step_beg and date_step_end columns of all records.
18. Insert the invoice date 04/12/2020 in the buy_step table for the order #5. */


/* Select all orders of Pavel Baranov (which books, at what price and in what
quantity he ordered) sorted by order number and book names. */

SELECT
    buy.buy_id,
    title, price,
    buy_book.amount
FROM
    client JOIN buy on client.client_id = buy.client_id
              JOIN buy_book on buy.buy_id = buy_book.buy_id
                  JOIN book on book.book_id = buy_book.book_id
WHERE
    name_client = "Баранов Павел"
ORDER BY 1;

/* Calculate how many times each book was ordered. Find out the author for each
book. Sort the result by the name of authors, and then by title of books.
Name the last column Количество.  */

SELECT
    name_author,
    title,
    COUNT(buy_book.amount) AS Количество
FROM author
        JOIN book USING(author_id)
          LEFT JOIN buy_book USING(book_id)
GROUP BY
    name_author,
    title
ORDER BY 1;

/* Find the cities where live the  customers who placed orders in the online store.
Calculate the number of orders for each city.
Information should be structured in descending order by the number of orders,
and then in alphabetical order by city name.  */

SELECT name_city,
       COUNT(buy.client_id) AS Количество
FROM city
         INNER JOIN client ON city.city_id = client.city_id
            INNER JOIN buy USING(client_id)
GROUP BY
         name_city;

/* Select the id numbers of all paid orders and the date when they were paid. */

SELECT
       buy_id,
       date_step_end
FROM
       buy_step
WHERE
       buy_step.step_id = 1
AND
       buy_step.date_step_end IS NOT NULL;

/* Select information about each order: its number, who has created it (user
surname) and its value (the sum of the products of the number of ordered books
and their prices), sorted by the order number.  */

SELECT  buy_id,
        name_client,
        SUM(buy_book.amount * book.price) AS  Стоимость
FROM book
     INNER JOIN buy_book USING(book_id)
        INNER JOIN buy USING(buy_id)
            INNER JOIN client USING(client_id)
GROUP BY
  buy_id,
  name_client
ORDER BY 1;

/* Find out all orders and the names of the actual stages in ascending order by
buy_id. Do not include in the query the delivered orders.
The current stage is the stage for which the stage end date is not filled in. */

SELECT
  buy_id,
  name_step
FROM buy_step
  JOIN step USING (step_id)
WHERE
  date_step_beg IS NOT NULL
  AND
  date_step_end IS NULL
ORDER BY
  buy_id;

/* The city table contains the number of delivery days to each city (the
"Transportation" stage).
For the orders that have passed the transportation stage, calculate the actual
delivry time in days.
In case the order is delivered with a delay, indicate the number of days of
delay, otherwise indicate 0. Sort the information by the order number.   */

SELECT buy_id,
       DATEDIFF(date_step_end, date_step_beg) AS Количество_дней,
       (IF(DATEDIFF(date_step_end, date_step_beg) > days_delivery,
       DATEDIFF(date_step_end, date_step_beg) - days_delivery, 0)) AS Опоздание
FROM city
        INNER JOIN client USING(city_id)
            INNER JOIN buy USING(client_id)
                INNER JOIN buy_step USING(buy_id)
                    INNER JOIN step USING(step_id)
WHERE
    name_step = "Транспортировка"
    AND date_step_end IS NOT Null
ORDER BY 1;

/* Find out the most popular genre (or genres) by the number of the books sold. */

SELECT
    name_genre,
    SUM(buy_book.amount) as Количество
FROM genre
    INNER JOIN book USING(genre_id)
      INNER JOIN buy_book USING(book_id)
GROUP BY
    name_genre
HAVING SUM(buy_book.amount) =
     (SELECT MAX(sum_amount) AS max_sum_amount
      FROM
          (SELECT name_genre,
           SUM(buy_book.amount) AS sum_amount
      FROM genre
           INNER JOIN book USING (genre_id)
           INNER JOIN buy_book USING(book_id)
      GROUP BY name_genre)
      query_in);

/* Compare the monthly book sales for the current year and the previous one.
Select year, month, and amount of revenue sorted in ascending order of months,
then in ascending order of years. Name the columns: Year, Month, and  Amount. */

SELECT YEAR(date_step_end) AS Год,
            MONTHNAME(date_step_end) AS Месяц,
            SUM(price * buy_book.amount) AS Сумма
FROM
    book
    INNER JOIN buy_book USING(book_id)
        INNER JOIN buy USING(buy_id)
            INNER JOIN buy_step USING(buy_id)
                INNER JOIN step USING(step_id)
WHERE
    date_step_end IS NOT Null AND name_step = "Оплата"
GROUP BY
    Год,
    Месяц
UNION
SELECT YEAR(buy_archive.date_payment) AS Год,
            MONTHNAME(buy_archive.date_payment) AS Месяц,
            SUM(buy_archive.price * buy_archive.amount) AS Сумма
FROM
    buy_archive
GROUP BY
    Год, Месяц
ORDER BY
    2, 1;

/* Insert a new person Ilya Popov in the customer table. His email is
popov@test, he lives in Moscow. */

INSERT INTO
    client(name_client,
           city_id,
           email)
SELECT
    'Попов Илья',
     city_id,
    'popov@test'
FROM city
WHERE
    city_id = 1;


/* Create a new order for Ilya Popov. His comment for the order:
"Contact me for shipping." */

INSERT INTO
    buy(buy_description,
        client_id)
SELECT
    "Связаться со мной по вопросу доставки", client_id
FROM
    client
WHERE
    name_client = "Попов Илья";

/* Add order number 5 to the buy_book table. This order must contain 2 copies
of Pasternak's book "Lyrics" and 1 copy of Bulgakov's book "White Guard".   */

INSERT INTO buy_book(buy_id,
                     book_id,
                     buy_book.amount)
SELECT 5,
       book_id,
       2
FROM buy_book
        INNER JOIN book USING(book_id)
        INNER JOIN author USING(author_id)
WHERE
    title = "Лирика";
INSERT INTO
    buy_book(buy_id,
             book_id,
             buy_book.amount)
SELECT 5,
       book_id,
       1
FROM buy_book
        INNER JOIN book USING(book_id)
          INNER JOIN author USING(author_id)
WHERE
    title = "Белая гвардия";


/* Reduce the amount of books in the stock by books included in the order #5.*/

UPDATE book
       INNER JOIN buy_book USING(book_id)
SET
    book.amount = book.amount - buy_book.amount
WHERE
    buy_id = 5;

/* Create an invoice (table buy_pay) for payment of order number 5, which
includes the title of books, their author, price, number of ordered books and
cost. Fill in  information in the table sorted by book titles.  */

CREATE TABLE
    buy_pay AS
SELECT
    title,
    name_author,
    price,
    buy_book.amount,
    price * buy_book.amount AS Стоимость
FROM book
    INNER JOIN author ON book.author_id = author.author_id
      INNER JOIN buy_book ON buy_book.book_id = book.book_id
WHERE
    buy_id = 5
ORDER BY 1;

/* Create a general invoice (table buy_pay) to pay for order number 5. Include
the order number, the number of books  and the total cost. Use ONE query to solve. */

CREATE TABLE
    buy_pay AS
SELECT
    buy_id,
    SUM(buy_book.amount) AS Количество,
    SUM(book.price * buy_book.amount) AS Итого
FROM book
    INNER JOIN buy_book USING(book_id)
GROUP BY
    buy_id
HAVING
    buy_id = 5;

/* Include all the stages from the table step which must go through the order #5.
Fill in with Null the date_step_beg and date_step_end columns of all records. */

INSERT INTO
    buy_step(buy_id,
             step_id)
SELECT
    buy_id,
    step_id
FROM buy
    CROSS JOIN step
WHERE
    buy_id = 5;

/* Insert the invoice date 04/12/2020 in the buy_step table for the order #5. */

UPDATE
    buy_step
SET
    date_step_beg = "2020-04-12"
WHERE
    buy_id = 5
    AND
    step_id = 1;
