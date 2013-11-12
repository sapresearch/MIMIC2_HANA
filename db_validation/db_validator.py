import pypyodbc as pdbc
from abc import ABCMeta, abstractmethod

class DB_wrapper():
    __metaclass__ = ABCMeta

    def __init__(self, cursor, db_name, schema_name):
        self.cursor = cursor
        self.schema = schema_name
        self.db_name = db_name
        self.table_names = self.tables()
        self.num_tables = len(self.table_names)

    def rows(self, table):
        order_key = self.pk(table)
        if not order_key:
            order_key = self.columns[0]
        return self.cursor.execute(""" select * from %s order by %s """ %(self.table_call(table), self.format_column(order_key))).fetchall()
    @abstractmethod
    def table_call(self, table):
        pass
    @abstractmethod
    def table_name(self, table):
        pass
    def columns(self, table):
        #needs schema of MIMIC2
        return sorted(list(set([col[3] for col in self.cursor.columns(table=self.table_name(table), schema=self.schema).fetchall()])))
    def tables(self):
        #needs schema of MIMIC2
        return [table[2].replace(self.table_prefix, '') for table in set(self.cursor.tables(schema=self.schema).fetchall())]
    @abstractmethod
    def pk(self, table):
        pass
    def row_count(self, table):
        pk = self.pk(table)
        if not pk:
            pk = self.columns(table)[0]
        return self.cursor.execute(""" select count(distinct %s) from %s """ %(self.format_column(pk), self.table_call(table))).fetchone()
    @abstractmethod
    def format_column(self, table):
        pass
    def pk(self, table):
        order_key = self.cursor.primaryKeys(self.table_name(table), schema=self.schema).fetchone()
        if not order_key:
            return None
        else:
            return order_key[3]


class HANA_wrapper(DB_wrapper):
    def __init__(self, cursor, db_name, schema_name):
        self.table_prefix = db_name + '.tables::'
        super(HANA_wrapper, self).__init__(cursor, db_name, schema_name)

    def table_call(self, table):
        return '"' + self.schema + '".'+'"'+self.table_prefix+table+'"'
    def table_name(self, table):
        return self.table_prefix+table
    def format_column(self, col):
        return '"'+col+'"'

class PSQL_wrapper(DB_wrapper):
    def __init__(self, cursor, db_name, schema_name):
        self.table_prefix = schema_name+"."
        super(PSQL_wrapper, self).__init__(cursor, db_name, schema_name)

    def table_call(self, table):
        return self.table_prefix + table
    def table_name(self, table):
        return table
    def format_column(self, col):
        return col

class DB_validator():

    def __init__(self, modeldb, testdb, failhard=False):
        self.modeldb = modeldb
        self.testdb = testdb
        self.failhard=failhard

        #self.table_count()
        #self.list_no_pks()
        #self.compareTables()

    def table_count(self):
        modcount = self.modeldb.num_tables
        testcount = self.testdb.num_tables
        failstr = "TABLE COUNT ERROR: \n modeldb: " + str(modcount) + "\n testdb: " + str(testcount) + "\n\n"
        if not modcount == testcount:

            missing_mod = filter(lambda x: x not in self.modeldb.table_names, self.testdb.table_names)
            missing_test = filter(lambda x: x not in self.testdb.table_names, self.modeldb.table_names)
            missingstr = "MISSING MODEL TABLES: " + str(missing_mod) + "\n + " + "MISSING TEST TABLES: " + str(missing_test) + "\n\n"

            self.log(failstr + missingstr)

    def list_no_pks(self):

        model_nopks = []
        for table in self.modeldb.table_names:
            if not self.modeldb.pk(table):
                model_nopks.append(table)

        test_nopks = []
        for table in self.testdb.table_names:
            if not self.testdb.pk(table):
                test_nopks.append(table)

        failstr = "model tables with no pks: " +str(model_nopks) + "\n test tables with no pks: " + str(test_nopks) + "\n\n"
        self.log(failstr)


    def compareTables(self):
        #self.table_count()

        for table in self.modeldb.table_names:
            self.table_row_count(table)

    def log(self, failstr):
        if self.failhard:
            raise Exception, failstr
        else:
            print failstr

    def table_row_count(self, table_name):
        print "table: " + str(table_name)

        ntestrows = self.testdb.row_count(table_name)
        nmodrows = self.modeldb.row_count(table_name)

        failstr = "TABLE: " + str(table_name) + "\n" + "modelrowcount: " + str(nmodrows) + "\n testrowcount: " + str(ntestrows) + "\n\n"
        self.log(failstr)

    #compare row count, row contents, col count, col contents for a table
    def table_diff(self, table_name):
        print "table: " + str(table_name) 

        #check columns
        modcols = self.modeldb.columns(table_name)
        testcols = self.testdb.columns(table_name)

        nmodcols = len(modcols)
        ntestcols = len(testcols)

        if nmodcols == 0 or ntestcols == 0 or nmodcols != ntestcols:
            failstr = "TABLE: " + str(table_name) + "\n" + "modelcols: " + str(nmodcols) + "\n testcols: " + str(ntestcols) + "\n\n"
            self.log(failstr)

        for col1, col2 in zip(modcols, testcols):
            if not str(str(col1)).lower() == (str(col2)).lower():
                failstr = "COL DIFF: " + "\n MODEL COL: + " + str(col1) + " \n TEST COL: "+  str(col2) + "\n\n"
                self.log(failstr)

        #check rows
        modrows = self.modeldb.rows(table_name)
        testrows = self.testdb.rows(table_name)

        nmodrows = len(modrows)
        ntestrows = len(testrows)

        #if nmodrows == 0 or ntestrows == 0 or nmodrows != ntestrows:
        failstr = "TABLE: " + str(table_name) + "\n" + "modelrowcount: " + str(nmodrows) + "\n testrowcount: " + str(ntestrows) + "\n\n"
        self.log(failstr)


        #don't want to find individual missing rows as it would take a godawful long amount of time
           #table_pk = self.modeldb.pk(table) 

        #for row, rowindex in enumerate(modrows):
        #    for col, colindex in enumerate(row):
        #        assert col == testrows[row][col]

def main():

    DB_wrapper.register(HANA_wrapper)
    DB_wrapper.register(PSQL_wrapper)
    hana_db = HANA_wrapper(cursor=pdbc.connect('DSN=hana_new;UID=SYSTEM;PWD=HANA4ever;DATABASE=MIMIC2').cursor(), db_name="mimic", schema_name='MIMIC2')
    psql_db = PSQL_wrapper(cursor=pdbc.connect('DSN=psql_mimic').cursor(), db_name="MIMIC2", schema_name='mimic2v26')
    test = DB_validator(modeldb=psql_db, testdb=hana_db, failhard=False)
    test.table_count()

if __name__=="__main__":
        main()
