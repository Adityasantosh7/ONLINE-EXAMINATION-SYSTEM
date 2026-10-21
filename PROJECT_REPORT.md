# ONLINE EXAMINATION SYSTEM
## PROJECT REPORT — DATABASE MANAGEMENT SYSTEM

**Class:** II-I CSE-C  
**Subject:** Database Management Systems  
**RDBMS Used:** MySQL 8.0 (works on MySQL Workbench / phpMyAdmin / MariaDB)  
**Project files:** `01_schema.sql`, `02_data.sql`, `03_queries.sql`, `04_views.sql`, `05_triggers.sql`

---

# 1. PROBLEM STATEMENT

## 1.1 Background

Examinations in most colleges are still conducted on paper: the question paper is
typed in Word, printed, collected, evaluated by hand and the marks are entered in
an Excel sheet. This process is slow, error-prone, and the results are not available
to the student quickly. As the number of courses, questions and students grows, it
becomes impossible to keep the data consistent, secure and easy to query
("How many students failed in Operating Systems?", "Which is the easiest exam?",
"Show me the mark sheet of roll number 1005" — none of these can be answered
instantly from paper records).

## 1.2 Proposed System

The **Online Examination System** is a database-driven application that manages the
complete life cycle of an online examination:

> **Registration & enrolment → question-paper creation → exam scheduling →
> student attempt → automatic evaluation → result publication → reports.**

All data is stored in a relational database, so redundancy is controlled, integrity
is enforced by the DBMS itself (keys, constraints, triggers), and any report can be
produced instantly with an SQL query.

## 1.3 Users of the System

| User | What he/she does in the system |
|---|---|
| **Student** | Registers, enrols in courses, views the exam schedule, attempts a published exam, views the graded result / mark sheet |
| **Instructor (Faculty)** | Creates and updates courses, uploads the question paper with options and answer key, schedules exams, views course-wise performance analytics |
| **Administrator** | Maintains the master data (students, instructors, courses), monitors exams, publishes results, generates reports |

## 1.4 Functional Requirements

1. Store student, instructor and course information (with unique e-mail / phone).
2. A student may enrol in **many** courses and a course may have **many** students.
3. An instructor teaches one or more courses; each course is offered in the system.
4. An instructor creates an exam for a course and uploads MCQ questions, each with
   four options and exactly one correct option.
5. A student attempts a scheduled exam; **only one attempt per student per exam**
   is allowed (enforced by a UNIQUE constraint).
6. Every selected option is stored; the marks of each answer are added up
   automatically (trigger) to produce the total marks of the attempt.
7. Percentage, grade (A/B/C/D/F) and PASS/FAIL status are computed and published
   (auto-computed by a trigger).
8. Reports: mark sheet, course-wise average, pass/fail counts, topper of an exam,
   upcoming exam schedule, students who never attempted an exam, etc.

## 1.5 Scope / Feasibility

* Handles 20+ exams, question papers, answer keys, attempts and results in the
  sample data — scales to thousands of rows without any change in design.
* All queries run on standard SQL, so the design can be ported to Oracle/PostgreSQL
  with minor syntax changes.
* Security (login), web front-end and auto-proctoring are **outside the scope** of
  this DBMS project — only the database design, constraints, queries, views and
  triggers are implemented.

---
