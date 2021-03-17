/*
The description of the project.

The university implements online testing in several disciplines. Each discipline
includes a number of questions. The answers to the question present in the form
of answer options. And one of these options is correct.

The student  registers in the system, indicating his name, surname and
patronymic. After that, he can be tested in one or more disciplines.
The student has several attempts to pass the test (it is necessary to keep the
date of the attempt).

Each student gets a randomly  selected  set of questions on the chosen discipline.
The student answers the questions by choosing one of the suggested answer options.

When the testing comes to an end, the result (in percent) of the attempt is
calculated and saved.


Tasks to unswer.

1. Select students who passed the discipline "Basics of databases", indicate the
 date of the attempt and the result. Display information in descending order of
 test results.
2.  Select the number of attempts made by students in each discipline, as well
as the average result of attempts, which should be rounded to 2 decimal places.
The result of an attempt stands for the percentage of correct answers to test
questions, which is filled in to the result column.
3. Select the student (or various students) who has the highest attempts
results. Sort information alphabetically by student surname.
4. In case the student has made several attempts in the same discipline, then
select the difference in days between the first and last attempts. Select
information in ascending order of difference. Students who have made one attempt
 at a discipline are not counted.
5. Students can be tested in one or more disciplines. Display the discipline and
the number of unique students who were tested in it.
Sort the information in descending order by quantity, and then by the name of
the discipline.
Include the disciplines for which the students did not pass, in this case,
indicate the number of students 0.
6. Randomly select 3 questions on the discipline Fundamentals of databases.
7. Select the questions that were included in the test for Ivan Semyonov in the
"Basics of SQL" discipline 2020-05-17 (the attempt_id value for this attempt is
 7). Indicate which answer the student gave and whether he was correct or not.
8. Calculate the test results. The result of an attempt is calculated as the
number of correct answers divided by 3 (the number of questions in each attempt)
and multiplied by 100. Round the result to two decimal places. Select the
student's surname, subject name, date and result. Sort the information by the
last name and then by the date of attempt in descending order.
9. Calculate the percentage of successful solutions for each question.
Round the value to 2 decimal places.
Include in the query the name of the subject to which the question relates and
the total number of responses to this question. Sort the information by the name
of the discipline, then in descending order of success, and then by the text of
the question in alphabetical order.
Cut the questions to 30 characters and add an ellipsis "...".


Solutions. */

/* Select students who passed the discipline "Basics of databases", indicate the
 date of attempt and result. Select information in descending order of
 test results. */

SELECT name_subject,
       COUNT(attempt_id) AS Количество,
       ROUND(AVG(result), 2) AS Среднее
FROM attempt
    RIGHT JOIN subject ON attempt.subject_id = subject.subject_id
GROUP BY
    name_subject;

/*  Select the number of attempts made by students in each discipline, as well
as the average result of attempts, which should be rounded to 2 decimal places.
The result of an attempt stands for the percentage of correct answers to test
questions, which is filled in to the result column.  */

SELECT name_subject,
       COUNT(attempt_id) AS Количество,
       ROUND(AVG(result), 2) AS Среднее
FROM attempt
    RIGHT JOIN subject ON attempt.subject_id = subject.subject_id
GROUP BY
    name_subject;

/* Select the student (or various students) who has the highest attempts
results. Sort information alphabetically by student surname.  */

SELECT name_student,
       result
FROM attempt
       INNER JOIN student USING(student_id)
GROUP BY
    name_student,
    result
HAVING
    result = (SELECT MAX(result)
    FROM attempt)
ORDER BY 1;

/* In case the student has made several attempts in the same discipline, then
select the difference in days between the first and last attempts. Select
information in ascending order of difference. Students who have made one attempt
 at a discipline are not counted. */

SELECT
    name_student,
    name_subject,
    DATEDIFF(MAX(date_attempt), MIN(date_attempt)) AS Интервал
FROM subject
    INNER JOIN attempt USING(subject_id)
    INNER JOIN student USING(student_id)
GROUP BY
    name_student, name_subject
HAVING COUNT(date_attempt) > 1
ORDER BY 3;

/* Students can be tested in one or more disciplines. Display the discipline and
the number of unique students who were tested in it.
Sort the information in descending order by quantity, and then by the name of
the discipline.
Include the disciplines for which the students did not pass, in this case,
indicate the number of students 0. */

SELECT
    name_subject,
    COUNT(DISTINCT student_id) AS Количество
FROM subject
    LEFT JOIN attempt ON subject.subject_id = attempt.subject_id
GROUP BY
    name_subject
ORDER BY
    2 DESC, 1 ASC;

/* Randomly select 3 questions on the discipline "Fundamentals of databases". */

SELECT
    question_id,
    name_question
FROM subject
    INNER JOIN question ON subject.subject_id = question.subject_id
WHERE
    name_subject = "Основы баз данных"
ORDER BY RAND()
LIMIT 3;


/* Select the questions that were included in the test for Ivan Semyonov in the
"Basics of SQL" discipline 2020-05-17 (the attempt_id value for this attempt is
 7). Indicate which answer the student gave and whether he was correct or not.*/

SELECT
    name_question,
    name_answer,
    IF(is_correct, 'Верно', "Неверно") AS Результат
FROM answer
     INNER JOIN testing ON answer.answer_id = testing.answer_id
     INNER JOIN question ON testing.question_id = question.question_id
WHERE
    attempt_id = 7;

/* Calculate the test results. The result of an attempt is calculated as the
number of correct answers divided by 3 (the number of questions in each attempt)
and multiplied by 100. Round the result to two decimal places. Select the
student's surname, subject name, date and result. Sort the information by the
last name and then by the date of attempt in descending order. */

SELECT name_student,
       name_subject,
       date_attempt,
       ROUND((SUM(is_correct)/3) * 100,2) AS Результат
FROM subject
    INNER JOIN attempt USING(subject_id)
        INNER JOIN testing USING(attempt_id)
            INNER JOIN student USING(student_id)
                INNER JOIN answer USING(answer_id)
GROUP BY name_student,
         name_subject,
         date_attempt
ORDER BY
    1 ASC, 3 DESC;

/* Calculate the percentage of successful solutions for each question.
Round the value to 2 decimal places.
Include in the query the name of the subject to which the question relates and
the total number of responses to this question. Sort the information by the name
of the discipline, then in descending order of success, and then by the text of
the question in alphabetical order.
Cut the questions to 30 characters and add an ellipsis "...". */

SELECT name_subject,
       CONCAT(LEFT(name_question, 30), "...") AS Вопрос,
       COUNT(answer_id) AS Всего_ответов,
       ROUND(SUM(is_correct) * 100/ COUNT(answer_id), 2) AS Успешность
FROM subject
    INNER JOIN question USING(subject_id)
        RIGHT JOIN answer USING(question_id)
            INNER JOIN testing USING(answer_id)
GROUP BY
    name_subject,
    Вопрос
ORDER BY
    1 ASC,
    4 DESC,
    2 ASC;  */

/*   */

/*   */
