-- =====================================================================
--  PROJECT : ONLINE EXAMINATION SYSTEM   (DBMS Mini Project)
--  File    : 03_queries.sql
--  Run this file AFTER 01_schema.sql and 02_data.sql
--
--  16 queries covering every requirement:
--  SELECT | WHERE | ORDER BY | GROUP BY | HAVING | AGGREGATES |
--  INNER JOIN | LEFT JOIN | SUBQUERIES (scalar, IN, EXISTS, derived)
-- =====================================================================

USE Online_Examination_System;

-- ---------------------------------------------------------------------
-- Q1. SIMPLE SELECT + column list + aliases
--     List the roll number, name and e-mail of every student.
-- ---------------------------------------------------------------------
SELECT Student_ID   AS ROLL_NO,
       Student_Name AS STUDENT_NAME,
       Email        AS EMAIL_ID
FROM STUDENT;

-- ---------------------------------------------------------------------
-- Q2. WHERE condition with AND / comparison operators
--     CSE students whose roll number is 1019 or above.
-- ---------------------------------------------------------------------
SELECT Student_ID, Student_Name, Department
FROM STUDENT
WHERE Department = 'CSE' AND Student_ID >= 1019
ORDER BY Student_ID;

-- ---------------------------------------------------------------------
-- Q3. WHERE condition + ORDER BY (descending)
--     Upcoming FINAL exams, latest first.
-- ---------------------------------------------------------------------
SELECT Exam_Title, Exam_Date, Exam_Type
FROM EXAM
WHERE Exam_Type = 'FINAL'
ORDER BY Exam_Date DESC;

-- ---------------------------------------------------------------------
-- Q4. AGGREGATE FUNCTIONS (COUNT, AVG, MAX, MIN, SUM) without GROUP BY
-- ---------------------------------------------------------------------
SELECT COUNT(*)                 AS TOTAL_ATTEMPTS,
       ROUND(AVG(Marks_Obtained), 2) AS AVG_MARKS,
       MAX(Marks_Obtained)      AS HIGHEST,
       MIN(Marks_Obtained)      AS LOWEST,
       SUM(Marks_Obtained)      AS TOTAL_MARKS_SCORED
FROM EXAM_ATTEMPT;

-- ---------------------------------------------------------------------
-- Q5. GROUP BY + aggregate functions
--     Exam-wise number of students, average, highest and lowest marks.
-- ---------------------------------------------------------------------
SELECT Exam_ID,
       COUNT(*)                 AS STUDENTS_APPEARED,
       ROUND(AVG(Marks_Obtained), 2) AS AVG_MARKS,
       MAX(Marks_Obtained)      AS MAX_MARKS,
       MIN(Marks_Obtained)      AS MIN_MARKS
FROM EXAM_ATTEMPT
GROUP BY Exam_ID
ORDER BY Exam_ID;

-- ---------------------------------------------------------------------
-- Q6. GROUP BY + HAVING (filter on the GROUP, not on rows)
--     Exams whose average score is greater than 60.
-- ---------------------------------------------------------------------
SELECT Exam_ID,
       COUNT(*)                 AS STUDENTS_APPEARED,
       ROUND(AVG(Marks_Obtained), 2) AS AVG_MARKS
FROM EXAM_ATTEMPT
GROUP BY Exam_ID
HAVING AVG(Marks_Obtained) > 60
ORDER BY AVG_MARKS DESC;

-- ---------------------------------------------------------------------
-- Q7. GROUP BY + HAVING on a JOIN
--     Courses in which 4 or more students are enrolled.
-- ---------------------------------------------------------------------
SELECT c.Course_Name,
       COUNT(*) AS ENROLLED_STUDENTS
FROM COURSE c
JOIN ENROLLMENT e ON e.Course_ID = c.Course_ID
GROUP BY c.Course_Name
HAVING COUNT(*) >= 4
ORDER BY ENROLLED_STUDENTS DESC;

-- ---------------------------------------------------------------------
-- Q8. INNER JOIN (3 tables) - STUDENT + EXAM_ATTEMPT + EXAM
--     Complete mark sheet of every attempt.
-- ---------------------------------------------------------------------
SELECT a.Attempt_ID,
       s.Student_ID,
       s.Student_Name,
       x.Exam_Title,
       a.Marks_Obtained
FROM EXAM_ATTEMPT a
JOIN STUDENT s ON s.Student_ID = a.Student_ID
JOIN EXAM x    ON x.Exam_ID    = a.Exam_ID
ORDER BY x.Exam_ID, a.Marks_Obtained DESC;

-- ---------------------------------------------------------------------
-- Q9. INNER JOIN (4 tables) - course, exam, attempt and result
--     Course-wise pass statistics  (uses GROUP BY + HAVING + CASE)
-- ---------------------------------------------------------------------
SELECT c.Course_Name,
       COUNT(a.Attempt_ID) AS STUDENTS_APPEARED,
       SUM(CASE WHEN r.Status = 'PASS' THEN 1 ELSE 0 END) AS PASSED,
       ROUND(AVG(a.Marks_Obtained), 2) AS AVG_MARKS
FROM COURSE c
JOIN EXAM x          ON x.Course_ID   = c.Course_ID
JOIN EXAM_ATTEMPT a  ON a.Exam_ID     = x.Exam_ID
JOIN RESULT r        ON r.Attempt_ID  = a.Attempt_ID
GROUP BY c.Course_Name
HAVING AVG(a.Marks_Obtained) >= 60
ORDER BY AVG_MARKS DESC;

-- ---------------------------------------------------------------------
-- Q10. LEFT JOIN - every student with the number of courses enrolled
--      (student 1023 appears with 0 -> proves LEFT JOIN behaviour)
-- ---------------------------------------------------------------------
SELECT s.Student_ID,
       s.Student_Name,
       COUNT(e.Course_ID) AS COURSES_ENROLLED
FROM STUDENT s
LEFT JOIN ENROLLMENT e ON e.Student_ID = s.Student_ID
GROUP BY s.Student_ID, s.Student_Name
ORDER BY COURSES_ENROLLED DESC, s.Student_ID;

-- ---------------------------------------------------------------------
-- Q11. LEFT JOIN - students who did NOT appear for exam 201
-- ---------------------------------------------------------------------
SELECT s.Student_ID, s.Student_Name
FROM STUDENT s
LEFT JOIN EXAM_ATTEMPT a
       ON a.Student_ID = s.Student_ID
      AND a.Exam_ID    = 201
WHERE a.Attempt_ID IS NULL
ORDER BY s.Student_ID;

-- ---------------------------------------------------------------------
-- Q12. SCALAR SUBQUERY in WHERE
--      Attempts that scored above the overall average.
-- ---------------------------------------------------------------------
SELECT Attempt_ID, Student_ID, Exam_ID, Marks_Obtained
FROM EXAM_ATTEMPT
WHERE Marks_Obtained > (SELECT AVG(Marks_Obtained) FROM EXAM_ATTEMPT)
ORDER BY Marks_Obtained DESC;

-- ---------------------------------------------------------------------
-- Q13. SUBQUERY with IN + GROUP BY + HAVING inside it
--      Exams whose average is 75 or more.
-- ---------------------------------------------------------------------
SELECT Exam_ID, Exam_Title, Exam_Date
FROM EXAM
WHERE Exam_ID IN (
        SELECT Exam_ID
        FROM EXAM_ATTEMPT
        GROUP BY Exam_ID
        HAVING AVG(Marks_Obtained) >= 75)
ORDER BY Exam_ID;

-- ---------------------------------------------------------------------
-- Q14. CORRELATED SUBQUERY with NOT EXISTS
--      Students who have not attempted any exam yet.
-- ---------------------------------------------------------------------
SELECT Student_ID, Student_Name, Department
FROM STUDENT s
WHERE NOT EXISTS (SELECT 1
                  FROM EXAM_ATTEMPT a
                  WHERE a.Student_ID = s.Student_ID);

-- ---------------------------------------------------------------------
-- Q15. DERIVED TABLE (subquery in the FROM clause)
--      Exam-wise average from the derived table, filtered by HAVING
--      style condition in the outer query.
-- ---------------------------------------------------------------------
SELECT T.EXAM_ID, T.STUDENTS, T.AVG_MARKS
FROM (SELECT Exam_ID,
             COUNT(*)                 AS STUDENTS,
             ROUND(AVG(Marks_Obtained),2) AS AVG_MARKS
      FROM EXAM_ATTEMPT
      GROUP BY Exam_ID) AS T
WHERE T.AVG_MARKS > 60
ORDER BY T.AVG_MARKS DESC;

-- ---------------------------------------------------------------------
-- Q16. SUBQUERY with MAX() - the highest scorer(s) of exam 201
-- ---------------------------------------------------------------------
SELECT s.Student_Name, a.Marks_Obtained
FROM EXAM_ATTEMPT a
JOIN STUDENT s ON s.Student_ID = a.Student_ID
WHERE a.Exam_ID = 201
  AND a.Marks_Obtained = (SELECT MAX(Marks_Obtained)
                          FROM EXAM_ATTEMPT
                          WHERE Exam_ID = 201);
