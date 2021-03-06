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

/*   */
