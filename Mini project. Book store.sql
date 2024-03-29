/* Mini project. Book store.

Description of the project: in this project it is necessary to analyze the
assortment of books in the warehouse.

1. Create and fill in 3 tables: books, genre and author.
2. Display titles of books and their authors.
3. Find the title of all books. If the books of the specific author are
currently not in stock - specify Null instead of the book title.
4. Find all genres of books that are not represented in stock.
5. Select novels (selected columns are genre, book, author) sorted by title.
6. Find the amount of books of each author in stock.
Select  authors with the amount of books < 10. Sort the amount
of books in ascending order.
7. Compare the prices of books already in stock and in supply table.
In case the price in the supply table is different from the price in stock
recalculate the price in stock using the formula:

(p1 * a1 + p2 * a2) / (a1 + a2),

where p1 and a1 stand for price and amount in the stock (book table) and
      p2 and a2 stand for price and amount in the supply table.
Increase the quantity of the books in stock by the number of books in the supply
table.  Reset the number of these books in supply table.
8.  Find identical books in the supply and book tables that have the same price,
display their title and author and count the total number of copies of books
in the supply and book tables.
Name the columns Title, Author and Quantity.
9. The list of cities is stored in the city table.
It is necessary to plan an exhibition of each author's books in each city during
2020. Choose the date of the exhibition at random. Create a query that will
display the city, author and date of the exhibition.
The last column is Date.
Sort the query  by city in alphabetical order, and Date in descending order.
10. List in alphabetical order all authors who write in only one genre.
Especially for this task some rows in the table were changed.
11. Select the book ( title, name author , name genre, price, amount) written
in the most popular genres, sorted alphabetically by book title. */


/* Create and fill in the table author */

CREATE TABLE author(
  author_id INT PRIMARY KEY AUTO_INCREMENT,
  name_author VARCHAR(50)
);

INSERT INTO author(
            author_id,
            name_author
          )
VALUES (1, "Булгаков М.А."),
        (2, "Достоевский Ф.М."),
        (3, "Есенин С.А."),
        (4, "Пастернак Б.Л."),
        (5, "Лермонтов М.Ю.");

/* Create and fill in the table genre. */

CREATE TABLE genre(
              genre_id INT PRIMARY KEY AUTO_INCREMENT,
              name_genre VARCHAR(30)
            );
INSERT INTO genre(
            genre_id,
            name_genre
            )
VALUES (1, "Роман"),
       (2, "Поэзия"),
       (3, "Приключения");

/* Create and fill in the table book. */

CREATE TABLE book(
            book_id INT PRIMARY KEY AUTO_INCREMENT,
            title VARCHAR(50),
            author_id INT,
            genre_id INT,
            price DECIMAL(8,2),
            amount INT,
            FOREIGN KEY (author_id) REFERENCES author (author_id),
            FOREIGN KEY (genre_id) REFERENCES genre (genre_id)
          );
INCERT INTO book(
            book_id,
            title,
            author_id,
            genre_id,
            price,
            amount)
VALUES
      (1,	"Мастер и Маргарита",	1, 1, 670.99, 3),
      (2,	"Белая гвардия", 1, 1, 540.50, 5),
      (3,	"Идиот", 2, 1, 460.00, 10),
      (4, "Братья Карамазовы", 2,	1, 799.01, 3),
      (5,	"Игрок", 2,	1, 480.50, 10),
      (6,	"Стихотворения и поэмы", 3,	2, 650.00, 15),
      (7,	"Черный человек",	3, 2,	570.20,	6),
      (8,	"Лирика",	4, 2,	518.99,	2);

/* Display titles of books and their authors. */

SELECT title,
       name_author
FROM
  author INNER JOIN book
ON author.author_id = book.author_id;

/* Select the title, genre and price of the books, which amount is more than 8.
   Sort the result in descending order of price. */

SELECT
  title,
  name_genre,
  price
FROM
  book
INNER JOIN genre
      ON book.genre_id = genre.genre_id
WHERE
  book.amount > 8
ORDER BY
  3 DESC;

/* Select the title of all books. If the books of the specific author are
currently not in stock - specify Null instead of the book title. */

SELECT name_author,
       title
FROM author
     LEFT JOIN book ON author.author_id = book.author_id
ORDER BY
  name_author;

/* Find all genres of books that are not represented in stock. */

SELECT
  name_genre
FROM genre
      LEFT JOIN book ON genre.genre_id = book.genre_id
WHERE
  amount IS NULL;

/* Select novels (selected columns are genre, book, author) sorted by title. */

SELECT
  name_genre,
  title,
  name_author
FROM genre INNER jOIN book ON genre.genre_id = book.genre_id
              INNER JOIN author ON book.author_id = author.author_id
WHERE
  name_genre
LIKE
  "%Роман%"
ORDER BY
  title ASC;

/* Count the amount of books of each author in stock.
Select  authors with the amount of books < 10. Sort the amount
of books in ascending order. */

SELECT
  name_author,
  SUM(book.amount) AS Количество
FROM
  author
    LEFT JOIN book ON author.author_id = book.author_id
GROUP BY
  name_author
HAVING
  Количество < 10
  OR COUNT(title) = 0
ORDER BY
  2;

/* Compare the prices of books already in stock and in supply table.
In case the price in the supply table is different from the price in stock
recalculate the price in stock using the formula:

(p1 * a1 + p2 * a2) / (a1 + a2),

where p1 and a1 stand for price and amount in the stock (book table) and
      p2 and a2 stand for price and amount in the supply table.
Increase the quantity of the books in stock by the number of books in the supply
table.  Reset the number of these books in supply table. */

UPDATE book
    INNER JOIN author ON author.author_id = book.author_id
      INNER JOIN supply ON book.title = supply.title
        and supply.author = author.name_author
SET
    book.price = (book.price * book.amount + supply.price * supply.amount) / (book.amount + supply.amount),
                  book.amount = book.amount + supply.amount, supply.amount = 0
WHERE
    book.title = supply.title
AND
    book.price != supply.price;

/*  Find identical books in the supply and book tables that have the same price,
display their title and author and count the total number of copies of books
in the supply and book tables.
Name the columns Title, Author and Quantity. */

SELECT
    book.title AS Название,
    author AS Автор,
    book.amount + supply.amount AS Количество
FROM
    book
    INNER JOIN author USING(author_id)
    INNER JOIN supply ON book.title = supply.title
WHERE
    supply.price = book.price;

/* The list of cities is stored in the city table.
It is necessary to plan an exhibition of each author's books in each city during
2020. Choose the date of the exhibition at random. Create a query that will
display the city, author and date of the exhibition.
The last column is Date.
Sort the query  by city in alphabetical order, and Date in descending order.  */

SELECT
  name_city,
  name_author,
  DATE_ADD("2020-01-01", INTERVAL FLOOR(RAND() * 365) DAY) AS Дата
FROM
  city,
  author
ORDER BY
  1 ASC,
  3 DESC;

/* List in alphabetical order all authors who write in only one genre.
Especially for this task some rows in the table were changed. */

SELECT
    name_author
FROM
    (SELECT
         name_author,
         COUNT(DISTINCT name_genre)
FROM book
    INNER JOIN author USING(author_id)
    INNER JOIN genre USING(genre_id)
GROUP BY
     name_author
HAVING COUNT(DISTINCT name_genre) = 1) alias_table_name;

/* Select the book ( title, name author , name genre, price, amount) written
in the most popular genres, sorted alphabetically by book title. */

SELECT
    title,
    name_author,
    name_genre,
    price,
    amount
FROM book INNER JOIN author ON book.author_id = author.author_id
            INNER JOIN genre USING(genre_id)
WHERE
    name_genre IN (SELECT name_genre
                   FROM
                   (SELECT name_genre,
                           SUM(amount)
                    FROM
                      book INNER JOIN genre USING(genre_id)
                    GROUP BY
                      genre_id
                    LIMIT 2) alias)

ORDER BY 1;
