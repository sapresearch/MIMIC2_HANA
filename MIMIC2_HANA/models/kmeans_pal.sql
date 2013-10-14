-- Tells PAL to use the schema _SYS_AFL. This is more or less similar to a namespace. Everything following this will apply to this schema
set schema _SYS_AFL;

drop type CE_KM_DATA;
drop type CE_KM_PARAMS;
drop type CE_KM_RESULTS;
drop type CE_KM_CENTER_POINTS;

-- Here lies the data table for the attributes that KMEANS will use. Can put as many parameters as required
create type CE_KM_DATA as table (SUBJECT_ID INTEGER, VALUE1NUM DOUBLE, VALUE2NUM DOUBLE);
create type CE_KM_PARAMS as table (NAME VARCHAR (50), INTARGS INTEGER, DOUBLEARGS DOUBLE, STRINGARGS VARCHAR (100));
create type CE_KM_RESULTS as table (CE_ID INTEGER, CLUSTER_ID INTEGER, DISTANCE DOUBLE);
create type CE_KM_CENTER_POINTS as table (CE_ID INTEGER, VALUE1NUM DOUBLE, VALUE2NUM DOUBLE);

drop table CE_KM_SIGNATURE;
create column table CE_KM_SIGNATURE (ID INTEGER, TYPENAME VARCHAR(100), DIRECTION VARCHAR(100));
insert into CE_KM_SIGNATURE values (1, 'CE_KM_DATA', 'in');
insert into CE_KM_SIGNATURE values (2, 'CE_KM_PARAMS', 'in');
insert into CE_KM_SIGNATURE values (3, 'CE_KM_RESULTS', 'out');
insert into CE_KM_SIGNATURE values (4, 'CE_KM_CENTER_POINTS', 'out');

drop procedure _SYS_AFL.CE_KM;
drop type _SYS_AFL.CE_KM__TT_P1;
drop type _SYS_AFL.CE_KM__TT_P2;
drop type _SYS_AFL.CE_KM__TT_P3;
drop type _SYS_AFL.CE_KM__TT_P4;
call SYSTEM.AFL_WRAPPER_GENERATOR('CE_KM','AFLPAL','KMEANS', CE_KM_SIGNATURE);

-- Use the schema MIMIC2 for the following instructions
set schema MIMIC2;

-- Create a view to select specific fields from a table. 
-- This allows a fine-grained control over what will be used in the algorithm instead of the complete tables
-- and also create relevant features that are not normally in the database
drop view V_KM_DATA;
create view V_KM_DATA as
	select "subject_id" as SUBJECT_ID, "value1num" as VALUE1NUM, "value2num" as VALUE2NUM
	from "MIMIC2"."mimic.tables::chartevents"
	where "value1num" is not null and "value2num" is not null;
	
-- Create a table for the function parameters
drop table #KM_PARAMS;
drop table KM_RESULTS;
drop table KM_CENTER_POINTS;
create local temporary column table #KM_PARAMS like _SYS_AFL.CE_KM_PARAMS;
create column table KM_RESULTS like _SYS_AFL.CE_KM_RESULTS;
create column table KM_CENTER_POINTS like _SYS_AFL.CE_KM_CENTER_POINTS;

-- Populate this parameters table
insert into #KM_PARAMS values('GROUP_NUMBER',15,null,null);
insert into #KM_PARAMS values('DISTANCE_LEVEL',2,null,null);
insert into #KM_PARAMS values('MAX_ITERATION',20,null,null);
insert into #KM_PARAMS values('INIT_TYPE',3,null,null);
insert into #KM_PARAMS values('NORMALIZATION',1,null,null);
insert into #KM_PARAMS values('THREAD_NUMBER',2,null,null);
insert into #KM_PARAMS values('EXIT_THRESHOLD',null,10.0,null);


-- Allows us to try different value for the parameters
update #KM_PARAMS set INTARGS=15 where name='GROUP_NUMBER';
update #KM_PARAMS set INTARGS=2 where name='DISTANCE_LEVEL';
update #KM_PARAMS set INTARGS=0 where name='NORMALIZATION';
update #KM_PARAMS set DOUBLEARGS=0.0001 where name='EXIT_THRESHOLD';


-- Empty the 'out' tables before running the KMeans function
truncate table KM_RESULTS;
truncate table KM_CENTER_POINTS;

call _SYS_AFL.CE_KM(V_KM_DATA, KM_PARAMS, KM_RESULTS, KM_CENTER_POINTS) with OVERVIEW;

