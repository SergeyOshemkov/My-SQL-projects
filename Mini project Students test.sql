/* Description of the projectL

Tasks to solve.

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

 */

/* Select students who passed the discipline "Basics of databases", indicate the
 date of the attempt and the result. Display information in descending order of
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


/*   */
