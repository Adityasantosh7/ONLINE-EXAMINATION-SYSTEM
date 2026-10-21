-- =====================================================================
--  PROJECT : ONLINE EXAMINATION SYSTEM   (DBMS Mini Project)
--  File    : 05_triggers.sql
--  RDBMS   : MySQL 8.0+
--
--  IMPORTANT - run the files in this order :
--      01_schema.sql  ->  02_data.sql  ->  04_views.sql  ->  05_triggers.sql
--  (run this file AFTER the data, otherwise Marks_Obtained would be
--   counted twice by trigger 2)
--
--  3 TRIGGERS (requirement: at least 1)
-- =====================================================================

USE Online_Examination_System;

DROP TRIGGER IF EXISTS trg_auto_grade;
DROP TRIGGER IF EXISTS trg_add_answer_marks;
DROP TRIGGER IF EXISTS trg_check_attempt_marks;

DELIMITER $$

-- ---------------------------------------------------------------------
-- TRIGGER 1 : trg_auto_grade   (BEFORE INSERT on RESULT)
--   Automatically computes GRADE and PASS/FAIL STATUS from PERCENTAGE
--   so that the application cannot store a wrong grade.
--   Grade rule : A >= 80 | B >= 70 | C >= 60 | D >= 50 | else F
-- ---------------------------------------------------------------------
CREATE TRIGGER trg_auto_grade
BEFORE INSERT ON RESULT
FOR EACH ROW
BEGIN
    IF NEW.Percentage >= 80 THEN
        SET NEW.Grade = 'A';
    ELSEIF NEW.Percentage >= 70 THEN
        SET NEW.Grade = 'B';
    ELSEIF NEW.Percentage >= 60 THEN
        SET NEW.Grade = 'C';
    ELSEIF NEW.Percentage >= 50 THEN
        SET NEW.Grade = 'D';
    ELSE
        SET NEW.Grade = 'F';
    END IF;

    IF NEW.Percentage >= 50 THEN
        SET NEW.Status = 'PASS';
    ELSE
        SET NEW.Status = 'FAIL';
    END IF;
END $$

-- ---------------------------------------------------------------------
-- TRIGGER 2 : trg_add_answer_marks   (AFTER INSERT on ANSWER)
--   Every time an answer is stored, the total marks of that attempt
--   in EXAM_ATTEMPT are updated automatically (running total).
-- ---------------------------------------------------------------------
CREATE TRIGGER trg_add_answer_marks
AFTER INSERT ON ANSWER
FOR EACH ROW
BEGIN
    UPDATE EXAM_ATTEMPT
       SET Marks_Obtained = Marks_Obtained + NEW.Marks_Scored
     WHERE Attempt_ID = NEW.Attempt_ID;
END $$

-- ---------------------------------------------------------------------
-- TRIGGER 3 : trg_check_attempt_marks   (BEFORE UPDATE on EXAM_ATTEMPT)
--   Business rule: marks of an attempt can never be negative and can
--   never exceed the Total_Marks of that exam. Violation raises an
--   error (SIGNAL) and aborts the UPDATE.
-- ---------------------------------------------------------------------
CREATE TRIGGER trg_check_attempt_marks
BEFORE UPDATE ON EXAM_ATTEMPT
FOR EACH ROW
BEGIN
    DECLARE v_total SMALLINT;
    SELECT Total_Marks INTO v_total
      FROM EXAM
     WHERE Exam_ID = NEW.Exam_ID;

    IF NEW.Marks_Obtained < 0 OR NEW.Marks_Obtained > v_total THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'INVALID MARKS: value must be between 0 and the exam Total_Marks';
    END IF;
END $$

DELIMITER ;

-- =====================================================================
--  DEMONSTRATION / TEST CASES  (take screenshots of these)
-- =====================================================================

-- TEST 1 : trigger 2 - insert one answer, attempt total is updated
--          (attempt 9025 = fresh attempt of student 1018 in exam 201)
INSERT INTO EXAM_ATTEMPT (Attempt_ID, Student_ID, Exam_ID, Attempt_Date, Status, Marks_Obtained)
VALUES (9025, 1018, 201, '2026-08-14', 'COMPLETED', 0);

INSERT INTO ANSWER (Attempt_ID, Exam_ID, Question_No, Selected_Label, Is_Correct, Marks_Scored)
VALUES (9025, 201, 1, 'D', 'YES', 25);

-- Expect : Marks_Obtained = 25  (updated automatically by the trigger)
SELECT Attempt_ID, Marks_Obtained
FROM EXAM_ATTEMPT
WHERE Attempt_ID = 9025;

-- TEST 2 : trigger 3 - illegal marks must be rejected
-- Expect : Error 1644 (45000) - "INVALID MARKS ..."
UPDATE EXAM_ATTEMPT
SET Marks_Obtained = 150
WHERE Attempt_ID = 9025;

-- TEST 3 : trigger 1 - grade and status filled automatically.
--          We deliberately supply a WRONG grade/status; the trigger
--          must overwrite them (values are legal for the CHECK constraint
--          in both cases, so the test works whatever the evaluation order).
INSERT INTO RESULT (Result_ID, Attempt_ID, Percentage, Grade, Status, Published_Date)
VALUES (7025, 9025, 25.00, 'A', 'PASS', '2026-08-17');

-- Expect : Grade = 'F', Status = 'FAIL' (the 'A' / 'PASS' supplied by us
--          are overwritten by trg_auto_grade)
SELECT Result_ID, Attempt_ID, Percentage, Grade, Status
FROM RESULT
WHERE Result_ID = 7025;

-- ---------------------------------------------------------------------
-- OPTIONAL CLEAN-UP of the demo rows (uncomment if you want the data
-- exactly as in 02_data.sql again):
-- DELETE FROM RESULT      WHERE Result_ID = 7025;
-- DELETE FROM ANSWER      WHERE Attempt_ID = 9025;
-- DELETE FROM EXAM_ATTEMPT WHERE Attempt_ID = 9025;
-- ---------------------------------------------------------------------
