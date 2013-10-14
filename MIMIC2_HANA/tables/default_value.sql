ALTER TABLE "MIMIC2"."mimic.tables::db_schema" ALTER ("created_dt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
ALTER TABLE "MIMIC2"."mimic.tables::db_schema" ALTER ("updated_dt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP);
ALTER TABLE "MIMIC2"."mimic.tables::db_schema" ALTER ("schema_dt" TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

ALTER TABLE "MIMIC2"."mimic.tables::db_schema" ALTER ("created_by" NVARCHAR(15) DEFAULT CURRENT_USER);

SELECT CURRENT_USER FROM "MIMIC2"."mimic.tables::d_patients";

SELECT CURRENT_SCHEMA "current schema" FROM DUMMY;