
--Create the table that contains all the information and features that we want for our prediction algorithm
--Note that we create the column 'training' where training examples are selected at random. 1 means it's for training, 0 for testing.
drop table "MIMIC2"."mimic.prediction::death_features";
create column table "MIMIC2"."mimic.prediction::death_features" as (
	select "icud"."icustay_id" ,
		"icud"."dob" ,
		"icud"."dod" ,
		"icud"."hospital_admit_dt" ,
		"icud"."icustay_admit_age" "age",
		"icud"."weight_first" ,
		"icud"."weight_min" ,
		"icud"."weight_max" ,
		"icud"."sapsi_first",
		"icud"."sofa_first",
	map("icud"."gender",'F',0,'M',1) "gender",
	map("icud"."dod",null,0,1) DEAD,
	1-floor(rand()/0.75) "training"
	from "MIMIC2"."mimic.tables::icustay_detail" "icud"
	where "icud"."weight_first" is not null and
		"icud"."weight_min" is not null and
		"icud"."weight_max" is not null and
		"icud"."sapsi_first" is not null and
		"icud"."sofa_first" is not null and
		"icud"."gender" is not null
);
alter table "MIMIC2"."mimic.prediction::death_features" add (CPREDICT nvarchar(10), CPROB decimal);

DROP TYPE "MIMIC2"."model_type";
CREATE TYPE "MIMIC2"."model_type" AS TABLE(model_id varchar(32));

DROP PROCEDURE "MIMIC2"."proc_death_training";
CREATE PROCEDURE "MIMIC2"."proc_death_training" (IN input1 "MIMIC2"."mimic.prediction::death_features", OUT output1 "MIMIC2"."model_type")
LANGUAGE RLANG AS
BEGIN
  	library("kernlab");
  	library("ron");
  	library(RODBC);

	myconn <-odbcConnect("hana", uid="SYSTEM", pwd="HANA4ever");

	input_training <- input1[input1$training == 1,];
	meta_cols <- c("dob","dod", "hospital_admit_dt","DEAD","training","CPREDICT","CPROB");
	x_train <- data.matrix(input_training[-match(meta_cols, names(input_training))]);
	y_train <- input_training$DEAD;
	model <- ksvm(x_train, y_train, type = "C-bsvc", kernel = "rbfdot", kpar = list(sigma = 0.1), C = 10, prob.model = TRUE);
	
	saveRobject(myconn, model, "deathTest", forceUpdate=TRUE);
	
	MODEL_ID = c("DEATH_MODEL");
	output1 <- data.frame(MODEL_ID);
end;


drop procedure "MIMIC2"."proc_death_prediction";
create procedure "MIMIC2"."proc_death_prediction" (IN input1 "MIMIC2"."mimic.prediction::death_features", OUT output1 "MIMIC2"."mimic.prediction::death_features")
language RLANG as
begin
  	library("kernlab");
  	library(RODBC)
	myconn <-odbcConnect("hana", uid="SYSTEM", pwd="HANA4ever")
	model <- loadRobject(conn, "irisTest");	
	
	input_test <- input1;
	meta_cols <- c("dob","dod", "hospital_admit_dt","DEAD","training");
	x_test <- input_test[-match(meta_cols, names(input_test))];

	prob_matrix <- predict(model, x_test, type="probabilities");

	clabel <- apply(prob_matrix, 1, which.max);
	cprob <- apply(prob_matrix, 1, max);
	classlabels = colnames(prob_matrix);
	clabel <- classlabels[clabel];

	output1 <- input1;
	output1$CPREDICT <- clabel;
	output1$CPROB <- cprob;
	
end;



-- Create the table for training. Subset of the main table.
drop table "MIMIC2"."mimic.prediction::death_train";
create column table "MIMIC2"."mimic.prediction::death_train" as (
	select * from "MIMIC2"."mimic.prediction::death_features" where "training" = 1
);
select count(*) from "MIMIC2"."mimic.prediction::death_prediction";

drop table outpt like "MIMIC2"."model_type";
call "MIMIC2"."proc_death_training"("MIMIC2"."mimic.prediction::death_train", "MIMIC2"."model_type")

-- Create the table for testing. Subset of the main table.
drop table "MIMIC2"."mimic.prediction::death_prediction";
create column table "MIMIC2"."mimic.prediction::death_prediction" as (
	select * from "MIMIC2"."mimic.prediction::death_features" where "training" = 0
);

drop table "MIMIC2"."mimic.prediction::death_output";
create column table "MIMIC2"."mimic.prediction::death_output" like "MIMIC2"."mimic.prediction::death_features";

call "MIMIC2"."proc_death_train_predict"("MIMIC2"."mimic.prediction::death_prediction","MIMIC2"."mimic.prediction::death_output") with overview;


select 1-sum(abs(DEAD - CPREDICT))/count(*) from "MIMIC2"."mimic.prediction::death_output";
