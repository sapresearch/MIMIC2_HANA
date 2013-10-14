import pypyodbc as pdbc

conn = pdbc.connect('DSN=hana_new;UID=SYSTEM;PWD=HANA4ever')
cursor = conn.cursor()

import_slices = open('/home/I834397/public/new_server_backup/mimic/import slices.txt')
import_statements = import_slices.readlines()

for stmt in import_statements:
    cursor.execute(stmt)
