select 
count("ad"."subject_id") as admissions,
count("po"."subject_id") as poe_order,
count("id"."subject_id") as icustay_days,
count("cs"."subject_id") as comorbidity_scores,
count("dd"."subject_id") as demographic_detail,
count("id"."subject_id") as icustay_detail,
count("c"."subject_id") as censusevents,
count("l"."subject_id") as labevents,
count("n"."subject_id") as noteevents,
count("d"."subject_id") as deliveries,
count("pm"."poe_id") as poe_med,
count("t"."subject_id") as totalbalevents,
count("p"."subject_id") as procedureevents,
count("i"."subject_id") as icd9,
count("ce"."subject_id") as chartevents,
count("ie"."subject_id") as ioevents,
count("de"."subject_id") as demographicevents,
count("a"."subject_id") as additives,
count("dre"."subject_id") as drgevents,
count("dp"."subject_id") as d_patients,
count("icus"."subject_id") as icustayevents,
count("ac"."subject_id") as a_chartdurations,
count("ai"."subject_id") as a_iodurations,
count("am"."subject_id") as a_meddurations,
count("isd"."subject_id") as icustay_days,
count("isdet"."subject_id") as icustay_detail,
count("me"."subject_id") as medevents,
count("mbe"."subject_id") as microbiologyevents,
count("ne"."subject_id") as noteevents
from 
"MIMIC2"."mimic.tables::admissions" "ad",
"MIMIC2"."mimic.tables::poe_order" "po",
"MIMIC2"."mimic.tables::icustay_days" "id",
"MIMIC2"."mimic.tables::comorbidity_scores" "cs",
"MIMIC2"."mimic.tables::demographic_detail" "dd",
"MIMIC2"."mimic.tables::icustay_detail" "icd",
"MIMIC2"."mimic.tables::censusevents" "c",
"MIMIC2"."mimic.tables::labevents" "l",
"MIMIC2"."mimic.tables::noteevents" "n",
"MIMIC2"."mimic.tables::deliveries" "d",
"MIMIC2"."mimic.tables::poe_med" "pm",
"MIMIC2"."mimic.tables::totalbalevents" "t",
"MIMIC2"."mimic.tables::procedureevents" "p",
"MIMIC2"."mimic.tables::icd9" "i",
"MIMIC2"."mimic.tables::chartevents" "ce",
"MIMIC2"."mimic.tables::ioevents" "ie",
"MIMIC2"."mimic.tables::demographicevents" "de",
"MIMIC2"."mimic.tables::additives" "a",
"MIMIC2"."mimic.tables::drgevents" "dre",
"MIMIC2"."mimic.tables::d_patients" "dp",
"MIMIC2"."mimic.tables::icustayevents" "icus",
"MIMIC2"."mimic.tables::a_chartdurations" "ac",
"MIMIC2"."mimic.tables::a_iodurations" "ai",
"MIMIC2"."mimic.tables::a_meddurations" "am",
"MIMIC2"."mimic.tables::icustay_days" "isd",
"MIMIC2"."mimic.tables::icustay_detail" "isdet",
"MIMIC2"."mimic.tables::medevents" "me",
"MIMIC2"."mimic.tables::microbiologyevents" "mbe",
"MIMIC2"."mimic.tables::noteevents" "ne";