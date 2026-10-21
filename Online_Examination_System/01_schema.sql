-- =====================================================================
--  PROJECT : ONLINE EXAMINATION SYSTEM
--  Subject : DATABASE MANAGEMENT SYSTEM  (II-II CSE-A)
--  File    : 01_schema.sql
--  RDBMS   : MySQL 8.0 or above (also works on MariaDB 10.4+)
--
--  Run this file FIRST. It creates the database and all 10 tables
--  with PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, CHECK, DEFAULT
--  constraints.
-- =====================================================================

CREATE DATABASE IF NOT EXISTS Online_Examination_System;
USE Online_Examination_System;

-- ---------------------------------------------------------------------
-- Reverse-order clean-up (so the script can be re-run any number of
-- times without "table already exists" / "cannot drop table" errors)
-- ---------------------------------------------------------------------
DROP TABLE IF EXISTS RESULT;
DROP TABLE IF EXISTS ANSWER;
DROP TABLE IF EXISTS EXAM_ATTEMPT;
DROP TABLE IF EXISTS QUESTION_OPTION;
DROP TABLE IF EXISTS QUESTION;
DROP TABLE IF EXISTS EXAM;
DROP TABLE IF EXISTS ENROLLMENT;
DROP TABLE IF EXISTS COURSE;
DROP TABLE IF EXISTS INSTRUCTOR;
DROP TABLE IF EXISTS STUDENT;

-- =====================================================================
-- TABLE 1 : STUDENT  (Strong Entity)
-- =====================================================================
CREATE TABLE STUDENT (
    Student_ID    INT          NOT NULL,
    Student_Name  VARCHAR(60)  NOT NULL,
    Email         VARCHAR(80)  NOT NULL,
    Phone         VARCHAR(15)  NOT NULL,
    Department    VARCHAR(30)  NOT NULL DEFAULT 'CSE',
    Year_Of_Study TINYINT      NOT NULL DEFAULT 2,
    CONSTRAINT pk_student       PRIMARY KEY (Student_ID),
    CONSTRAINT uq_student_email UNIQUE (Email),
    CONSTRAINT uq_student_phone UNIQUE (Phone),
    CONSTRAINT ck_student_year  CHECK (Year_Of_Study BETWEEN 1 AND 4)
);

-- =====================================================================
-- TABLE 2 : INSTRUCTOR  (Strong Entity - faculty who teach courses)
-- =====================================================================
CREATE TABLE INSTRUCTOR (
    Instructor_ID   INT          NOT NULL,
    Instructor_Name VARCHAR(60)  NOT NULL,
    Email           VARCHAR(80)  NOT NULL,
    Department      VARCHAR(30)  NOT NULL,
    Specialization  VARCHAR(60)  NOT NULL,
    CONSTRAINT pk_instructor       PRIMARY KEY (Instructor_ID),
    CONSTRAINT uq_instructor_email UNIQUE (Email)
);

-- =====================================================================
-- TABLE 3 : COURSE  (Strong Entity)
-- =====================================================================
CREATE TABLE COURSE (
    Course_ID    INT         NOT NULL,
    Course_Name  VARCHAR(60) NOT NULL,
    Credits      TINYINT     NOT NULL DEFAULT 3,
    Department   VARCHAR(30) NOT NULL,
    Instructor_ID INT        NOT NULL,
    CONSTRAINT pk_course       PRIMARY KEY (Course_ID),
    CONSTRAINT uq_course_name  UNIQUE (Course_Name),
    CONSTRAINT ck_course_credits CHECK (Credits BETWEEN 1 AND 6),
    CONSTRAINT fk_course_instructor
        FOREIGN KEY (Instructor_ID) REFERENCES INSTRUCTOR (Instructor_ID)
        ON UPDATE CASCADE ON DELETE RESTRICT
);

-- =====================================================================
-- TABLE 4 : ENROLLMENT  (Relationship entity - STUDENT M:N COURSE)
-- =====================================================================
CREATE TABLE ENROLLMENT (
    Student_ID  INT   NOT NULL,
    Course_ID   INT   NOT NULL,
    Enroll_Date DATE  NOT NULL DEFAULT (CURRENT_DATE),
    Status      VARCHAR(15) NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT pk_enrollment PRIMARY KEY (Student_ID, Course_ID),
    CONSTRAINT ck_enroll_date CHECK (Enroll_Date >= '2026-01-01'),
    CONSTRAINT ck_enroll_status CHECK (Status IN ('ACTIVE', 'COMPLETED', 'DROPPED')),
    CONSTRAINT fk_enroll_student
        FOREIGN KEY (Student_ID) REFERENCES STUDENT (Student_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_enroll_course
        FOREIGN KEY (Course_ID) REFERENCES COURSE (Course_ID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- =====================================================================
-- TABLE 5 : EXAM  (Strong Entity)
-- =====================================================================
CREATE TABLE EXAM (
    Exam_ID           INT         NOT NULL,
    Exam_Title        VARCHAR(80) NOT NULL,
    Course_ID         INT         NOT NULL,
    Exam_Date         DATE        NOT NULL,
    Duration_Minutes  SMALLINT    NOT NULL DEFAULT 60,
    Total_Marks       SMALLINT    NOT NULL DEFAULT 100,
    Exam_Type         VARCHAR(15) NOT NULL DEFAULT 'MIDTERM',
    CONSTRAINT pk_exam        PRIMARY KEY (Exam_ID),
    CONSTRAINT ck_exam_date   CHECK (Exam_Date >= '2026-01-01'),
    CONSTRAINT ck_exam_time   CHECK (Duration_Minutes BETWEEN 10 AND 240),
    CONSTRAINT ck_exam_marks  CHECK (Total_Marks > 0 AND Total_Marks <= 200),
    CONSTRAINT ck_exam_type   CHECK (Exam_Type IN ('MIDTERM', 'FINAL', 'UNIT TEST', 'QUIZ')),
    CONSTRAINT fk_exam_course
        FOREIGN KEY (Course_ID) REFERENCES COURSE (Course_ID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- =====================================================================
-- TABLE 6 : QUESTION  (WEAK ENTITY - double rectangle in ER diagram)
--           Identified by (Exam_ID, Question_No); it cannot exist
--           without its parent EXAM  ->  TOTAL PARTICIPATION.
-- =====================================================================
CREATE TABLE QUESTION (
    Exam_ID       INT         NOT NULL,
    Question_No   SMALLINT    NOT NULL,
    Question_Text VARCHAR(200) NOT NULL,
    Question_Type VARCHAR(15) NOT NULL DEFAULT 'MCQ',
    Marks         SMALLINT    NOT NULL DEFAULT 1,
    CONSTRAINT pk_question PRIMARY KEY (Exam_ID, Question_No),
    CONSTRAINT ck_q_no      CHECK (Question_No > 0),
    CONSTRAINT ck_q_marks   CHECK (Marks > 0),
    CONSTRAINT ck_q_type    CHECK (Question_Type IN ('MCQ', 'TRUE/FALSE', 'FILL IN THE BLANK')),
    CONSTRAINT fk_q_exam
        FOREIGN KEY (Exam_ID) REFERENCES EXAM (Exam_ID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- =====================================================================
-- TABLE 7 : QUESTION_OPTION  (Second WEAK ENTITY - options of a question)
-- =====================================================================
CREATE TABLE QUESTION_OPTION (
    Exam_ID     INT      NOT NULL,
    Question_No SMALLINT NOT NULL,
    Option_Label CHAR(1) NOT NULL,
    Option_Text VARCHAR(150) NOT NULL,
    Is_Correct  CHAR(3)  NOT NULL DEFAULT 'NO',
    CONSTRAINT pk_option PRIMARY KEY (Exam_ID, Question_No, Option_Label),
    CONSTRAINT ck_opt_label CHECK (Option_Label IN ('A', 'B', 'C', 'D')),
    CONSTRAINT ck_opt_flag  CHECK (Is_Correct IN ('YES', 'NO')),
    CONSTRAINT fk_opt_question
        FOREIGN KEY (Exam_ID, Question_No) REFERENCES QUESTION (Exam_ID, Question_No)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- =====================================================================
-- TABLE 8 : EXAM_ATTEMPT  (Relationship entity - STUDENT M:N EXAM)
-- =====================================================================
CREATE TABLE EXAM_ATTEMPT (
    Attempt_ID     INT   NOT NULL,
    Student_ID     INT   NOT NULL,
    Exam_ID        INT   NOT NULL,
    Attempt_Date   DATE  NOT NULL,
    Status         VARCHAR(15) NOT NULL DEFAULT 'IN PROGRESS',
    Marks_Obtained DECIMAL(5,2) NOT NULL DEFAULT 0,
    CONSTRAINT pk_attempt        PRIMARY KEY (Attempt_ID),
    CONSTRAINT uq_attempt_once   UNIQUE (Student_ID, Exam_ID),
    CONSTRAINT ck_attempt_status CHECK (Status IN ('IN PROGRESS', 'COMPLETED', 'ABSENT')),
    CONSTRAINT ck_attempt_marks  CHECK (Marks_Obtained >= 0),
    CONSTRAINT fk_attempt_student
        FOREIGN KEY (Student_ID) REFERENCES STUDENT (Student_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_attempt_exam
        FOREIGN KEY (Exam_ID) REFERENCES EXAM (Exam_ID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- =====================================================================
-- TABLE 9 : ANSWER  (Relationship entity - EXAM_ATTEMPT M:N QUESTION,
--                    also a weak entity of EXAM_ATTEMPT)
-- =====================================================================
CREATE TABLE ANSWER (
    Attempt_ID     INT      NOT NULL,
    Exam_ID        INT      NOT NULL,
    Question_No    SMALLINT NOT NULL,
    Selected_Label CHAR(1)  NOT NULL,
    Is_Correct     CHAR(3)  NOT NULL DEFAULT 'NO',
    Marks_Scored   DECIMAL(5,2) NOT NULL DEFAULT 0,
    CONSTRAINT pk_answer PRIMARY KEY (Attempt_ID, Exam_ID, Question_No),
    CONSTRAINT ck_ans_label CHECK (Selected_Label IN ('A', 'B', 'C', 'D')),
    CONSTRAINT ck_ans_flag  CHECK (Is_Correct IN ('YES', 'NO')),
    CONSTRAINT ck_ans_marks CHECK (Marks_Scored >= 0),
    CONSTRAINT fk_ans_attempt
        FOREIGN KEY (Attempt_ID) REFERENCES EXAM_ATTEMPT (Attempt_ID)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_ans_question
        FOREIGN KEY (Exam_ID, Question_No) REFERENCES QUESTION (Exam_ID, Question_No)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- =====================================================================
-- TABLE 10 : RESULT  (1 : 1 with EXAM_ATTEMPT - one result per attempt)
-- =====================================================================
CREATE TABLE RESULT (
    Result_ID      INT   NOT NULL,
    Attempt_ID     INT   NOT NULL,
    Percentage     DECIMAL(5,2) NOT NULL DEFAULT 0,
    Grade          CHAR(2) NOT NULL DEFAULT 'F',
    Status         VARCHAR(10) NOT NULL DEFAULT 'FAIL',
    Published_Date DATE   NOT NULL,
    CONSTRAINT pk_result        PRIMARY KEY (Result_ID),
    CONSTRAINT uq_result_attempt UNIQUE (Attempt_ID),
    CONSTRAINT ck_res_percent   CHECK (Percentage BETWEEN 0 AND 100),
    CONSTRAINT ck_res_grade     CHECK (Grade IN ('A', 'B', 'C', 'D', 'F')),
    CONSTRAINT ck_res_status    CHECK (Status IN ('PASS', 'FAIL')),
    CONSTRAINT fk_result_attempt
        FOREIGN KEY (Attempt_ID) REFERENCES EXAM_ATTEMPT (Attempt_ID)
        ON UPDATE CASCADE ON DELETE CASCADE
);

-- ---------------------------------------------------------------------
-- Verification : list every table created in this database
-- ---------------------------------------------------------------------
SHOW TABLES;
