import sqlite3, re, sys, os

base = os.path.dirname(os.path.abspath(__file__))
schema_sql = open(os.path.join(base, '01_schema.sql')).read()
data_sql = open(os.path.join(base, '02_data.sql')).read()

# strip MySQL-only statements
def strip(lines):
    out = []
    for l in lines:
        s = l.strip()
        if s.startswith('CREATE DATABASE') or s.startswith('USE ') or s.startswith('SHOW TABLES'):
            continue
        out.append(l)
    return '\n'.join(out)

schema_sql = strip(schema_sql.splitlines())
data_sql = strip(data_sql.splitlines())

con = sqlite3.connect(':memory:')
con.execute('PRAGMA foreign_keys = ON')
con.executescript(schema_sql)
con.executescript(data_sql)

errors = []

# 1. FK check
fk = con.execute('PRAGMA foreign_key_check').fetchall()
if fk:
    errors.append(f'FK violations: {fk}')

# 2. counts
expected = {'STUDENT':23,'INSTRUCTOR':6,'COURSE':10,'ENROLLMENT':37,'EXAM':20,
            'QUESTION':24,'QUESTION_OPTION':96,'EXAM_ATTEMPT':24,'ANSWER':96,'RESULT':24}
print('== RECORD COUNTS ==')
for t, n in expected.items():
    c = con.execute(f'SELECT COUNT(*) FROM {t}').fetchone()[0]
    flag = 'OK' if c == n else 'MISMATCH'
    print(f'{t:20s} {c:4d}  (expected {n}) {flag}')
    if c != n:
        errors.append(f'{t}: {c} != {n}')

# 3. attempt marks == sum of answers
rows = con.execute('''SELECT a.Attempt_ID, a.Marks_Obtained, COALESCE(SUM(an.Marks_Scored),0)
                      FROM EXAM_ATTEMPT a LEFT JOIN ANSWER an ON a.Attempt_ID=an.Attempt_ID
                      GROUP BY a.Attempt_ID''').fetchall()
for aid, mo, s in rows:
    if float(mo) != float(s):
        errors.append(f'attempt {aid}: Marks_Obtained {mo} != sum(answers) {s}')

# 4. answer flag matches option key
bad = con.execute('''SELECT an.Attempt_ID, an.Exam_ID, an.Question_No, an.Selected_Label, an.Is_Correct, an.Marks_Scored,
                            o.Is_Correct, q.Marks
                     FROM ANSWER an
                     JOIN QUESTION q ON q.Exam_ID=an.Exam_ID AND q.Question_No=an.Question_No
                     LEFT JOIN QUESTION_OPTION o ON o.Exam_ID=an.Exam_ID AND o.Question_No=an.Question_No
                                                   AND o.Option_Label=an.Selected_Label''').fetchall()
for aid, eid, qn, sel, iscorr, ms, ocorr, qm in bad:
    want = 'YES' if ocorr == 'YES' else 'NO'
    if iscorr != want:
        errors.append(f'answer {aid}/{eid}/{qn}: Is_Correct {iscorr} but option key says {want}')
    want_marks = float(qm) if ocorr == 'YES' else 0.0
    if float(ms) != want_marks:
        errors.append(f'answer {aid}/{eid}/{qn}: Marks_Scored {ms} != {want_marks}')

# 5. exactly one correct option per question
rows = con.execute('''SELECT Exam_ID, Question_No, COUNT(*) FROM QUESTION_OPTION
                      WHERE Is_Correct='YES' GROUP BY Exam_ID, Question_No
                      HAVING COUNT(*) <> 1''').fetchall()
for r in rows:
    errors.append(f'question {r} does not have exactly 1 correct option')
qcount = con.execute('SELECT COUNT(DISTINCT Exam_ID||"-"||Question_No) FROM QUESTION_OPTION').fetchone()[0]
if qcount != 24:
    errors.append(f'questions with options: {qcount} != 24')

# 6. result consistency with attempt
rows = con.execute('''SELECT r.Result_ID, r.Percentage, r.Grade, r.Status, a.Marks_Obtained
                      FROM RESULT r JOIN EXAM_ATTEMPT a ON a.Attempt_ID=r.Attempt_ID''').fetchall()
for rid, pct, grade, status, mo in rows:
    if float(pct) != float(mo):
        errors.append(f'result {rid}: percentage {pct} != marks {mo}')
    p = float(pct)
    g = 'A' if p >= 80 else 'B' if p >= 70 else 'C' if p >= 60 else 'D' if p >= 50 else 'F'
    st = 'PASS' if p >= 50 else 'FAIL'
    if grade != g:
        errors.append(f'result {rid}: grade {grade} != {g}')
    if status != st:
        errors.append(f'result {rid}: status {status} != {st}')

# 7. marks never exceed exam total
rows = con.execute('''SELECT a.Attempt_ID, a.Marks_Obtained, e.Total_Marks
                      FROM EXAM_ATTEMPT a JOIN EXAM e ON e.Exam_ID=a.Exam_ID
                      WHERE a.Marks_Obtained > e.Total_Marks''').fetchall()
for r in rows:
    errors.append(f'attempt {r[0]} marks {r[1]} > exam total {r[2]}')

# 8. every attempt has a result, student enrolled in exam course
rows = con.execute('''SELECT a.Attempt_ID FROM EXAM_ATTEMPT a
                      LEFT JOIN RESULT r ON r.Attempt_ID=a.Attempt_ID
                      WHERE r.Result_ID IS NULL''').fetchall()
for r in rows:
    errors.append(f'attempt {r[0]} has no RESULT')

rows = con.execute('''SELECT a.Attempt_ID FROM EXAM_ATTEMPT a
                      JOIN EXAM e ON e.Exam_ID=a.Exam_ID
                      LEFT JOIN ENROLLMENT en ON en.Student_ID=a.Student_ID AND en.Course_ID=e.Course_ID
                      WHERE en.Student_ID IS NULL''').fetchall()
for r in rows:
    errors.append(f'attempt {r[0]}: student not enrolled in exam course')

# 9. question sum == exam total for completed exams
rows = con.execute('''SELECT e.Exam_ID, e.Total_Marks, COALESCE(SUM(q.Marks),0)
                      FROM EXAM e LEFT JOIN QUESTION q ON q.Exam_ID=e.Exam_ID
                      GROUP BY e.Exam_ID HAVING SUM(q.Marks) > 0 AND SUM(q.Marks) <> e.Total_Marks''').fetchall()
for r in rows:
    errors.append(f'exam {r[0]}: question marks {r[2]} != total {r[1]}')

print()
if errors:
    print('ERRORS:')
    for e in errors:
        print('  -', e)
    sys.exit(1)
print('ALL VALIDATION CHECKS PASSED ✔')
