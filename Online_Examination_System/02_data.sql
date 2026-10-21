-- =====================================================================
--  PROJECT : ONLINE EXAMINATION SYSTEM   (DBMS Mini Project)
--  File    : 02_data.sql
--  Run this file AFTER 01_schema.sql
--
--  Record counts (main tables have 20+ records):
--    STUDENT ........ 23      EXAM .............. 20
--    INSTRUCTOR ..... 6       QUESTION .......... 24
--    COURSE ......... 10      QUESTION_OPTION ... 96
--    ENROLLMENT ..... 37      EXAM_ATTEMPT ...... 24
--    ANSWER ......... 96      RESULT ............ 24
-- =====================================================================

USE Online_Examination_System;

-- ---------------------------------------------------------------------
-- 1. STUDENT (23 records)
--    NOTE: student 1023 has NOT yet enrolled in any course and has not
--          attempted any exam - used to demonstrate LEFT JOIN / NOT
--          EXISTS (optional / partial participation cases).
-- ---------------------------------------------------------------------
INSERT INTO STUDENT (Student_ID, Student_Name, Email, Phone, Department, Year_Of_Study) VALUES
(1001,'AARAV SHARMA',     'aarav.sharma@student.college.edu',     '9876500001','CSE',2),
(1002,'PRIYA IYER',       'priya.iyer@student.college.edu',       '9876500002','CSE',2),
(1003,'ROHAN MEHTA',      'rohan.mehta@student.college.edu',      '9876500003','CSE',2),
(1004,'ANANYA DAS',       'ananya.das@student.college.edu',       '9876500004','CSE',2),
(1005,'KARTHIK REDDY',    'karthik.reddy@student.college.edu',    '9876500005','CSE',2),
(1006,'SNEHA PATIL',      'sneha.patil@student.college.edu',      '9876500006','CSE',2),
(1007,'ARJUN NAIR',       'arjun.nair@student.college.edu',       '9876500007','CSE',2),
(1008,'DIVYA MENON',      'divya.menon@student.college.edu',      '9876500008','CSE',2),
(1009,'VIKRAM SINGH',     'vikram.singh@student.college.edu',     '9876500009','CSE',2),
(1010,'MEERA JOSHI',      'meera.joshi@student.college.edu',      '9876500010','CSE',2),
(1011,'ADITYA GUPTA',     'aditya.gupta@student.college.edu',     '9876500011','CSE',2),
(1012,'POOJA KULKARNI',   'pooja.kulkarni@student.college.edu',   '9876500012','CSE',2),
(1013,'SANDEEP KUMAR',    'sandeep.kumar@student.college.edu',    '9876500013','CSE',2),
(1014,'NISHA RAO',        'nisha.rao@student.college.edu',        '9876500014','CSE',2),
(1015,'ARUN PILLAI',      'arun.pillai@student.college.edu',      '9876500015','CSE',2),
(1016,'RIYA BANERJEE',    'riya.banerjee@student.college.edu',    '9876500016','CSE',2),
(1017,'MANISH VERMA',     'manish.verma@student.college.edu',     '9876500017','CSE',2),
(1018,'KAVYA SHETTY',     'kavya.shetty@student.college.edu',     '9876500018','IT', 2),
(1019,'SIDDHARTH JAIN',   'siddharth.jain@student.college.edu',   '9876500019','CSE',2),
(1020,'ANJALI CHOUDHARY', 'anjali.choudhary@student.college.edu', '9876500020','IT', 2),
(1021,'HARSHA VARDHAN',   'harsha.vardhan@student.college.edu',   '9876500021','CSE',2),
(1022,'TANVI DESHPANDE',  'tanvi.deshpande@student.college.edu',  '9876500022','CSE',2),
(1023,'GOUTHAM REDDY',    'goutham.reddy@student.college.edu',    '9876500023','ECE',1);

-- ---------------------------------------------------------------------
-- 2. INSTRUCTOR (6 records)
-- ---------------------------------------------------------------------
INSERT INTO INSTRUCTOR (Instructor_ID, Instructor_Name, Email, Department, Specialization) VALUES
(501,'DR. S. RAMKUMAR',    'ramkumar@college.edu',    'CSE',         'DATABASE SYSTEMS'),
(502,'DR. MEENAKSHI NAIR', 'meenakshi@college.edu',   'CSE',         'OPERATING SYSTEMS'),
(503,'PROF. R. THOMAS',    'rthomas@college.edu',     'CSE',         'COMPUTER NETWORKS'),
(504,'DR. ANIL KAPOOR',    'anil.kapoor@college.edu', 'CSE',         'ALGORITHMS & DATA STRUCTURES'),
(505,'DR. LAKSHMI PRIYA',  'lakshmi@college.edu',     'MATHEMATICS', 'DISCRETE MATHEMATICS'),
(506,'PROF. VIJAY KULKARNI','vijayk@college.edu',     'CSE',         'SOFTWARE ENGINEERING');

-- ---------------------------------------------------------------------
-- 3. COURSE (10 records)
-- ---------------------------------------------------------------------
INSERT INTO COURSE (Course_ID, Course_Name, Credits, Department, Instructor_ID) VALUES
(10,'DATABASE MANAGEMENT SYSTEMS',   4,'CSE',        501),
(11,'OPERATING SYSTEMS',             4,'CSE',        502),
(12,'COMPUTER NETWORKS',             3,'CSE',        503),
(13,'DATA STRUCTURES & ALGORITHMS',  4,'CSE',        504),
(14,'JAVA PROGRAMMING',              3,'CSE',        501),
(15,'DISCRETE MATHEMATICS',          3,'MATHEMATICS',505),
(16,'SOFTWARE ENGINEERING',          3,'CSE',        506),
(17,'THEORY OF COMPUTATION',         3,'CSE',        504),
(18,'WEB TECHNOLOGIES',              3,'CSE',        506),
(19,'NUMERICAL METHODS',             3,'MATHEMATICS',505);

-- ---------------------------------------------------------------------
-- 4. ENROLLMENT (37 records)  -- STUDENT M:N COURSE
-- ---------------------------------------------------------------------
INSERT INTO ENROLLMENT (Student_ID, Course_ID, Enroll_Date, Status) VALUES
(1001,10,'2026-07-15','ACTIVE'),
(1001,15,'2026-07-15','ACTIVE'),
(1002,10,'2026-07-15','ACTIVE'),
(1003,10,'2026-07-16','ACTIVE'),
(1003,13,'2026-07-16','ACTIVE'),
(1004,10,'2026-07-16','ACTIVE'),
(1004,11,'2026-07-16','ACTIVE'),
(1005,11,'2026-07-17','ACTIVE'),
(1005,15,'2026-07-17','ACTIVE'),
(1006,11,'2026-07-17','ACTIVE'),
(1007,11,'2026-07-18','ACTIVE'),
(1007,12,'2026-07-18','ACTIVE'),
(1008,11,'2026-07-18','ACTIVE'),
(1008,14,'2026-07-18','ACTIVE'),
(1009,12,'2026-07-19','ACTIVE'),
(1010,12,'2026-07-19','ACTIVE'),
(1010,13,'2026-07-19','ACTIVE'),
(1011,12,'2026-07-20','ACTIVE'),
(1012,12,'2026-07-20','ACTIVE'),
(1012,15,'2026-07-20','ACTIVE'),
(1013,13,'2026-07-21','ACTIVE'),
(1014,13,'2026-07-21','ACTIVE'),
(1014,14,'2026-07-21','ACTIVE'),
(1015,13,'2026-07-22','ACTIVE'),
(1015,16,'2026-07-22','DROPPED'),
(1016,13,'2026-07-22','ACTIVE'),
(1016,11,'2026-07-22','DROPPED'),
(1017,14,'2026-07-23','ACTIVE'),
(1018,14,'2026-07-23','ACTIVE'),
(1018,10,'2026-07-23','ACTIVE'),
(1019,14,'2026-07-24','ACTIVE'),
(1019,12,'2026-07-24','ACTIVE'),
(1020,14,'2026-07-24','ACTIVE'),
(1020,16,'2026-07-24','ACTIVE'),
(1021,15,'2026-07-25','ACTIVE'),
(1022,15,'2026-07-25','ACTIVE'),
(1022,13,'2026-07-25','ACTIVE');

-- ---------------------------------------------------------------------
-- 5. EXAM (20 records)
--    Exams 201-206 are COMPLETED (questions + attempts exist).
--    Exams 207-220 are SCHEDULED / UPCOMING (question paper is yet to
--    be uploaded by the instructor - realistic in a live system).
-- ---------------------------------------------------------------------
INSERT INTO EXAM (Exam_ID, Exam_Title, Course_ID, Exam_Date, Duration_Minutes, Total_Marks, Exam_Type) VALUES
(201,'DBMS MIDTERM - I',              10,'2026-08-14',180,100,'MIDTERM'),
(202,'OS QUIZ - 2',                   11,'2026-08-21', 45,100,'QUIZ'),
(203,'COMPUTER NETWORKS UNIT TEST',   12,'2026-08-28', 60,100,'UNIT TEST'),
(204,'DSA MIDTERM - I',               13,'2026-09-04',180,100,'MIDTERM'),
(205,'JAVA PROGRAMMING TEST',         14,'2026-09-11', 90,100,'UNIT TEST'),
(206,'DISCRETE MATHS QUIZ - 1',       15,'2026-09-18', 45,100,'QUIZ'),
(207,'DBMS MIDTERM - II',             10,'2026-10-25',180,100,'MIDTERM'),
(208,'OS MIDTERM - I',                11,'2026-10-27',180,100,'MIDTERM'),
(209,'COMPUTER NETWORKS QUIZ - 2',    12,'2026-10-30', 45,100,'QUIZ'),
(210,'DSA MIDTERM - II',              13,'2026-11-03',180,100,'MIDTERM'),
(211,'JAVA PROGRAMMING MIDTERM - I',  14,'2026-11-06',180,100,'MIDTERM'),
(212,'DISCRETE MATHS MIDTERM',        15,'2026-11-09',180,100,'MIDTERM'),
(213,'SOFTWARE ENGINEERING UNIT TEST',16,'2026-11-12', 60,100,'UNIT TEST'),
(214,'THEORY OF COMPUTATION QUIZ - 1',17,'2026-11-16', 45,100,'QUIZ'),
(215,'WEB TECHNOLOGIES UNIT TEST',    18,'2026-11-19', 60,100,'UNIT TEST'),
(216,'NUMERICAL METHODS QUIZ - 1',    19,'2026-11-23', 45,100,'QUIZ'),
(217,'DBMS FINAL EXAM',               10,'2026-11-27',180,100,'FINAL'),
(218,'OPERATING SYSTEMS FINAL EXAM',  11,'2026-12-01',180,100,'FINAL'),
(219,'DSA FINAL EXAM',                13,'2026-12-04',180,100,'FINAL'),
(220,'COMPUTER NETWORKS FINAL EXAM',  12,'2026-12-08',180,100,'FINAL');

-- ---------------------------------------------------------------------
-- 6. QUESTION (24 records) -- WEAK ENTITY of EXAM
--    4 questions x 6 completed exams, each question = 25 marks
--    (4 x 25 = 100 = Total_Marks of the exam)
-- ---------------------------------------------------------------------
INSERT INTO QUESTION (Exam_ID, Question_No, Question_Text, Question_Type, Marks) VALUES
(201,1,'WHICH OF THE FOLLOWING IS A KEY IN A RELATIONAL DATABASE?','MCQ',25),
(201,2,'WHICH SQL COMMAND DELETES ALL ROWS BUT KEEPS THE TABLE STRUCTURE?','MCQ',25),
(201,3,'IN AN ER DIAGRAM A RECTANGLE REPRESENTS WHICH OF THE FOLLOWING?','MCQ',25),
(201,4,'WHICH NORMAL FORM REMOVES TRANSITIVE DEPENDENCY?','MCQ',25),
(202,1,'WHICH SCHEDULING ALGORITHM MAY STARVE LONG JOBS?','MCQ',25),
(202,2,'A PROCESS IN THE READY STATE IS WAITING FOR?','MCQ',25),
(202,3,'WHICH TECHNIQUE DIVIDES MEMORY INTO FIXED SIZE FRAMES?','MCQ',25),
(202,4,'WHICH IS A NECESSARY CONDITION FOR DEADLOCK?','MCQ',25),
(203,1,'WHICH OSI LAYER IS RESPONSIBLE FOR ROUTING?','MCQ',25),
(203,2,'WHAT IS THE DEFAULT PORT NUMBER OF HTTPS?','MCQ',25),
(203,3,'TCP IS WHICH TYPE OF TRANSPORT PROTOCOL?','MCQ',25),
(203,4,'WHICH DEVICE OPERATES AT THE DATA LINK LAYER?','MCQ',25),
(204,1,'WORST CASE TIME COMPLEXITY OF BINARY SEARCH IS?','MCQ',25),
(204,2,'WHICH DATA STRUCTURE FOLLOWS THE LIFO PRINCIPLE?','MCQ',25),
(204,3,'IN A MIN HEAP THE SMALLEST ELEMENT IS STORED AT?','MCQ',25),
(204,4,'WHICH TRAVERSAL OF A BST PRODUCES SORTED ORDER?','MCQ',25),
(205,1,'WHICH KEYWORD IS USED TO INHERIT A CLASS IN JAVA?','MCQ',25),
(205,2,'WHICH OF THE FOLLOWING IS NOT A PRIMITIVE TYPE IN JAVA?','MCQ',25),
(205,3,'METHOD OVERLOADING IS AN EXAMPLE OF?','MCQ',25),
(205,4,'WHICH PACKAGE CONTAINS THE SCANNER CLASS?','MCQ',25),
(206,1,'A SET WITH 4 ELEMENTS HAS HOW MANY SUBSETS?','MCQ',25),
(206,2,'WHAT IS THE CONTRAPOSITIVE OF P IMPLIES Q?','MCQ',25),
(206,3,'THE NUMBER OF PERMUTATIONS OF 4 DISTINCT OBJECTS IS?','MCQ',25),
(206,4,'WHICH OF THE FOLLOWING IS A TAUTOLOGY?','MCQ',25);

-- ---------------------------------------------------------------------
-- 7. QUESTION_OPTION (96 records = 24 questions x 4 options)
--    Is_Correct = YES for exactly one option per question.
-- ---------------------------------------------------------------------
INSERT INTO QUESTION_OPTION (Exam_ID, Question_No, Option_Label, Option_Text, Is_Correct) VALUES
-- EXAM 201 : DBMS
(201,1,'A','PRIMARY KEY',              'NO'),
(201,1,'B','CANDIDATE KEY',            'NO'),
(201,1,'C','FOREIGN KEY',              'NO'),
(201,1,'D','ALL OF THESE',             'YES'),
(201,2,'A','DELETE',                   'NO'),
(201,2,'B','DROP',                     'NO'),
(201,2,'C','TRUNCATE',                 'YES'),
(201,2,'D','REMOVE',                   'NO'),
(201,3,'A','ATTRIBUTE',                'NO'),
(201,3,'B','ENTITY',                   'YES'),
(201,3,'C','RELATIONSHIP',             'NO'),
(201,3,'D','CARDINALITY',              'NO'),
(201,4,'A','1NF',                      'NO'),
(201,4,'B','2NF',                      'NO'),
(201,4,'C','3NF',                      'YES'),
(201,4,'D','BCNF',                     'NO'),
-- EXAM 202 : OPERATING SYSTEMS
(202,1,'A','FIRST COME FIRST SERVE',   'NO'),
(202,1,'B','SHORTEST JOB FIRST',       'YES'),
(202,1,'C','ROUND ROBIN',              'NO'),
(202,1,'D','FIFO',                     'NO'),
(202,2,'A','I/O COMPLETION',           'NO'),
(202,2,'B','DEADLOCK',                 'NO'),
(202,2,'C','CPU ALLOCATION',           'YES'),
(202,2,'D','TERMINATION',              'NO'),
(202,3,'A','PAGING',                   'YES'),
(202,3,'B','SEGMENTATION',             'NO'),
(202,3,'C','SWAPPING',                 'NO'),
(202,3,'D','VIRTUAL MEMORY',           'NO'),
(202,4,'A','STARVATION',               'NO'),
(202,4,'B','DEADLOCK',                 'YES'),
(202,4,'C','THRASHING',                'NO'),
(202,4,'D','SPOOLING',                 'NO'),
-- EXAM 203 : COMPUTER NETWORKS
(203,1,'A','DATA LINK LAYER',          'NO'),
(203,1,'B','NETWORK LAYER',            'YES'),
(203,1,'C','TRANSPORT LAYER',          'NO'),
(203,1,'D','SESSION LAYER',            'NO'),
(203,2,'A','21',                       'NO'),
(203,2,'B','25',                       'NO'),
(203,2,'C','443',                      'YES'),
(203,2,'D','80',                       'NO'),
(203,3,'A','WIRELESS',                 'NO'),
(203,3,'B','CONNECTIONLESS',           'NO'),
(203,3,'C','OPTICAL',                  'NO'),
(203,3,'D','CONNECTION ORIENTED',       'YES'),
(203,4,'A','HUB',                      'NO'),
(203,4,'B','REPEATER',                 'NO'),
(203,4,'C','SWITCH',                   'YES'),
(203,4,'D','MODEM',                    'NO'),
-- EXAM 204 : DATA STRUCTURES & ALGORITHMS
(204,1,'A','O(N)',                     'NO'),
(204,1,'B','O(LOG N)',                 'YES'),
(204,1,'C','O(N LOG N)',               'NO'),
(204,1,'D','O(1)',                     'NO'),
(204,2,'A','QUEUE',                    'NO'),
(204,2,'B','ARRAY',                    'NO'),
(204,2,'C','STACK',                    'YES'),
(204,2,'D','TREE',                     'NO'),
(204,3,'A','LAST LEAF',                'NO'),
(204,3,'B','ROOT NODE',                'YES'),
(204,3,'C','ANY INTERNAL NODE',        'NO'),
(204,3,'D','RANDOM POSITION',          'NO'),
(204,4,'A','PREORDER',                 'NO'),
(204,4,'B','POSTORDER',                'NO'),
(204,4,'C','LEVEL ORDER',              'NO'),
(204,4,'D','INORDER',                  'YES'),
-- EXAM 205 : JAVA PROGRAMMING
(205,1,'A','IMPLEMENTS',               'NO'),
(205,1,'B','EXTENDS',                  'YES'),
(205,1,'C','INHERITS',                 'NO'),
(205,1,'D','SUPER',                    'NO'),
(205,2,'A','INT',                      'NO'),
(205,2,'B','BOOLEAN',                  'NO'),
(205,2,'C','STRING',                   'YES'),
(205,2,'D','CHAR',                     'NO'),
(205,3,'A','COMPILE TIME POLYMORPHISM','YES'),
(205,3,'B','RUNTIME POLYMORPHISM',     'NO'),
(205,3,'C','INHERITANCE',              'NO'),
(205,3,'D','ENCAPSULATION',            'NO'),
(205,4,'A','JAVA.IO',                  'NO'),
(205,4,'B','JAVA.NET',                 'NO'),
(205,4,'C','JAVA.UTIL',                'YES'),
(205,4,'D','JAVA.LANG',                'NO'),
-- EXAM 206 : DISCRETE MATHEMATICS
(206,1,'A','8',                        'NO'),
(206,1,'B','16',                       'YES'),
(206,1,'C','32',                       'NO'),
(206,1,'D','4',                        'NO'),
(206,2,'A','Q IMPLIES NOT P',          'NO'),
(206,2,'B','NOT P IMPLIES Q',          'NO'),
(206,2,'C','NOT Q IMPLIES NOT P',      'YES'),
(206,2,'D','P IMPLIES NOT Q',          'NO'),
(206,3,'A','24',                       'YES'),
(206,3,'B','16',                       'NO'),
(206,3,'C','12',                       'NO'),
(206,3,'D','4',                        'NO'),
(206,4,'A','P AND NOT P',              'NO'),
(206,4,'B','P AND Q',                  'NO'),
(206,4,'C','NOT P',                    'NO'),
(206,4,'D','P IMPLIES P',              'YES');

-- ---------------------------------------------------------------------
-- 8. EXAM_ATTEMPT (24 records) -- STUDENT M:N EXAM
--    Marks_Obtained = sum of Marks_Scored in ANSWER (4 questions x 25)
-- ---------------------------------------------------------------------
INSERT INTO EXAM_ATTEMPT (Attempt_ID, Student_ID, Exam_ID, Attempt_Date, Status, Marks_Obtained) VALUES
(9001,1001,201,'2026-08-14','COMPLETED',100),
(9002,1002,201,'2026-08-14','COMPLETED', 75),
(9003,1003,201,'2026-08-14','COMPLETED', 50),
(9004,1004,201,'2026-08-14','COMPLETED', 25),
(9005,1005,202,'2026-08-21','COMPLETED',100),
(9006,1006,202,'2026-08-21','COMPLETED', 75),
(9007,1007,202,'2026-08-21','COMPLETED', 50),
(9008,1008,202,'2026-08-21','COMPLETED',100),
(9009,1009,203,'2026-08-28','COMPLETED', 75),
(9010,1010,203,'2026-08-28','COMPLETED', 50),
(9011,1011,203,'2026-08-28','COMPLETED',100),
(9012,1012,203,'2026-08-28','COMPLETED',  0),
(9013,1013,204,'2026-09-04','COMPLETED',100),
(9014,1014,204,'2026-09-04','COMPLETED', 75),
(9015,1015,204,'2026-09-04','COMPLETED', 75),
(9016,1016,204,'2026-09-04','COMPLETED', 50),
(9017,1017,205,'2026-09-11','COMPLETED', 50),
(9018,1018,205,'2026-09-11','COMPLETED',100),
(9019,1019,205,'2026-09-11','COMPLETED', 75),
(9020,1020,205,'2026-09-11','COMPLETED', 25),
(9021,1021,206,'2026-09-18','COMPLETED', 75),
(9022,1022,206,'2026-09-18','COMPLETED', 50),
(9023,1001,206,'2026-09-18','COMPLETED',100),
(9024,1005,206,'2026-09-18','COMPLETED', 75);

-- ---------------------------------------------------------------------
-- 9. ANSWER (96 records = 24 attempts x 4 questions)
--    Selected_Label matches the correct option when Is_Correct = YES.
-- ---------------------------------------------------------------------
INSERT INTO ANSWER (Attempt_ID, Exam_ID, Question_No, Selected_Label, Is_Correct, Marks_Scored) VALUES
-- ATTEMPT 9001 (100/100) - exam 201, correct = D C B C
(9001,201,1,'D','YES',25),(9001,201,2,'C','YES',25),(9001,201,3,'B','YES',25),(9001,201,4,'C','YES',25),
-- ATTEMPT 9002 (75) - Q2 wrong
(9002,201,1,'D','YES',25),(9002,201,2,'A','NO',0),(9002,201,3,'B','YES',25),(9002,201,4,'C','YES',25),
-- ATTEMPT 9003 (50) - Q1, Q4 wrong
(9003,201,1,'A','NO',0),(9003,201,2,'C','YES',25),(9003,201,3,'B','YES',25),(9003,201,4,'A','NO',0),
-- ATTEMPT 9004 (25) - only Q3 correct
(9004,201,1,'A','NO',0),(9004,201,2,'A','NO',0),(9004,201,3,'B','YES',25),(9004,201,4,'A','NO',0),
-- ATTEMPT 9005 (100) - exam 202, correct = B C A B
(9005,202,1,'B','YES',25),(9005,202,2,'C','YES',25),(9005,202,3,'A','YES',25),(9005,202,4,'B','YES',25),
-- ATTEMPT 9006 (75) - Q4 wrong
(9006,202,1,'B','YES',25),(9006,202,2,'C','YES',25),(9006,202,3,'A','YES',25),(9006,202,4,'A','NO',0),
-- ATTEMPT 9007 (50) - Q3, Q4 wrong
(9007,202,1,'B','YES',25),(9007,202,2,'C','YES',25),(9007,202,3,'B','NO',0),(9007,202,4,'A','NO',0),
-- ATTEMPT 9008 (100)
(9008,202,1,'B','YES',25),(9008,202,2,'C','YES',25),(9008,202,3,'A','YES',25),(9008,202,4,'B','YES',25),
-- ATTEMPT 9009 (75) - exam 203, correct = B C D C
(9009,203,1,'A','NO',0),(9009,203,2,'C','YES',25),(9009,203,3,'D','YES',25),(9009,203,4,'C','YES',25),
-- ATTEMPT 9010 (50) - Q2, Q3 wrong
(9010,203,1,'B','YES',25),(9010,203,2,'A','NO',0),(9010,203,3,'A','NO',0),(9010,203,4,'C','YES',25),
-- ATTEMPT 9011 (100)
(9011,203,1,'B','YES',25),(9011,203,2,'C','YES',25),(9011,203,3,'D','YES',25),(9011,203,4,'C','YES',25),
-- ATTEMPT 9012 (0) - all wrong
(9012,203,1,'A','NO',0),(9012,203,2,'A','NO',0),(9012,203,3,'A','NO',0),(9012,203,4,'A','NO',0),
-- ATTEMPT 9013 (100) - exam 204, correct = B C B D
(9013,204,1,'B','YES',25),(9013,204,2,'C','YES',25),(9013,204,3,'B','YES',25),(9013,204,4,'D','YES',25),
-- ATTEMPT 9014 (75) - Q3 wrong
(9014,204,1,'B','YES',25),(9014,204,2,'C','YES',25),(9014,204,3,'A','NO',0),(9014,204,4,'D','YES',25),
-- ATTEMPT 9015 (75) - Q1 wrong
(9015,204,1,'A','NO',0),(9015,204,2,'C','YES',25),(9015,204,3,'B','YES',25),(9015,204,4,'D','YES',25),
-- ATTEMPT 9016 (50) - Q2, Q4 wrong
(9016,204,1,'B','YES',25),(9016,204,2,'A','NO',0),(9016,204,3,'B','YES',25),(9016,204,4,'A','NO',0),
-- ATTEMPT 9017 (50) - exam 205, correct = B C A C; Q1, Q3 wrong
(9017,205,1,'A','NO',0),(9017,205,2,'C','YES',25),(9017,205,3,'B','NO',0),(9017,205,4,'C','YES',25),
-- ATTEMPT 9018 (100)
(9018,205,1,'B','YES',25),(9018,205,2,'C','YES',25),(9018,205,3,'A','YES',25),(9018,205,4,'C','YES',25),
-- ATTEMPT 9019 (75) - Q2 wrong
(9019,205,1,'B','YES',25),(9019,205,2,'A','NO',0),(9019,205,3,'A','YES',25),(9019,205,4,'C','YES',25),
-- ATTEMPT 9020 (25) - only Q3 correct
(9020,205,1,'A','NO',0),(9020,205,2,'A','NO',0),(9020,205,3,'A','YES',25),(9020,205,4,'A','NO',0),
-- ATTEMPT 9021 (75) - exam 206, correct = B C A D; Q4 wrong
(9021,206,1,'B','YES',25),(9021,206,2,'C','YES',25),(9021,206,3,'A','YES',25),(9021,206,4,'A','NO',0),
-- ATTEMPT 9022 (50) - Q1, Q3 wrong
(9022,206,1,'A','NO',0),(9022,206,2,'C','YES',25),(9022,206,3,'B','NO',0),(9022,206,4,'D','YES',25),
-- ATTEMPT 9023 (100)
(9023,206,1,'B','YES',25),(9023,206,2,'C','YES',25),(9023,206,3,'A','YES',25),(9023,206,4,'D','YES',25),
-- ATTEMPT 9024 (75) - Q1 wrong
(9024,206,1,'A','NO',0),(9024,206,2,'C','YES',25),(9024,206,3,'A','YES',25),(9024,206,4,'D','YES',25);

-- ---------------------------------------------------------------------
-- 10. RESULT (24 records) -- 1 : 1 with EXAM_ATTEMPT
--     Grade rule : A >= 80, B >= 70, C >= 60, D >= 50, else F
--     Status     : PASS if Percentage >= 50 else FAIL
--     Published  : 3 days after the attempt
-- ---------------------------------------------------------------------
INSERT INTO RESULT (Result_ID, Attempt_ID, Percentage, Grade, Status, Published_Date) VALUES
(7001,9001,100.00,'A','PASS','2026-08-17'),
(7002,9002, 75.00,'B','PASS','2026-08-17'),
(7003,9003, 50.00,'D','PASS','2026-08-17'),
(7004,9004, 25.00,'F','FAIL','2026-08-17'),
(7005,9005,100.00,'A','PASS','2026-08-24'),
(7006,9006, 75.00,'B','PASS','2026-08-24'),
(7007,9007, 50.00,'D','PASS','2026-08-24'),
(7008,9008,100.00,'A','PASS','2026-08-24'),
(7009,9009, 75.00,'B','PASS','2026-08-31'),
(7010,9010, 50.00,'D','PASS','2026-08-31'),
(7011,9011,100.00,'A','PASS','2026-08-31'),
(7012,9012,  0.00,'F','FAIL','2026-08-31'),
(7013,9013,100.00,'A','PASS','2026-09-07'),
(7014,9014, 75.00,'B','PASS','2026-09-07'),
(7015,9015, 75.00,'B','PASS','2026-09-07'),
(7016,9016, 50.00,'D','PASS','2026-09-07'),
(7017,9017, 50.00,'D','PASS','2026-09-14'),
(7018,9018,100.00,'A','PASS','2026-09-14'),
(7019,9019, 75.00,'B','PASS','2026-09-14'),
(7020,9020, 25.00,'F','FAIL','2026-09-14'),
(7021,9021, 75.00,'B','PASS','2026-09-21'),
(7022,9022, 50.00,'D','PASS','2026-09-21'),
(7023,9023,100.00,'A','PASS','2026-09-21'),
(7024,9024, 75.00,'B','PASS','2026-09-21');

-- ---------------------------------------------------------------------
-- Verification : record count of every table
-- ---------------------------------------------------------------------
SELECT 'STUDENT'         AS TABLE_NAME, COUNT(*) AS RECORDS FROM STUDENT
UNION ALL SELECT 'INSTRUCTOR',      COUNT(*) FROM INSTRUCTOR
UNION ALL SELECT 'COURSE',          COUNT(*) FROM COURSE
UNION ALL SELECT 'ENROLLMENT',      COUNT(*) FROM ENROLLMENT
UNION ALL SELECT 'EXAM',            COUNT(*) FROM EXAM
UNION ALL SELECT 'QUESTION',        COUNT(*) FROM QUESTION
UNION ALL SELECT 'QUESTION_OPTION', COUNT(*) FROM QUESTION_OPTION
UNION ALL SELECT 'EXAM_ATTEMPT',    COUNT(*) FROM EXAM_ATTEMPT
UNION ALL SELECT 'ANSWER',          COUNT(*) FROM ANSWER
UNION ALL SELECT 'RESULT',          COUNT(*) FROM RESULT;
