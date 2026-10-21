# ONLINE EXAMINATION SYSTEM
### DBMS Mini Project — II-II CSE-A

A complete, ready-to-submit MySQL project: problem statement, ER diagram
specification, tables with constraints, 20+ records per table, SQL queries,
views, triggers, captured outputs and full project report.

---

## Files & Execution Order

| # | File | What it does |
|---|------|--------------|
| 1 | `01_schema.sql` | Creates database `Online_Examination_System` and **10 tables** with PRIMARY KEY, FOREIGN KEY, NOT NULL, UNIQUE, CHECK, DEFAULT constraints |
| 2 | `02_data.sql` | Inserts **360 records** (every main table has 20+ rows) |
| 3 | `03_queries.sql` | **16 SQL queries** — SELECT, WHERE, ORDER BY, GROUP BY, HAVING, aggregates, INNER JOIN, LEFT JOIN, 5 kinds of subqueries |
| 4 | `04_views.sql` | **3 views** (`V_STUDENT_REPORT`, `V_COURSE_ANALYTICS`, `V_UPCOMING_EXAMS`) + `SELECT` on each |
| 5 | `05_triggers.sql` | **3 triggers** + test cases that prove they fire (auto grade, auto marks, invalid-marks error) |
| 6 | `PROJECT_REPORT.md` | The full project documentation (problem statement → ER → tables → queries → outputs → conclusion → viva Q&A) |
| 7 | `outputs/` | Captured output of every query and view (used as “expected output” in the report) |

> **Run order:** `01_schema.sql` → `02_data.sql` → `04_views.sql` → `05_triggers.sql` → `03_queries.sql`
> (Triggers must be created **after** the data, otherwise `trg_add_answer_marks` would count the marks twice.)

## How to run (MySQL Workbench / phpMyAdmin)

1. Open MySQL Workbench → connect to `localhost`.
2. Run the files one by one **in the order above** (File → Open Script, then the lightning bolt ▶).
3. Take screenshots of: `SHOW TABLES`, each `CREATE TABLE` result, the record-count
   `SELECT`, query outputs, view outputs and the trigger test cases →
   these become section **8. Output Screenshots** of the report.

## Record counts

| Table | Rows | Table | Rows |
|---|---|---|---|
| STUDENT | 23 | QUESTION | 24 |
| INSTRUCTOR | 6 | QUESTION_OPTION | 96 |
| COURSE | 10 | EXAM_ATTEMPT | 24 |
| ENROLLMENT | 37 | ANSWER | 96 |
| EXAM | 20 | RESULT | 24 |

## Helper scripts (optional, not part of submission)

- `_validate.py` — reloads schema + data into an in-memory DB and checks all keys,
  constraints and data consistency (marks = sum of answers, grade rule, FK integrity).
- `_capture_outputs.py` — regenerates everything inside `outputs/`.

```bash
python3 _validate.py
python3 _capture_outputs.py
```
