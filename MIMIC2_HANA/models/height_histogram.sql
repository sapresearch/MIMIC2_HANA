drop function months_between;
create function months_between(start_date timestamp, end_date timestamp) RETURNS mb integer
language SQLSCRIPT READS SQL DATA AS
begin
   	mb := (year(:end_date) - year(:start_date))*12 + (month(:end_date) - month(:start_date));
end;


-- Tells the system to use the schema _SYS_AFL. This is more or less similar to a namespace. Everything following this will apply to this schema
set schema _SYS_AFL;


-- Here lies the data table for the attributes that ANOMALYDETECTION will use. Can put as many parameters as required
drop type HEIGHT_BIN_DATA;
create type HEIGHT_BIN_DATA as table (SUBJECT_ID INTEGER, H DOUBLE);

-- Regular table used by every PAL function. This is filled later on
drop type HEIGHT_BIN_PARAMS;
create type HEIGHT_BIN_PARAMS as table (NAME VARCHAR (50), INTARGS INTEGER, DOUBLEARGS DOUBLE, STRINGARGS VARCHAR (100));

-- Output table for the results
drop type HEIGHT_BIN_RESULTS;
create type HEIGHT_BIN_RESULTS as table (SUBJECT_ID INTEGER, VAR_TYPE INTEGER, VAR_PRE_RESULT DOUBLE);

-- Signature table that the PAL function will use
drop table HEIGHT_BIN_SIGNATURE;
create column table HEIGHT_BIN_SIGNATURE (ID INTEGER, TYPENAME VARCHAR(100), DIRECTION VARCHAR(100));
insert into HEIGHT_BIN_SIGNATURE values (1, 'HEIGHT_BIN_DATA', 'in');
insert into HEIGHT_BIN_SIGNATURE values (2, 'HEIGHT_BIN_PARAMS', 'in');
insert into HEIGHT_BIN_SIGNATURE values (3, 'HEIGHT_BIN_RESULTS', 'out');

-- Create the procedure
drop procedure _SYS_AFL.HEIGHT_BIN;
drop type _SYS_AFL.HEIGHT_BIN__TT_P1;
drop type _SYS_AFL.HEIGHT_BIN__TT_P2;
drop type _SYS_AFL.HEIGHT_BIN__TT_P3;
call SYSTEM.AFL_WRAPPER_GENERATOR('HEIGHT_BIN','AFLPAL','BINNING', HEIGHT_BIN_SIGNATURE);

-- Use the schema MIMIC2 for the following instructions
set schema MIMIC2;

-- Create a view to select specific fields from a table. 
-- This allows a fine-grained control over what will be used in the algorithm instead of the complete tables
-- and also create relevant features that are not normally in the database
drop view V_HEIGHT_DATA;
create view V_HEIGHT_DATA as
   	select "subject_id" as SUBJECT_ID, "value1num" as H
   	from "MIMIC2"."mimic.tables::chartevents"
   	where "itemid" = 920 and "value1num" is not null and "value1num" between 1 and 499;
	
-- Create a table for the function parameters
drop table #HEIGHT_PARAMS;
drop table HEIGHT_RESULTS;
create local temporary column table #HEIGHT_PARAMS like _SYS_AFL.HEIGHT_BIN_PARAMS;
create column table HEIGHT_RESULTS like _SYS_AFL.HEIGHT_BIN_RESULTS;

-- Populate this parameters table
insert into #HEIGHT_PARAMS values('BINNING_METHOD',0,null,null);
insert into #HEIGHT_PARAMS values('SMOOTH_METHOD',2,null,null);
insert into #HEIGHT_PARAMS values('BIN_NUMBER',200,null,null);
--insert into #HEIGHT_PARAMS values('BUN_DISTANCE',10,null,null);
--insert into #HEIGHT_PARAMS values('SD',1,null,null);


-- Allows us to try different value for the parameters
--update #HEIGHT_PARAMS set INTARGS=15 where name='BINNING_METHOD';


-- Empty the 'out' tables before running the KMeans function
truncate table HEIGHT_RESULTS;

call _SYS_AFL.HEIGHT_BIN(V_HEIGHT_DATA, #HEIGHT_PARAMS, HEIGHT_RESULTS) with OVERVIEW;

-- To get the histogram, either run the following query or look at the data visualization tool available (right click on a table > Open Data Preview > Select the Analysis tab)
select HEIGHT_RESULTS.VAR_TYPE, count(*) from HEIGHT_RESULTS group by HEIGHT_RESULTS.VAR_TYPE order by HEIGHT_RESULTS.VAR_TYPE;

