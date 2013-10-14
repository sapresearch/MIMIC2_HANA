
-- Create function for month difference. Can be refined.
drop function months_between;
create function months_between(start_date timestamp, end_date timestamp) RETURNS mb integer 
language SQLSCRIPT READS SQL DATA AS
begin
	mb := (year(:end_date) - year(:start_date))*12 + (month(:end_date) - month(:start_date));
end;

-- width_bucket includes ending value, exclude starting value
drop function width_bucket;
create function width_bucket(val Double, start_val Double, end_val Double, nb_buckets integer) RETURNS bucket integer 
language SQLSCRIPT READS SQL DATA AS
begin
	DECLARE b integer := floor((:val - :start_val) * (:nb_buckets / (:end_val - :start_val))) + 1;
	IF b > :nb_buckets THEN
		bucket:= nb_buckets + 1;
	ELSE
		bucket := b;
	END IF;
end;


--Age Histogram
select bucket + 15, count(*) from (
	select width_bucket(months_between("dp"."dob", "ad"."admit_dt")/12, 15, 100, 85) as bucket
	from "MIMIC2"."mimic.tables::admissions" "ad", "MIMIC2"."mimic.tables::d_patients" "dp"
	where "ad"."subject_id" = "dp"."subject_id" and months_between("dp"."dob", "ad"."admit_dt") / 12 between 15 and 199)
group by bucket order by bucket


--Postgresql--
/*
select bucket+15, count(*) from (
	select months_between(ad.admit_dt, dp.dob)/12, width_bucket(months_between(ad.admit_dt,dp.dob)/12, 15, 100, 85) as bucket 
	from mimic2v26.admissions ad, mimic2v26.d_patients dp 
	where ad.subject_id = dp.subject_id and months_between(ad.admit_dt, dp.dob)/12 between 15 and 199) x
group by bucket order by bucket;
*/

--Height Histogram
select bucket, count(*) from (
	select "value1num", floor("value1num" * 200/ (200 - 0)) as bucket
	from "MIMIC2"."mimic.tables::chartevents"
	where "itemid" = 920 and "value1num" is not null and "value1num" between 1 and 499) x
group by bucket order by bucket

--Postgresql--
/*
select bucket, count(*) from (
	select value1num, width_bucket(value1num, 1, 200, 200) as bucket 
	from mimic2v26.chartevents 
	where itemid = 920 and value1num is not null and value1num > 0 and value1num < 500) x 
group by bucket order by bucket;
*/


--Blood urea nitrogen (BUN) histogram
select bucket, count(*) from (
	select width_bucket("le"."valuenum", 0, 280, 280) as bucket
	from "MIMIC2"."mimic.tables::labevents" "le", "MIMIC2"."mimic.tables::d_patients" "dp"
	where "itemid" in (50177) and "le"."subject_id" = "dp"."subject_id" and months_between("dp"."dob", "le"."charttime")/12 > 15)
group by bucket order by bucket;

--Postgresql--
/*
select bucket, count(*) from (
	select width_bucket(valuenum, 0, 280, 280) as bucket
	from mimic2v26.labevents le, mimic2v26.d_patients dp
	where itemid in (50177) and le.subject_id = dp.subject_id and months_between(le.charttime, dp.dob)/12 > 15
) group by bucket order by bucket;
*/



--Get Gladow come scale (GSC) histogram
select bucket, count(*) from (
	select width_bucket("ce"."value1num", 1, 30, 20) as bucket
	from "MIMIC2"."mimic.tables::chartevents" "ce", "MIMIC2"."mimic.tables::d_patients" "dp"
	where "itemid" in (198) and "ce"."subject_id" = "dp"."subject_id" and months_between("dp"."dob", "ce"."charttime")/12 > 15)
group by bucket order by bucket;

--Postgresql--
/*
select bucket, count(*) from (
	select width_bucket(value1num, 1, 30, 30) as bucket
	from mimic2v26.chartevents ce, mimic2v26.d_patients dp
	where itemid in (198) and ce.subject_id = dp.subject_id and months_between(ce.charttime, dp.dob)/12 > 15) 
group by bucket order by bucket;
*/


--Serum glucose histogram
select bucket, count(*) from (
	select width_bucket("le"."valuenum", 0.5, 1000, 1000) as bucket
	from "MIMIC2"."mimic.tables::labevents" "le", "MIMIC2"."mimic.tables::d_patients" "dp"
	where "itemid" in (50006, 50112) and "le"."valuenum" is not null and "le"."subject_id" = "dp"."subject_id" and months_between("dp"."dob", "le"."charttime")/12 > 15)
group by bucket order by bucket;

--Postgresql
/*
select bucket, count(*) from (
	select width_bucket(valuenum, 0.5, 1000, 1000) as bucket
	from mimic2v26.labevents le, mimic2v26.d patients dp
	where itemid in (50006,50112) and valuenum is not null and le.subject id = dp.subject id and months between(le.charttime, dp.dob)/12 > 15) 
group by bucket order by bucket;
*/



--Serum HCO3 Histogram
select bucket, count(*) from (
	select width_bucket("le"."valuenum", 0, 231, 231) as bucket
	from "MIMIC2"."mimic.tables::labevents" "le"
	where "itemid" in (50022, 50025, 50172))
group by bucket order by bucket;

/*
select bucket, count(*) from (
	select width_bucket(valuenum, 0, 231, 231) as bucket from mimic2v26.labevents
	where itemid in (50022, 50025, 50172)) 
group by bucket order by bucket;
*/



--Hematocrit (%) Histogram
select bucket, count(*) from (
	select width_bucket("ce"."value1num", 0, 150, 150) as bucket
	from "MIMIC2"."mimic.tables::chartevents" "ce", "MIMIC2"."mimic.tables::d_patients" "dp"
	where "itemid" in (813) and "ce"."subject_id" = "dp"."subject_id" and months_between("dp"."dob", "ce"."charttime")/12 > 15)
group by bucket order by bucket;

/*
select bucket, count(*) from (
	select width_bucket(value1num, 0, 150, 150) as bucket
	from mimic2v26.chartevents ce, mimic2v26.d patients dp
	where itemid in (813) and ce.subject id = dp.subject id and months between(ce.charttime, dp.dob)/12 > 15) 
group by bucket order by bucket;
*/



--Heart Rate Histogram
select bucket, count(*) from (
	select width_bucket("ce"."value1num", 0, 300, 301) as bucket
	from "MIMIC2"."mimic.tables::chartevents" "ce", "MIMIC2"."mimic.tables::d_patients" "dp"
	where "itemid" = 211 and "ce"."subject_id" = "dp"."subject_id" and months_between("dp"."dob", "ce"."charttime")/12 > 15)
group by bucket order by bucket;

--Postgresql
/*
select bucket, count(*) from (
	select width_bucket(value1num, 0, 300, 301) as bucket
	from mimic2v26.chartevents ce, mimic2v26.d_patients dp
	where itemid = 211 and ce.subject_id = dp.subject_id and months_between(ce.charttime, dp.dob)/12 > 15) 
group by bucket order by bucket;
*/


--Serum Potassium Histogram
select bucket, count(*) from (
	select width_bucket("le"."valuenum", 0, 10, 100) as bucket
	from "MIMIC2"."mimic.tables::labevents" "le", "MIMIC2"."mimic.tables::d_patients" "dp"
	where "itemid" in (50009, 50149) and "le"."subject_id" = "dp"."subject_id" and months_between("dp"."dob", "le"."charttime")/12 > 15)
group by bucket order by bucket;

--Postgresql
/*
select bucket/10, count(*) from (
	select width_bucket(valuenum, 0, 10, 100) as bucket
	from mimic2v26.labevents le, mimic2v26.d_patients dp
	where itemid in (50009, 50149) and le.subject_id = dp.subject id and months_between(le.charttime, dp.dob)/12 > 15) 
group by bucket order by bucket;
*/



--RR interval Histogram
select bucket, count(*) from (
	select "value1num", width_bucket("ce"."value1num", 0, 130, 1400) as bucket
	from "MIMIC2"."mimic.tables::chartevents" "ce", "MIMIC2"."mimic.tables::d_patients" "dp"
	where "itemid" in (219, 615, 618) and "ce"."subject_id" = "dp"."subject_id" and months_between("dp"."dob", "ce"."charttime")/12 > 15)
group by bucket order by bucket;

--Postgresql
/*
select bucket/10, count(*) from (
	select value1num, width_bucket(value1num, 0, 130, 1400) as bucket
	from mimic2v26.chartevents ce, mimic2v26.d patients dp
	where itemid in (219, 615, 618) and ce.subject id = dp.subject id and months_between(ce.charttime, dp.dob)/12 > 15) 
group by bucket order by bucket;
*/



--Systolic Blood Pressure Histogram
select bucket, count(*) from (
	select width_bucket("ce"."value1num", 0, 300, 300) as bucket
	from "MIMIC2"."mimic.tables::chartevents" "ce", "MIMIC2"."mimic.tables::d_patients" "dp"
	where "itemid" in (6, 51, 455, 6701) and "ce"."subject_id" = "dp"."subject_id" and months_between("dp"."dob", "ce"."charttime")/12 > 15)
group by bucket order by bucket;

--Postgresql
/*
select bucket, count(*) from (
	select width_bucket(value1num, 0, 300, 300) as bucket
	from mimic2v26.chartevents ce, mimic2v26.d patients dp
	where itemid in (6, 51, 455, 6701) and ce.subject id = dp.subject id and months_between(ce.charttime, dp.dob)/12 > 15) 
group by bucket order by bucket;
*/



--Sodium Histogram
select bucket, count(*) from (
	select width_bucket("le"."valuenum", 0, 180, 180) as bucket
	from "MIMIC2"."mimic.tables::labevents" "le", "MIMIC2"."mimic.tables::d_patients" "dp"
	where "itemid" in (50012, 50159) and "le"."subject_id" = "dp"."subject_id" and months_between("dp"."dob", "le"."charttime")/12 > 15)
group by bucket order by bucket;

--Postgresql
/*
select bucket, count(*) from (
	select width_bucket(valuenum, 0, 180, 180) as bucket
	from mimic2v26.labevents le, mimic2v26.d patients dp
	where itemid in (50012, 50159) and le.subject id = dp.subject id and months_between(le.charttime, dp.dob)/12 > 15) 
group by bucket order by bucket;
*/



--Body temperature Histogram
select bucket, count(*) from (
	select width_bucket(
		case
		when "ce"."itemid" in (676, 677) then "ce"."value1num"
		when "ce"."itemid" in (678, 679) then ("ce"."value1num" - 32) * 5 / 9
		end, 30, 45, 160) as bucket
	from "MIMIC2"."mimic.tables::chartevents" "ce", "MIMIC2"."mimic.tables::d_patients" "dp"
	where "itemid" in (676, 677, 678, 679) and "ce"."subject_id" = "dp"."subject_id" and months_between("dp"."dob", "ce"."charttime")/12 > 15)
group by bucket order by bucket;

--Postgresql
/*
select (bucket/10) + 30, count(*) from (
	select width_bucket(
		case 
		when itemid in (676, 677) then value1num
		when itemid in (678, 679) then (value1num - 32) * 5 / 9
		end, 30, 45, 160) as bucket
	from mimic2v26.chartevents ce,mimic2v26.d patients dp
	where itemid in (676, 677, 678, 679) and ce.subject id = dp.subject id and months_between(ce.charttime, dp.dob)/12 > 15) 
group by bucket order by bucket;
*/



--Urine Output Histogram
select bucket, count(*) from (
	select width_bucket("ie"."volume", 0, 1000, 200) as bucket
	from "MIMIC2"."mimic.tables::ioevents" "ie", "MIMIC2"."mimic.tables::d_patients" "dp"
	where "itemid" in (55, 56, 57, 61, 65, 69, 85, 94, 96, 288, 405, 428, 473, 651, 715, 1922, 2042, 2068, 2111, 2119, 2130, 2366, 2463, 
	2507, 2510, 2592, 2676, 2810, 2859, 3053, 3175, 3462, 3519, 3966, 3987, 4132, 4253, 5927) 
	and "ie"."subject_id" = "dp"."subject_id" and months_between("dp"."dob", "ie"."charttime")/12 > 15)
group by bucket order by bucket;

--Postgresql
/*
select bucket*5, count(*) from (
	select width_bucket(volume, 0, 1000, 200) as bucket
	from mimic2v26.ioevents ie,	mimic2v26.d patients dp
	where itemid in (55, 56, 57, 61, 65, 69, 85, 94, 96, 288, 405,
	428, 473, 651, 715, 1922, 2042, 2068, 2111, 2119, 2130, 2366, 2463,
	2507, 2510, 2592, 2676, 2810, 2859, 3053, 3175, 3462, 3519, 3966, 3987,
	4132, 4253, 5927)
	and ie.subject id = dp.subject id and months_between(ie.charttime, dp.dob)/12 > 15) 
group by bucket order by bucket;
*/



--White Blood Cell Count Histogram
select bucket/10, count(*) from (
	select width_bucket("le"."valuenum", 0, 100, 1001) as bucket
	from "MIMIC2"."mimic.tables::labevents" "le", "MIMIC2"."mimic.tables::d_patients" "dp"
	where "itemid" in (50316, 50468) and "le"."valuenum" is not null and "le"."subject_id" = "dp"."subject_id" and months_between("dp"."dob", "le"."charttime")/12 > 15)
group by bucket order by bucket;

--Postgresql
/*
select bucket/10, count(*) from (
	select width_bucket(valuenum, 0, 100, 1001) as bucket
	from mimic2v26.labevents le, mimic2v26.d patients dp
	where itemid in (50316, 50468) and valuenum is not null and le.subject id = dp.subject id and months_between(le.charttime, dp.dob)/12 > 15) 
group by bucket order by bucket;
*/







