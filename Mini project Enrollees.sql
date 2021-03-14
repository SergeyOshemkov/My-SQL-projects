/* Description of the project:

Tasks to solve:

1. In the table attempt to include a new attempt for the student Pavel Baranov
in the discipline "The basics of DBs". Set the current date as the date of the
attempt.

*/


/*  In the table attempt to include a new attempt for the student Pavel Baranov
in the discipline "The basics of DBs". Set the current date as the date of the
attempt. */

INSERT INTO attempt(
                    student_id, 
                    subject_id, 
                    date_attempt
                    )
SELECT
    student.student_id, 
    subject.subject_id, NOW()
FROM student 
    INNER JOIN attempt USING(student_id)
    INNER jOIN subject USING(subject_id) 
WHERE 
    name_subject = "Основы баз данных" 
    AND 
    name_student = "Баранов Павел";


/*   */
