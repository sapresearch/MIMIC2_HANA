-- Tells the system to use the schema _SYS_AFL. This is more or less similar to a namespace. Everything following this will apply to this schema
set schema _SYS_AFL;


-- Here lies the data table for the attributes that ANOMALYDETECTION will use. Can put as many parameters as required
drop type CE_AD_DATA;
create type CE_AD_DATA as table (SUBJECT_ID INTEGER, VALUE1NUM DOUBLE, VALUE2NUM DOUBLE);

-- Regular table used by every PAL function. This is filled later on
drop type CE_AD_PARAMS;
create type CE_AD_PARAMS as table (NAME VARCHAR (50), INTARGS INTEGER, DOUBLEARGS DOUBLE, STRINGARGS VARCHAR (100));

-- Output table for the results
drop type CE_AD_RESULTS;
create type CE_AD_RESULTS as table (SUBJECT_ID INTEGER, VALUE1NUM DOUBLE, VALUE2NUM DOUBLE);

-- Signature table that the PAL function will use
drop table CE_AD_SIGNATURE;
create column table CE_AD_SIGNATURE (ID INTEGER, TYPENAME VARCHAR(100), DIRECTION VARCHAR(100));
insert into CE_AD_SIGNATURE values (1, 'CE_AD_DATA', 'in');
insert into CE_AD_SIGNATURE values (2, 'CE_AD_PARAMS', 'in');
insert into CE_AD_SIGNATURE values (3, 'CE_AD_RESULTS', 'out');

-- Create the procedure
drop procedure _SYS_AFL.CE_AD;
drop type _SYS_AFL.CE_AD__TT_P1;
drop type _SYS_AFL.CE_AD__TT_P2;
drop type _SYS_AFL.CE_AD__TT_P3;
call SYSTEM.AFL_WRAPPER_GENERATOR('CE_AD','AFLPAL','ANOMALYDETECTION', CE_AD_SIGNATURE);

-- Use the schema MIMIC2 for the following instructions
set schema MIMIC2;

-- Create a view to select specific fields from a table. 
-- This allows a fine-grained control over what will be used in the algorithm instead of the complete tables
-- and also create relevant features that are not normally in the database
drop view V_AD_DATA;
create view V_AD_DATA as
	select "subject_id" as SUBJECT_ID, "value1num" as VALUE1NUM, "value2num" as VALUE2NUM
	from "MIMIC2"."mimic.tables::chartevents"
	where "value1num" is not null and "value2num" is not null;
	
-- Create a table for the function parameters
drop table #AD_PARAMS;
drop table AD_RESULTS;
create local temporary column table #AD_PARAMS like _SYS_AFL.CE_AD_PARAMS;
create column table AD_RESULTS like _SYS_AFL.CE_AD_RESULTS;

-- Populate this parameters table
insert into #AD_PARAMS values('GROUP_NUMBER',15,null,null);
insert into #AD_PARAMS values('DISTANCE_LEVEL',2,null,null);
insert into #AD_PARAMS values('OUTLIER_PERCENTAGE',null,0.05,null);
insert into #AD_PARAMS values('OUTLIER_DEFINE',1,null,null);
insert into #AD_PARAMS values('MAX_ITERATION',20,null,null);
insert into #AD_PARAMS values('INIT_TYPE',3,null,null);
insert into #AD_PARAMS values('NORMALIZATION',1,null,null);
insert into #AD_PARAMS values('THREAD_NUMBER',2,null,null);
insert into #AD_PARAMS values('EXIT_THRESHOLD',null,10.0,null);


-- Allows us to try different value for the parameters
update #AD_PARAMS set INTARGS=15 where name='GROUP_NUMBER';
update #AD_PARAMS set INTARGS=2 where name='DISTANCE_LEVEL';
update #AD_PARAMS set INTARGS=0 where name='NORMALIZATION';
update #AD_PARAMS set DOUBLEARGS=0.0001 where name='EXIT_THRESHOLD';


-- Empty the 'out' tables before running the KMeans function
truncate table AD_RESULTS;

call _SYS_AFL.CE_AD(V_AD_DATA, #AD_PARAMS, AD_RESULTS) with OVERVIEW;

