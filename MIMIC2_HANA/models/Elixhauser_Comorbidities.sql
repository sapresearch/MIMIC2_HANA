
drop type str_column;
create type str_column as table (STR nvarchar(100));

drop type result;
create type result as table (HADM_ID INTEGER, CODE NVARCHAR(100));

drop view ICD9_ALPHANUM;
create view ICD9_ALPHANUM as
select "hadm_id", "code" from "MIMIC2"."mimic.tables::icd9";

drop table CHAR_REGEX;
create column table CHAR_REGEX like str_column; 
insert into CHAR_REGEX values('^[^0-9]');

drop table DEC_REGEX;
create column table DEC_REGEX like str_column; 
insert into DEC_REGEX values('[0-9]+$|[0-9]+\.[0-9]+$');

drop table IDC9_ALPHA;
create column table IDC9_ALPHA like result;

drop procedure regexp_substr;
create procedure regexp_substr(IN regex_in str_column, IN inpt ICD9_ALPHANUM, OUT result_out result)
language RLANG as
begin
	library(stringr);
	
	regex <- as.data.frame(regex_in)[1,1]
	input_df <- as.data.frame(inpt);
	result_out <- data.frame(c(input_df[[1]]), str_extract(input_df[[2]], regex));
	names(result_out) <- c("HADM_ID", "CODE");
	
end;

call regexp_substr(CHAR_REGEX, icd9_alphanum, IDC9_ALPHA) with overview;

drop table IDC9_NUMERIC;
create column table IDC9_NUMERIC like result;
call regexp_substr(DEC_REGEX, ICD9_ALPHANUM, IDC9_NUMERIC) with overview;


---------------------------------------------------------------------------------------
drop table #TEMP_ICD9;
create local temporary column table #TEMP_ICD9 as (
select ICD."code", ICD."sequence" from "MIMIC2"."mimic.tables::icd9" ICD);

alter table #TEMP_ICD9
add ("IDC9_ALPHA" nvarchar(100));

drop view icd9list;
create view icd9list as (
	select ADM."hadm_id", ICD."code", ICD."sequence" from "MIMIC2"."mimic.tables::admissions" ADM, "MIMIC2"."mimic.tables::icd9" ICD
	where ADM."hadm_id" = ICD."hadm_id");

select count(*) from icd9list;
select count(*) from "MIMIC2"."mimic.tables::admissions" ADM;


