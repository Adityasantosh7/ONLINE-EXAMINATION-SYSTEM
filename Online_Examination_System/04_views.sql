-- =====================================================================
--  PROJECT : ONLINE EXAMINATION SYSTEM   (DBMS Mini Project)
--  File    : 04_views.sql
--  Run this file AFTER 01_schema.sql and 02_data.sql
--
--  3 VIEWS (requirement: minimum 2)
-- =====================================================================

USE Online_Examination_System;

DROP VIEW IF EXISTS V_STUDENT_REPORT;
DROP VIEW IF EXISTS V_COURSE_ANALYTICS;
DROP VIEW IF EXISTS V_UPCOMING_EXAMS;

-- ---------------------------------------------------------------------
-- VIEW 1 : V_STUDENT_REPORT
--   A ready-made mark sheet joining STUDENT, EXAM_ATTEMPT, EXAM,
--   COURSE and RESULT. The application simply does SELECT * FROM it.
-- ---------------------------------------------------------------------
CREATE VIEW V_STUDENT_REPORT AS
    SELECT s.Student_ID,
           s.Student_Name,
           s.Department,
           c.Course_Name,
           x.Exam_Title,
           x.Exam_Date,
           a.Marks_Obtained,
           r.Percentage,
           r.Grade,
           r.Status
    FROM STUDENT s
    JOIN EXAM_ATTEMPT a ON a.Student_ID = s.Student_ID
    JOIN EXAM x         ON x.Exam_ID    = a.Exam_ID
    JOIN COURSE c       ON c.Course_ID  = x.Course_ID
    JOIN RESULT r       ON r.Attempt_ID = a.Attempt_ID;

-- ---------------------------------------------------------------------
-- VIEW 2 : V_COURSE_ANALYTICS
--   Course-wise performance dashboard for the faculty.
--   Uses aggregate functions + GROUP BY inside the view.
-- ---------------------------------------------------------------------
CREATE VIEW V_COURSE_ANALYTICS AS
    SELECT c.Course_ID,
           c.Course_Name,
           i.Instructor_Name,
           COUNT(a.Attempt_ID)  AS TOTAL_ATTEMPTS,
           ROUND(AVG(a.Marks_Obtained), 2) AS AVERAGE_MARKS,
           SUM(CASE WHEN r.Status = 'PASS' THEN 1 ELSE 0 END) AS PASSED,
           SUM(CASE WHEN r.Status = 'FAIL' THEN 1 ELSE 0 END) AS FAILED
    FROM COURSE c
    JOIN INSTRUCTOR i  ON i.Instructor_ID = c.Instructor_ID
    LEFT JOIN EXAM x          ON x.Course_ID  = c.Course_ID
    LEFT JOIN EXAM_ATTEMPT a  ON a.Exam_ID    = x.Exam_ID
    LEFT JOIN RESULT r        ON r.Attempt_ID = a.Attempt_ID
    GROUP BY c.Course_ID, c.Course_Name, i.Instructor_Name;

-- ---------------------------------------------------------------------
-- VIEW 3 : V_UPCOMING_EXAMS
--   Exams that are still to be conducted (schedule board).
-- ---------------------------------------------------------------------
CREATE VIEW V_UPCOMING_EXAMS AS
    SELECT x.Exam_ID,
           x.Exam_Title,
           c.Course_Name,
           i.Instructor_Name,
           x.Exam_Date,
           x.Duration_Minutes,
           x.Total_Marks,
           x.Exam_Type
    FROM EXAM x
    JOIN COURSE c       ON c.Course_ID   = x.Course_ID
    JOIN INSTRUCTOR i   ON i.Instructor_ID = c.Instructor_ID
    WHERE x.Exam_Date > CURRENT_DATE;

-- ---------------------------------------------------------------------
-- Use the views
-- ---------------------------------------------------------------------
SELECT * FROM V_STUDENT_REPORT ORDER BY Course_Name, Marks_Obtained DESC;

SELECT * FROM V_COURSE_ANALYTICS ORDER BY AVERAGE_MARKS DESC;

SELECT * FROM V_UPCOMING_EXAMS ORDER BY Exam_Date;
