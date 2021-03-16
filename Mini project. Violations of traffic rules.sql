/* Description.

In this project I create tables with fines and analize the violations of
traffic rules.

1. Create and fill in 2 tables with information about fines.
2. Substitute the "none " values in the column sum_fine of the table fine with
the actual values taken from the table traffic_violation.
3. Remove from the fine table information about violations committed before
February 1, 2020.
4. Create a new table back_payment and fill it in with the information about
unpaid fines (surname and initials of the driver, car number, violation, amount
of the fine and date of violation) from the fine table.
5. Select the surname, car number and violation for the  drivers who have
violated the same rule two or more times on the same car.
At the same time, take into account all violations, regardless of whether they
are paid for or not.
Sort the information alphabetically,  by the driver's last name.
6. In the fine table, double the amount of unpaid fines for the drivers selected
in the previous step.
At the same time, consider that the amount should be increased only for unpaid
fines.
7. Fill in the date of payment of the corresponding fine from the payment table
in the fine table.
Reduce the accrued fine in the fine table by half (only for the new fines from
the payment table), if the payment was made not later than 20 days from the
date of violation. */


/* Create a table with information about fines. */

CREATE TABLE fine
 (
    fine_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(30),
    number_plate VARCHAR(6),
    violation VARCHAR(50),
    sum_fine DECIMAL(8,2),
    date_violation DATE,
    date_payment DATE
 );

/* Fill in a table. */

INSERT INTO fine(
            name,
            number_plate,
            violation,
            sum_fine,
            date_violation,
            date_payment)
VALUES
       ("Баранов П.Е.", "Р523ВТ", "Превышение скорости(от 40 до 60)",500.00, "2020-02-14", "2020-01-17"),
       ("Абрамова К.А.", "О111АВ", "Проезд на запрещающий сигнал",1000.00, "2020-02-23", "2020-02-27"),
       ("Яковлев Г.Р.", "Т330ТТ", "Превышение скорости(от 20 до 40)", 500.00 , "2020-03-03", " 2020-02-23"),
       ("Яковлев Г.Р.", "О111АВ", "Проезд на запрещающий сигнал", null, "2020-02-23", null),
       ("Колесов С.П. ", "К892АХ ", "Проезд на запрещающий сигнал", null, "2020-03-03", null),
       ("Баранов П.Е.", "Р523ВТ", "Превышение скорости(от 40 до 60)",null, "2020-02-14", null),
       ("Абрамова К.А.", "О111АВ", "Проезд на запрещающий сигнал", null, "2020-02-23", null),
       ("Яковлев Г.Р.", "Т330ТТ", "Проезд на запрещающий сигнал", null, "2020-03-03", null);

/* Create the table traffic violation. */

CREATE TABLE traffic_violation
 (
    violation_id INT PRIMARY KEY AUTO_INCREMENT,
    violation VARCHAR(30),
    sum_fine DECIMAL(8,2),
 );
 INSERT INTO
    traffic_violation(violation_id, violation, sum_fine)
 VALUES
        (1, "Превышение скорости(от 20 до 40)", 500.00),
        (2, "Превышение скорости(от 40 до 60)", 1000.00),
        (3, "Проезд на запрещающий сигнал", 1000.00);

/* Substitute the "none " values in the column sum_fine of the table fine with
the actual values taken from the table traffic_violation. */

UPDATE
  fine as f,
  traffic_violation as tv
SET
  f.sum_fine = tv.sum_fine
WHERE
  f.violation = tv.violation and f.sum_fine is null;

/* Remove from the fine table information about violations committed before
February 1, 2020. */

DELETE FROM
          fine
WHERE
  DATEDIFF("2020-02-01", date_violation) > 0;

/* Create a new table back_payment and fill it in with the information about
unpaid fines (surname and initials of the driver, car number, violation, amount
of the fine and date of violation) from the fine table. */

CREATE TABLE
    back_payment
SELECT
    name,
    number_plate,
    violation,
    sum_fine,
    date_violation
FROM
    fine
WHERE
    date_payment is null;

/* Select the surname, car number and violation for the  drivers who have
violated the same rule two or more times on the same car.
At the same time, take into account all violations, regardless of whether they
are paid for or not.
Sort the information alphabetically,  by the driver's last name. */

SELECT
  name,
  number_plate,
  violation
FROM
  fine
GROUP BY
  name,
  number_plate,
  violation
HAVING
  COUNT(violation) >= 2
ORDER BY
  1 ASC;

/* In the fine table, double the amount of unpaid fines for the drivers selected
in the previous step.
At the same time, consider that the amount should be increased only for unpaid
fines.  */

UPDATE fine,
    (SELECT
       name,
       number_plate,
       violation
FROM
  fine
GROUP BY
  name,
  number_plate,
  violation
HAVING
  COUNT(violation) >= 2
ORDER BY
  1 ASC
      ) query_in
SET
    sum_fine = 2 * sum_fine
WHERE
    date_payment IS NULL
AND
    fine.name = query_in.name;

/* Fill in the date of payment of the corresponding fine from the payment table
in the fine table.
Reduce the accrued fine in the fine table by half (only for the new fines from
the payment table), if the payment was made not later than 20 days from the
date of violation. */

UPDATE
    fine,
    payment
SET
    fine.date_payment = payment.date_payment
WHERE
    fine.name = payment.name
AND
    fine.date_violation = payment.date_violation;
UPDATE
    fine,
    payment
SET
    fine.sum_fine = fine.sum_fine / 2
WHERE
    DATEDIFF(payment.date_payment, payment.date_violation) <= 20
AND
    fine.name = payment.name
AND
    fine.date_payment = payment.date_payment
AND
 fine.date_violation = payment.date_violation;
