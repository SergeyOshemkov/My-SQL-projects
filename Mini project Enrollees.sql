/* Description of the project:


The university consists of a set of faculties (schools). Applicants are admitted
 to educational programs based on the results of the Unified State Examination
 (USE).
The scores on USE subjects are necessary for admission to a specific educational
program which belongs to a specific faculty.
The minimum score in these subjects, as well as the recruitment plan (number of
places) for the educational program are determined for each educational program.

Applicants apply to the admissions office for an educational program, each
applicant can choose several educational programs (but not more than three).
The application indicates the surname, name, patronymic of the applicant, as
well as his achievements: whether he received a medal for studying at school,
whether he has a TRP badge, etc. At the same time, an additional point is
determined for each achievement. The applicant provides a certificate with the
results of passing the exam. If an applicant chooses an educational program,
then he must have passed the subjects determined for this program, and the score
must be at least the minimum in this subject.
The enrollment of applicants is carried out as follows: achievement points are
added to the sum of points in subjects for each educational program is
calculated, then applicants are sorted in descending order of the sum of points
and the first applicants are selected according to the number of places
determined by the recruitment plan.

Tasks to solve:

1. Select the applicants who want to apply to the educational program
"Mechatronics and Robotics". Sort the list of applicants by last name.
2. What are the educational programs where the subject "Informatics" is required
 for admission.
3. Select the number of applicants who passed the USE in each subject, the
maximum, minimum and average scores for the USE subject.
Sort information by subject name in alphabetical order, round the average value
to one decimal place.
4.  Find educational programs with the minimum USE score in each subject  greater
 than or equal to 40 points. Sort the programs alphabetically.
5. Select educational programs that have the largest recruitment plan and it's
value.


Solutions.

Select the applicants who want to apply to the educational program "Mechatronics
and Robotics". Sort the list of applicants by last name.  */


SELECT name_enrollee

FROM program
    INNER JOIN program_enrollee USING(program_id)
    	INNER JOIN enrollee USING(enrollee_id)
WHERE
    name_program = "Мехатроника и робототехника"
ORDER BY
    1;


/* What are the educational programs where the subject "Informatics" is required
for admission.  */

SELECT
    name_program
FROM program
    INNER JOIN program_subject USING(program_id)
    	INNER JOIN subject USING(subject_id)
WHERE
    name_subject = "Информатика";

/*  Select the number of applicants who passed the USE in each subject, the
maximum, minimum and average scores for the USE subject.
Sort information by subject name in alphabetical order, round the average value
to one decimal place. */

SELECT name_subject,
    COUNT(enrollee_id) AS Количество,
    ROUND(MAX(result),1) AS Максимум,
    ROUND(MIN(result),1) AS Минимум,
    ROUND(AVG(result),1) AS Среднее
FROM enrollee_subject
    INNNER JOIN subject USING(subject_id)
GROUP BY
    name_subject
ORDER BY 1;


/* Find educational programs with the minimum USE score in each subject  greater
 than or equal to 40 points. Sort the programs alphabetically.  */

 SELECT DISTINCT
     name_program
 FROM program_subject
     INNER JOIN program USING(program_id)
 GROUP BY
     name_program
 HAVING
     MIN(min_result) >= 40
 ORDER BY 1;

/* Select educational programs that have the largest recruitment plan and it's
value.  */

SELECT
    name_program,
    plan
FROM
    program
HAVING
    plan = (SELECT MAX(plan) FROM program);

/*   */


/*   */


/*   */


/*   */
