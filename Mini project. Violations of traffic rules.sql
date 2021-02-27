/*In this project I create the table and analize the violations of traffic rules.

1. Create and fill in 2 tables with information about fines.
2. Substitute the "none " values in the column sum_fine of the table fine with
the actual values taken from the table traffic_violation.
3.   */

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

INSERT INTO fine(name, number_plate, violation, sum_fine, date_violation, date_payment)

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

 INSERT INTO traffic_violation(violation_id, violation, sum_fine)

 VALUES
        (1, "Превышение скорости(от 20 до 40)", 500.00),
        (2, "Превышение скорости(от 40 до 60)", 1000.00),
        (3, "Проезд на запрещающий сигнал", 1000.00);

/* Substitute the "none " values in the column sum_fine of the table fine with
the actual values taken from the table traffic_violation. */

update
  fine as f,
  traffic_violation as tv
set
  f.sum_fine = tv.sum_fine
where
  f.violation = tv.violation and f.sum_fine is null;
