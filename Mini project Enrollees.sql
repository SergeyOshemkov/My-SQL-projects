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
6. Select the number of people who have applied for each educational program and
competition for it (the number of applications submitted divided by the number
of places according to the plan), rounded to 2 decimal places.
7. Select educational programs where the subject "Informatics" and "Mathematics"
are required for admission. Sort the result by the name of the program.
8. Calculate the additional points for each enrollee.
Sort the result by last name.
9. Select the number of people who have applied for each educational program and
competition for it (the number of applications submitted divided by the number
of places according to the plan), rounded to 2 decimal places.
10.  Select educational programs where the subject "Informatics" and "Mathematics"
are required for admission. Sort the result by the name of the program.
11.

In the request, select the name of the faculty to which belongs the educational
program, the name of the educational program, the plan for recruiting applicants
for the educational program (plan), the number of applications submitted
(Количество) and the Конкурс.  Sort the result by competition in descending
order.

In the request, select the name of the faculty to which belongs the educational
program, the name of the educational program, the plan for recruiting applicants
for the educational program (plan), the number of applications submitted
(Количество) and the Конкурс.  Sort the result by competition in descending
order.
10.Calculate the number of points of each applicant for each educational program
for which he applied, according to the results of the exam. Sort the result by
the educational program, and then by the sum of points in descending order.
11. Select the name of the educational program and the surname of those
applicants who applied for this educational program, but cannot be enrolled in
it. These applicants have a score in one or more of the USE subjects required
for admission to this educational program, less than the minimum score.
Information should be sorted by programs, and then by the names of applicants.
12.  Create an auxiliary table applicant, and include in it the id of the
educational program, the id of the enrollee, the sum of the applicant's points
sorted by the id of the educational program, and then in descending order of
the sum of points.
13.


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

/* Calculate the additional points for each enrollee.
Sort the result by last name.   */

SELECT
    name_enrollee,
    SUM(IF(bonus IS NULL, 0, bonus)) AS Бонус
FROM achievement
    INNER JOIN enrollee_achievement USING(achievement_id)
      RIGHT JOIN enrollee USING(enrollee_id)
GROUP BY
    name_enrollee
ORDER BY 1;

/* Select the number of people who have applied for each educational program and
competition for it (the number of applications submitted divided by the number
of places according to the plan), rounded to 2 decimal places.

In the request, select the name of the faculty to which belongs the educational
program, the name of the educational program, the plan for recruiting applicants
for the educational program (plan), the number of applications submitted
(Количество) and the Конкурс.  Sort the result by competition in descending
order.  */

SELECT
    name_department,
    name_program,
    plan,
    COUNT(plan) AS Количество,
    ROUND(COUNT(plan)/plan, 2) AS Конкурс
FROM department
    INNER JOIN program USING(department_id)
      INNER JOIN program_enrollee USING(program_id)
GROUP BY
    name_department,
    name_program,
    plan
ORDER BY
    5 DESC;

/* Select educational programs where the subject "Informatics" and "Mathematics"
are required for admission. Sort the result by the name of the program.  */

SELECT name_program
FROM subject
    INNER JOIN program_subject USING(subject_id)
      INNER JOIN program USING(program_id)
WHERE name_subject = 'Информатика'
      OR
      name_subject = 'Математика'
GROUP BY
  name_program
HAVING COUNT(name_subject) = 2
ORDER BY 1;

/* Calculate the number of points of each applicant for each educational program
for which he applied, according to the results of the exam. Sort the result by
the educational program, and then by the sum of points in descending order. */

SELECT
    name_program,
    name_enrollee, SUM(result) AS itog

FROM enrollee JOIN program_enrollee USING(enrollee_id)
                  JOIN program USING(program_id)
                      JOIN program_subject USING(program_id)
                          JOIN subject USING(subject_id)
                              JOIN enrollee_subject USING(subject_id)
                                 AND enrollee_subject.enrollee_id = enrollee.enrollee_id
GROUP BY
    name_program,
    name_enrollee
ORDER BY
    1 ASC,
    3 DESC;

/* Select the name of the educational program and the surname of those
applicants who applied for this educational program, but cannot be enrolled in
it. These applicants have a score in one or more of the USE subjects required
for admission to this educational program, less than the minimum score.
Information should be sorted by programs, and then by the names of applicants. */

SELECT
    DISTINCT name_program,
    name_enrollee

FROM enrollee JOIN program_enrollee USING(enrollee_id)
                  JOIN program USING(program_id)
                      JOIN program_subject USING(program_id)
                          JOIN subject USING(subject_id)
                              JOIN enrollee_subject ON subject.subject_id = enrollee_subject.subject_id
                                AND enrollee_subject.enrollee_id = enrollee.enrollee_id
WHERE
    result < min_result
ORDER BY
    1, 2;

/* Create an auxiliary table applicant, and include in it the id of the
educational program, the id of the enrollee, the sum of the applicant's points
sorted by the id of the educational program, and then in descending order of
the sum of points. */

CREATE TABLE
    applicant AS
SELECT program_id,
    enrollee.enrollee_id,
    SUM(result) AS itog
FROM enrollee
            JOIN program_enrollee USING(enrollee_id)
                  JOIN program USING(program_id)
                      JOIN program_subject USING(program_id)
                          JOIN subject USING(subject_id)
                              JOIN enrollee_subject ON subject.subject_id = enrollee_subject.subject_id                                           AND enrollee_subject.enrollee_id = enrollee.enrollee_id
GROUP BY
    program_id,
    enrollee_id
ORDER BY
    1 ASC,
    3 DESC;

/*   */


    /*   */
    /*   */


    /*   */
    /*   */


    /*   */
    /*   */


    /*   */
