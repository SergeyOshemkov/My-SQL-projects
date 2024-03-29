/* Mini project. Business trips of employees.

Description.

The trip table, provides information on business trips of employees of a certain
organization (the name of the employee, the city where he went, the amount of
daily allowances, the dates of the first and last days of the trip).
The task is to analyze the table by selecting appropriate queries.

1. Display information about business trips of those employees whose last
name ends with the letter "a".
2. Display in alphabetical order the surnames and initials of those employees
who were on a business trip to Moscow.
3. Count the number of times employees have visited each city.
Display information sorted alphabetically by city name. Name the calculated
column Quantity.
4. Find the two top cities by the number of business trips.
Name the calculated column Quantity.
5. Find business trips that start and end in the same month.
Sort the result in alphabetical order:
by city
by employee's surname.
6. Find the daily allowance amount for business trips, the first day of which
fell on February or March 2020.
Sort the the result first in alphabetical order by the names of the employees,
and then in descending order of the daily allowance amount.
7. Find the shortest business trip (trips).
8. Find the distribution of number of business trips by month.
We consider that the business trip refers to a certain month if it began this
month. Sort the data in a descending order, and then in alphabetical order by
the name of the month. Name the columns Month and Count.
9. Query the name and the total amount of per diem received for all business
trips for those employees who have been on business trips more than 3 times,
in descending order of per diem amounts. */

The table trip for this mini project:

CREATE TABLE trip
(
trip_id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(30),
city VARCHAR(25),
per_day DECIMAL(8,2),
start_date DATE,
end_date DATE
);

INSERT INTO trip VALUES
("1", "Баранов П.Е.", "Москва", "700", "2020-01-12", "2020-01-17"),
("2", "Абрамова К.А.", "Владивосток", "450", "2020-01-14", "2020-01-27"),
("3", "Семенов И.В.", "Москва", "700", "2020-01-23", "2020-01-31"),
("4", "Ильиных Г.Р.", "Владивосток", "450", "2020-01-12", "2020-02-02"),
("5", "Колесов С.П.", "Москва", "700", "2020-02-01", "2020-02-06"),
("6", "Баранов П.Е.", "Москва", "700", "2020-02-14", "2020-02-22"),
("7", "Абрамова К.А.", "Москва", "700", "2020-02-23", "2020-03-01"),
("8", "Лебедев Т.К.", "Москва", "700", "2020-03-03", "2020-03-06"),
("9", "Колесов С.П.", "Новосибирск", "450", "2020-02-27", "2020-03-12"),
("10", "Семенов И.В.", "Санкт-Петербург", "700", "2020-03-29", "2020-04-05"),
("11", "Абрамова К.А.", "Москва", "700", "2020-04-06", "2020-04-14"),
("12", "Баранов П.Е.", "Новосибирск", "450", "2020-04-18", "2020-05-04"),
("13", "Лебедев Т.К.", "Томск", "450", "2020-05-20", "2020-05-31"),
("14", "Семенов И.В.", "Санкт-Петербург", "700", "2020-06-01", "2020-06-03"),
("15", "Абрамова К.А.", "Санкт-Петербург", "700", "2020-05-28", "2020-06-04"),
("16", "Федорова А.Ю.", "Новосибирск", "450", "2020-05-25", "2020-06-04"),
("17", "Колесов С.П.", "Новосибирск", "450", "2020-06-03", "2020-06-12"),
("18", "Федорова А.Ю.", "Томск", "450", "2020-06-20", "2020-06-26"),
("19", "Абрамова К.А.", "Владивосток", "450", "2020-07-02", "2020-07-13"),
("20", "Баранов П.Е.", "Воронеж", "450", "2020-07-19", "2020-07-25");


Solutions.

/* Display information about business trips of the employees whose last
name ends with the letter "a". */

SELECT name,
       city,
       per_day,
       start_date,
       end_date
FROM
    trip
WHERE
    name LIKE "%a %"
ORDER BY
    5 DESC;

/* Display in alphabetical order the surnames and initials of those employees
who were on a business trip to Moscow. */

SELECT name,
       city,
       per_day,
       start_date,
       end_date
FROM
  trip
GROUP BY
  name
ORDER BY
  1 ASC;

/* Count the number of times employees have visited each city.
Display information sorted alphabetically by city name. Name the calculated
column Quantity. */

SELECT city,
         COUNT(city) AS Quantity
FROM
  trip
GROUP BY
  city
ORDER BY 1;

/* Find the two top cities by the number of business trips.
Name the calculated column Quantity. */

SELECT city,
       COUNT(city) AS Quantity
FROM
  trip
GROUP BY
  city
ORDER BY
  2 DESC
LIMIT 2;

/* Calculate the number of business trips to all cities except Moscow and
St. Petersburg (surnames and initials of employees, city, duration of business
trip in days, with the first and last day referring to the business trip period).

Information should be displayed in descending order of trip duration, and then
in descending order of city names (in reverse alphabetical order). */

SELECT name,
       city,
       DATADIFF(end_date, start_date) + 1 AS duration
FROM
  trip
WHERE
  city NOT IN ("Москва","Санкт-Петербург")
ORDER BY
  3 DESC, 2 DESC;

/* Find business trips that start and end in the same month.
Sort the result in alphabetical order by city and by employee's surname. */

SELECT
  name,
  city,
  start_date,
  end_date
FROM
  trip
WHERE
  MONTH(start_date) = MONTH(end_date)
ORDER BY
  2, 1;

/* Find the daily allowance amount for business trips, the first day of which
fell on February or March 2020.
Sort the the result first in alphabetical order by the names of the employees,
and then in descending order of the daily allowance amount. */

SELECT name,
       city,
       date_first,
       ((DATEDIFF(end_date, start_date) + 1) * per_day) AS Sum
FROM
  trip
WHERE
  MONTH(start_date) = 2 OR MONTH(start_date) = 3
SORT BY
  1 ASC, 4 DESC;

/* Find the shortest business trip (trips). */

SELECT name,
       city,
       start_date,
       end_date
FROM
  trip
WHERE
  DATEDIFF(end_date, start_date) = (SELECT MIN(DATEDIFF(end_date, start_date))
FROM
  trip);

/* Find the distribution of number of business trips by month.
We consider that a business trip refers to a certain month if it began this month.
Sort the data in a descending order, and then in alphabetical order by the name
of the month. Name the columns Month and Count. */

SELECT name,
       city,
       start_date,
       end_date
FROM
  trip
WHERE
  DATEDIFF(end_date, start_date) =
          (SELECT MIN(DATEDIFF(end_date, start_date))
           FROM trip);

/* Query the name and the total amount of per diem received for all business
trips for those employees who have been on business trips more than 3 times,
 in descending order of per diem amounts. */

SELECT name,
       SUM(per_day * (DATEDIFF(end_dat,start_date) + 1)) AS summ
FROM
  trip
GROUP BY
  name
HAVING
  COUNT(*) > 3
ORDER BY
  2 DESC;
