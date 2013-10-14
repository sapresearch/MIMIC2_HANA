drop function months_between;
create function months_between(start_date timestamp, end_date timestamp) RETURNS mb integer
language SQLSCRIPT READS SQL DATA AS
begin
   	mb := (year(:end_date) - year(:start_date))*12 + (month(:end_date) - month(:start_date));
end;


-- Tells the system to use the schema _SYS_AFL. This is more or less similar to a namespace. Everything following this will apply to this schema
set schema _SYS_AFL;


-- Here lies the data table for the attributes that ANOMALYDETECTION will use. Can put as many parameters as required
drop type BUN_BIN_DATA;
create type BUN_BIN_DATA as table (SUBJECT_ID INTEGER, BUN DOUBLE);

-- Regular table used by every PAL function. This is filled later on
drop type BUN_BIN_PARAMS;
create type BUN_BIN_PARAMS as table (NAME VARCHAR (50), INTARGS INTEGER, DOUBLEARGS DOUBLE, STRINGARGS VARCHAR (100));

-- Output table for the results
drop type BUN_BIN_RESULTS;
create type BUN_BIN_RESULTS as table (SUBJECT_ID INTEGER, VAR_TYPE INTEGER, VAR_PRE_RESULT DOUBLE);

-- Signature table that the PAL function will use
drop table BUN_BIN_SIGNATURE;
create column table BUN_BIN_SIGNATURE (ID INTEGER, TYPENAME VARCHAR(100), DIRECTION VARCHAR(100));
insert into BUN_BIN_SIGNATURE values (1, 'BUN_BIN_DATA', 'in');
insert into BUN_BIN_SIGNATURE values (2, 'BUN_BIN_PARAMS', 'in');
insert into BUN_BIN_SIGNATURE values (3, 'BUN_BIN_RESULTS', 'out');

-- Create the procedure
drop procedure _SYS_AFL.BUN_BIN;
drop type _SYS_AFL.BUN_BIN__TT_P1;
drop type _SYS_AFL.BUN_BIN__TT_P2;
drop type _SYS_AFL.BUN_BIN__TT_P3;
call SYSTEM.AFL_WRAPPER_GENERATOR('BUN_BIN','AFLPAL','BINNING', BUN_BIN_SIGNATURE);

-- Use the schema MIMIC2 for the following instructions
set schema MIMIC2;

-- Create a view to select specific fields from a table. 
-- This allows a fine-grained control over what will be used in the algorithm instead of the complete tables
-- and also create relevant features that are not normally in the database
drop view V_BUN_DATA;
create view V_BUN_DATA as
	select "le"."subject_id" as SUBJECT_ID, "le"."valuenum" as BUN
   	from "MIMIC2"."mimic.tables::labevents" "le", "MIMIC2"."mimic.tables::d_patients" "dp"
   	where "itemid" in (50177) and "le"."subject_id" = "dp"."subject_id" and months_between("dp"."dob", "le"."charttime")/12 > 15 and "le"."valuenum" is not null;
	
-- Create a table for the function parameters
drop table #BUN_PARAMS;
drop table BUN_RESULTS;
create local temporary column table #BUN_PARAMS like _SYS_AFL.BUN_BIN_PARAMS;
create column table BUN_RESULTS like _SYS_AFL.BUN_BIN_RESULTS;

-- Populate this parameters table
insert into #BUN_PARAMS values('BINNING_METHOD',0,null,null);
insert into #BUN_PARAMS values('SMOOTH_METHOD',2,null,null);
insert into #BUN_PARAMS values('BIN_NUMBER',280,null,null);
--insert into #BUN_PARAMS values('BUN_DISTANCE',10,null,null);
--insert into #BUN_PARAMS values('SD',1,null,null);


-- Allows us to try different value for the parameters
--update #BIN_PARAMS set INTARGS=15 where name='BINNING_METHOD';


-- Empty the 'out' tables before running the KMeans function
truncate table BUN_RESULTS;

call _SYS_AFL.BUN_BIN(V_BUN_DATA, #BUN_PARAMS, BUN_RESULTS) with OVERVIEW;

-- To get the histogram, either run the following query or look at the data visualization tool available (right click on a table > Open Data Preview > Select the Analysis tab)
select BUN_RESULTS.VAR_TYPE, count(*) from BUN_RESULTS group by BUN_RESULTS.VAR_TYPE order by BUN_RESULTS.VAR_TYPE;

