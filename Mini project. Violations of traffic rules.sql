/*In this project I create the table and analize the violations of traffic rules.

1. Create and fill in a table with information about fines.
2. Enter the amount of the fine for each new traffic violation.
3.

*/





если водитель на определенной машине совершил повторное нарушение, то сумму его штрафа за данное нарушение нужно увеличить в два раза (часть 1, часть 2) ;
если водитель оплатил свой штраф в течение 20 дней со дня нарушения, то значение его штрафа уменьшить в два раза;
создать новую таблицу,  в которую включить информацию о всех неоплаченных штрафах;
удалить  информацию о нарушениях, совершенных раньше некоторой даты.

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
