drop function months_between;
create function months_between(start_date timestamp, end_date timestamp) RETURNS mb integer
language SQLSCRIPT READS SQL DATA AS
begin
   	mb := (year(:end_date) - year(:start_date))*12 + (month(:end_date) - month(:start_date));
end;


-- Tells the system to use the schema _SYS_AFL. This is more or less similar to a namespace. Everything following this will apply to this schema
set schema _SYS_AFL;


-- Here lies the data table for the attributes that ANOMALYDETECTION will use. Can put as many parameters as required
drop type AGE_BIN_DATA;
create type AGE_BIN_DATA as table (SUBJECT_ID INTEGER, MB DOUBLE);

-- Regular table used by every PAL function. This is filled later on
drop type AGE_BIN_PARAMS;
create type AGE_BIN_PARAMS as table (NAME VARCHAR (50), INTARGS INTEGER, DOUBLEARGS DOUBLE, STRINGARGS VARCHAR (100));

-- Output table for the results
drop type AGE_BIN_RESULTS;
create type AGE_BIN_RESULTS as table (SUBJECT_ID INTEGER, VAR_TYPE INTEGER, VAR_PRE_RESULT DOUBLE);

-- Signature table that the PAL function will use
drop table AGE_BIN_SIGNATURE;
create column table AGE_BIN_SIGNATURE (ID INTEGER, TYPENAME VARCHAR(100), DIRECTION VARCHAR(100));
insert into AGE_BIN_SIGNATURE values (1, 'AGE_BIN_DATA', 'in');
insert into AGE_BIN_SIGNATURE values (2, 'AGE_BIN_PARAMS', 'in');
insert into AGE_BIN_SIGNATURE values (3, 'AGE_BIN_RESULTS', 'out');

-- Create the procedure
drop procedure _SYS_AFL.AGE_BIN;
drop type _SYS_AFL.AGE_BIN__TT_P1;
drop type _SYS_AFL.AGE_BIN__TT_P2;
drop type _SYS_AFL.AGE_BIN__TT_P3;
call SYSTEM.AFL_WRAPPER_GENERATOR('AGE_BIN','AFLPAL','BINNING', AGE_BIN_SIGNATURE);

-- Use the schema MIMIC2 for the following instructions
set schema MIMIC2;

-- Create a view to select specific fields from a table. 
-- This allows a fine-grained control over what will be used in the algorithm instead of the complete tables
-- and also create relevant features that are not normally in the database
drop view V_BIN_DATA;
create view V_BIN_DATA as
	select "ad"."subject_id" as SUBJECT_ID, months_between("dp"."dob", "ad"."admit_dt")/12 as MB
	from "MIMIC2"."mimic.tables::admissions" "ad", "MIMIC2"."mimic.tables::d_patients" "dp"
	where "ad"."subject_id" = "dp"."subject_id" and months_between("dp"."dob", "ad"."admit_dt") / 12 between 15 and 199;
	
-- Create a table for the function parameters
drop table #BIN_PARAMS;
drop table BIN_RESULTS;
create local temporary column table #BIN_PARAMS like _SYS_AFL.AGE_BIN_PARAMS;
create column table BIN_RESULTS like _SYS_AFL.AGE_BIN_RESULTS;

-- Populate this parameters table
insert into #BIN_PARAMS values('BINNING_METHOD',0,null,null);
insert into #BIN_PARAMS values('SMOOTH_METHOD',2,null,null);
insert into #BIN_PARAMS values('BIN_NUMBER',85,null,null);
--insert into #BIN_PARAMS values('BIN_DISTANCE',10,null,null);
--insert into #BIN_PARAMS values('SD',1,null,null);


-- Allows us to try different value for the parameters
--update #BIN_PARAMS set INTARGS=15 where name='BINNING_METHOD';


-- Empty the 'out' tables before running the KMeans function
truncate table BIN_RESULTS;

call _SYS_AFL.AGE_BIN(V_BIN_DATA, #BIN_PARAMS, BIN_RESULTS) with OVERVIEW;

-- To get the histogram, either run the following query or look at the data visualization tool available (right click on a table > Open Data Preview > Select the Analysis tab)
select BIN_RESULTS.VAR_TYPE, count(*) from BIN_RESULTS group by BIN_RESULTS.VAR_TYPE order by BIN_RESULTS.VAR_TYPE;

