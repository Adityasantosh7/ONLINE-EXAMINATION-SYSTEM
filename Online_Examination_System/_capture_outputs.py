import sqlite3, os, re, sys

base = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(base, 'outputs')
os.makedirs(OUT, exist_ok=True)

def strip_mysql(lines, drop_view=False, drop_trigger=False):
    out, skip = [], False
    for l in lines:
        s = l.strip()
        if s.startswith('CREATE DATABASE') or s.startswith('USE ') or s.startswith('SHOW TABLES'):
            continue
        out.append(l)
    return '\n'.join(out)

def statements(path, label_re=r'-- (Q\d+|VIEW \d+)[^\n]*'):
    """split a .sql file into statements, remembering the label above each"""
    txt = open(path).read()
    stmts, cur, label = [], [], None
    pending_label = None
    for line in txt.splitlines():
        m = re.match(r'\s*--\s*(Q\d+|VIEW \d+)\.\s*(.*)', line)
        if m:
            pending_label = f'{m.group(1)}. {m.group(2).strip()}'
        if line.strip().startswith('--'):
            continue
        cur.append(line)
        if ';' in line:
            code = '\n'.join(cur).strip()
            if code:
                stmts.append((label or pending_label, code))
            cur, pending_label = [], None
    # last label should stick only for first statement after it
    return stmts

def run(path, con, outfile, keep_labels=True):
    txt = open(path).read()
    label = None
    buf = []
    results = []
    for line in txt.splitlines():
        s = line.strip()
        m = re.match(r'--\s*(Q\d+|VIEW \d+)\.\s*(.*)', s)
        if m:
            label = f'{m.group(1)}. {m.group(2).strip()}'
        if s.startswith('--') or s == '':
            continue
        buf.append(line)
        if ';' in line:
            code = '\n'.join(buf).strip()
            buf = []
            cur_label = label
            label = None
            if code.upper().startswith(('SELECT', 'WITH')):
                results.append((cur_label, code))
    return results

con = sqlite3.connect(':memory:')
con.execute('PRAGMA foreign_keys = ON')
con.executescript(strip_mysql(open(os.path.join(base,'01_schema.sql')).read().splitlines()))
con.executescript(strip_mysql(open(os.path.join(base,'02_data.sql')).read().splitlines()))

def table(headers, rows):
    rows = [[('NULL' if v is None else v) for v in r] for r in rows]
    widths = [len(str(h)) for h in headers]
    for r in rows:
        for i, v in enumerate(r):
            widths[i] = max(widths[i], len(str(v)))
    sep = '-+-'.join('-'*w for w in widths)
    lines = [' | '.join(str(h).ljust(widths[i]) for i, h in enumerate(headers)), sep]
    for r in rows:
        lines.append(' | '.join(str(v).ljust(widths[i]) for i, v in enumerate(r)))
    lines.append(f'({len(rows)} row{"s" if len(rows)!=1 else ""})')
    return '\n'.join(lines)

# ---- queries ----
qs = run(os.path.join(base,'03_queries.sql'), con, None)
blocks = []
for label, code in qs:
    cur = con.execute(code)
    headers = [d[0] for d in cur.description]
    rows = cur.fetchall()
    blocks.append(f'{label}\n\nSQL:\n{code}\nOUTPUT:\n{table(headers, rows)}\n')
    print(f'=== {label} ===')
    print(table(headers, rows))
    print()
open(os.path.join(OUT,'query_outputs.txt'),'w').write('\n' + '='*78 + '\n'.join(blocks))

# ---- views ----
vpath = os.path.join(base,'04_views.sql')
vsql = open(vpath).read()
vsql = '\n'.join(l for l in vsql.splitlines() if not l.strip().startswith('USE '))
con.executescript(vsql)
vblocks = []
# run the three SELECT statements that use the views
sels = [c for l, c in run(vpath, con, None)]
for i, code in enumerate(sels):
    cur = con.execute(code)
    headers = [d[0] for d in cur.description]
    rows = cur.fetchall()
    print(f'=== VIEW QUERY {i+1} ===')
    print(table(headers, rows)); print()
    vblocks.append(f'VIEW QUERY {i+1}: {code}\nOUTPUT:\n{table(headers, rows)}\n')
open(os.path.join(OUT,'view_outputs.txt'),'w').write('\n'.join(vblocks))

# ---- simple meta outputs used in the report ----
meta = {}
meta['counts'] = table(['TABLE_NAME','RECORDS'],
    [(t, con.execute(f'SELECT COUNT(*) FROM {t}').fetchone()[0])
     for t in ['STUDENT','INSTRUCTOR','COURSE','ENROLLMENT','EXAM','QUESTION',
               'QUESTION_OPTION','EXAM_ATTEMPT','ANSWER','RESULT']])
print('=== COUNTS ==='); print(meta['counts'])
with open(os.path.join(OUT,'counts.txt'),'w') as f:
    f.write(meta['counts'] + '\n')
print('\nwrote outputs to', OUT)
