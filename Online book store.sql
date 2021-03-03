/* Online book store. Mini project.  */


/*     */

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

/*   */

SELECT
    name_author,
    title,
    COUNT(buy_book.amount) AS Количество

FROM

    author JOIN book USING(author_id)
    LEFT JOIN buy_book USING(book_id)

GROUP BY
    name_author,
    title
ORDER BY 1;

/*   */

SELECT name_city,
       COUNT(buy.client_id) AS Количество

FROM city
         INNER JOIN client ON city.city_id = client.city_id
         INNER JOIN buy USING(client_id)

GROUP BY
         name_city;

/* */

SELECT
       buy_id,
       date_step_end
FROM
       buy_step
WHERE
       buy_step.step_id = 1
AND
       buy_step.date_step_end IS NOT NULL;


/*   */


SELECT  buy_id,
        name_client,
        SUM(buy_book.amount * book.price) AS  Стоимость

FROM book

     INNER JOIN buy_book USING(book_id)
     INNER JOIN buy USING(buy_id)
     INNER JOIN client USING(client_id)

GROUP BY buy_id, name_client

ORDER BY 1;


/*   */


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


  /*    */

  SELECT
      name_client
  FROM author
      INNER JOIN book USING(author_id)
      INNER JOIN buy_book USING(book_id)
      INNER JOIN buy USING(buy_id)
      INNER JOIN client USING(client_id)
  WHERE name_author = "Достоевский Ф.М.";


  /*   */

  SELECT name_genre, SUM(buy_book.amount) as Количество
FROM genre INNER JOIN book
     on genre.genre_id = book.genre_id
     INNER JOIN buy_book
     ON book.book_id = buy_book.book_id
GROUP BY name_genre
HAVING SUM(buy_book.amount) =
     (SELECT MAX(sum_amount) AS max_sum_amount
      FROM (SELECT genre.genre_id, SUM(buy_book.amount) AS sum_amount
            FROM buy_book INNER JOIN book
            ON buy_book.book_id=book.book_id
                          INNER JOIN genre
                          ON book.genre_id = genre.genre_id
            GROUP  BY genre.genre_id) query_in;
