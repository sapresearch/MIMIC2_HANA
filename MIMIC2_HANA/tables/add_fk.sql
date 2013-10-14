ALTER TABLE "MIMIC2"."mimic.tables::poe_order" ADD CONSTRAINT "poe_order_fk_d_patien" FOREIGN KEY ("subject_id") REFERENCES "MIMIC2"."mimic.tables::d_patients"("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::poe_order" ADD CONSTRAINT "poe_order_fk_admiss" FOREIGN KEY ("hadm_id")REFERENCES "MIMIC2"."mimic.tables::admissions" ("hadm_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::poe_order" ADD CONSTRAINT "poe_order_fk_icustay" FOREIGN KEY ("icustay_id")REFERENCES "MIMIC2"."mimic.tables::icustayevents" ("icustay_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::a_meddurations" ADD CONSTRAINT "a_meddur_fk_d_patien" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::a_meddurations" ADD CONSTRAINT "a_meddur_fk_d_medite" FOREIGN KEY ("itemid")REFERENCES "MIMIC2"."mimic.tables::d_meditems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::a_meddurations" ADD CONSTRAINT "a_meddur_fk_d_careun" FOREIGN KEY ("cuid")REFERENCES "MIMIC2"."mimic.tables::d_careunits" ("cuid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::a_meddurations" ADD CONSTRAINT "a_meddur_fk_icustay" FOREIGN KEY ("icustay_id")REFERENCES "MIMIC2"."mimic.tables::icustayevents" ("icustay_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::additives" ADD CONSTRAINT "additives_fk_d_caregi" FOREIGN KEY ("cgid")REFERENCES "MIMIC2"."mimic.tables::d_caregivers" ("cgid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::additives" ADD CONSTRAINT "additives_fk_d_careun" FOREIGN KEY ("cuid")REFERENCES "MIMIC2"."mimic.tables::d_careunits" ("cuid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::additives" ADD CONSTRAINT "additives_fk_d_patien" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::additives" ADD CONSTRAINT "additives_fk_d_medite" FOREIGN KEY ("itemid")REFERENCES "MIMIC2"."mimic.tables::d_meditems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::additives" ADD CONSTRAINT "additives_fk_d_ioitem" FOREIGN KEY ("ioitemid")REFERENCES "MIMIC2"."mimic.tables::d_ioitems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::additives" ADD CONSTRAINT "additives_fk_icustay" FOREIGN KEY ("icustay_id")REFERENCES "MIMIC2"."mimic.tables::icustayevents" ("icustay_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::poe_med" ADD CONSTRAINT "poe_med_poe_order_fk1" FOREIGN KEY ("poe_id")REFERENCES "MIMIC2"."mimic.tables::poe_order" ("poe_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::totalbalevents" ADD CONSTRAINT "totalbal_fk_d_patien" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::totalbalevents" ADD CONSTRAINT "totalbal_fk_d_ioitem" FOREIGN KEY ("itemid")REFERENCES "MIMIC2"."mimic.tables::d_ioitems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::totalbalevents" ADD CONSTRAINT "totalbal_fk_d_caregi" FOREIGN KEY ("cgid")REFERENCES "MIMIC2"."mimic.tables::d_caregivers" ("cgid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::totalbalevents" ADD CONSTRAINT "totalbal_fk_d_careun" FOREIGN KEY ("cuid")REFERENCES "MIMIC2"."mimic.tables::d_careunits" ("cuid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::totalbalevents" ADD CONSTRAINT "totalbal_fk_icustay" FOREIGN KEY ("icustay_id")REFERENCES "MIMIC2"."mimic.tables::icustayevents" ("icustay_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::a_iodurations" ADD CONSTRAINT "a_iodura_fk_d_patien" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::a_iodurations" ADD CONSTRAINT "a_iodura_fk_d_ioitem" FOREIGN KEY ("itemid")REFERENCES "MIMIC2"."mimic.tables::d_ioitems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::a_iodurations" ADD CONSTRAINT "a_iodura_fk_d_careun" FOREIGN KEY ("cuid")REFERENCES "MIMIC2"."mimic.tables::d_careunits" ("cuid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::a_iodurations" ADD CONSTRAINT "a_iodura_fk_icustay" FOREIGN KEY ("icustay_id")REFERENCES "MIMIC2"."mimic.tables::icustayevents" ("icustay_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::noteevents" ADD CONSTRAINT "noteeven_fk_d_patien" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::noteevents" ADD CONSTRAINT "noteeven_fk_d_caregi" FOREIGN KEY ("cgid")REFERENCES "MIMIC2"."mimic.tables::d_caregivers" ("cgid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::noteevents" ADD CONSTRAINT "noteeven_fk_d_careun" FOREIGN KEY ("cuid")REFERENCES "MIMIC2"."mimic.tables::d_careunits" ("cuid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::noteevents" ADD CONSTRAINT "noteeven_fk_adm" FOREIGN KEY ("hadm_id")REFERENCES "MIMIC2"."mimic.tables::admissions" ("hadm_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::noteevents" ADD CONSTRAINT "noteeven_fk_icustay" FOREIGN KEY ("icustay_id")REFERENCES "MIMIC2"."mimic.tables::icustayevents" ("icustay_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::ioevents" ADD CONSTRAINT "ioevents_fk_d_patien" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::ioevents" ADD CONSTRAINT "ioevents_fk_d_ioitem" FOREIGN KEY ("itemid")REFERENCES "MIMIC2"."mimic.tables::d_ioitems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::ioevents" ADD CONSTRAINT "ioevents_fk2_d_ioitem" FOREIGN KEY ("altid")REFERENCES "MIMIC2"."mimic.tables::d_ioitems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::ioevents" ADD CONSTRAINT "ioevents_fk_d_caregi" FOREIGN KEY ("cgid")REFERENCES "MIMIC2"."mimic.tables::d_caregivers" ("cgid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::ioevents" ADD CONSTRAINT "ioevents_fk_d_careun" FOREIGN KEY ("cuid")REFERENCES "MIMIC2"."mimic.tables::d_careunits" ("cuid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::ioevents" ADD CONSTRAINT "ioevents_fk_icustay" FOREIGN KEY ("icustay_id")REFERENCES "MIMIC2"."mimic.tables::icustayevents" ("icustay_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::labevents" ADD CONSTRAINT "labevents_fk_subject_id" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::labevents" ADD CONSTRAINT "labevents_fk_itemid" FOREIGN KEY ("itemid")REFERENCES "MIMIC2"."mimic.tables::d_labitems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::labevents" ADD CONSTRAINT "labevents_fk_hadm_id" FOREIGN KEY ("hadm_id")REFERENCES "MIMIC2"."mimic.tables::admissions" ("hadm_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::labevents" ADD CONSTRAINT "labevents_fk_icustay_id" FOREIGN KEY ("icustay_id")REFERENCES "MIMIC2"."mimic.tables::icustayevents" ("icustay_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::chartevents" ADD CONSTRAINT "charteve_fk_d_patien" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::chartevents" ADD CONSTRAINT "charteve_fk_d_charti" FOREIGN KEY ("itemid")REFERENCES "MIMIC2"."mimic.tables::d_chartitems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::chartevents" ADD CONSTRAINT "charteve_fk_d_caregi" FOREIGN KEY ("cgid")REFERENCES "MIMIC2"."mimic.tables::d_caregivers" ("cgid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::chartevents" ADD CONSTRAINT "charteve_fk_d_careun" FOREIGN KEY ("cuid")REFERENCES "MIMIC2"."mimic.tables::d_careunits" ("cuid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::chartevents" ADD CONSTRAINT "charteve_fk_icustay" FOREIGN KEY ("icustay_id")REFERENCES "MIMIC2"."mimic.tables::icustayevents" ("icustay_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::procedureevents" ADD CONSTRAINT "procedureevents_fk_d_patien" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::procedureevents" ADD CONSTRAINT "procedureevents_fk_adm" FOREIGN KEY ("hadm_id")REFERENCES "MIMIC2"."mimic.tables::admissions" ("hadm_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::procedureevents" ADD CONSTRAINT "procedureevents_fk_d_coded" FOREIGN KEY ("itemid")REFERENCES "MIMIC2"."mimic.tables::d_codeditems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::admissions" ADD CONSTRAINT "admissions_fk_d_pati" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::demographicevents" ADD CONSTRAINT "demographicevents_fk_d_patien" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::demographicevents" ADD CONSTRAINT "demographicevents_fk_admit" FOREIGN KEY ("hadm_id")REFERENCES "MIMIC2"."mimic.tables::admissions" ("hadm_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::demographicevents" ADD CONSTRAINT "demographicevents_fk_itemid" FOREIGN KEY ("itemid")REFERENCES "MIMIC2"."mimic.tables::d_demographicitems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::a_chartdurations" ADD CONSTRAINT "a_chartd_fk_d_patien" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::a_chartdurations" ADD CONSTRAINT "a_chartd_fk_d_charti" FOREIGN KEY ("itemid")REFERENCES "MIMIC2"."mimic.tables::d_chartitems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::a_chartdurations" ADD CONSTRAINT "a_chartd_fk_d_careun" FOREIGN KEY ("cuid")REFERENCES "MIMIC2"."mimic.tables::d_careunits" ("cuid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::a_chartdurations" ADD CONSTRAINT "a_chartd_fk_icustay" FOREIGN KEY ("icustay_id")REFERENCES "MIMIC2"."mimic.tables::icustayevents" ("icustay_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::drgevents" ADD CONSTRAINT "drgevents_fk_d_patien" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::drgevents" ADD CONSTRAINT "drgevents_fk_admit" FOREIGN KEY ("hadm_id")REFERENCES "MIMIC2"."mimic.tables::admissions" ("hadm_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::drgevents" ADD CONSTRAINT "drgevents_fk_itemid" FOREIGN KEY ("itemid")REFERENCES "MIMIC2"."mimic.tables::d_codeditems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::icustayevents" ADD CONSTRAINT "icustayev_fk2_d_careu" FOREIGN KEY ("last_careunit")REFERENCES "MIMIC2"."mimic.tables::d_careunits" ("cuid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::icustayevents" ADD CONSTRAINT "icustayev_fk_d_pat" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::icustayevents" ADD CONSTRAINT "icustayev_fk_d_careu" FOREIGN KEY ("first_careunit")REFERENCES "MIMIC2"."mimic.tables::d_careunits" ("cuid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::icd9" ADD CONSTRAINT "icd9_fk_admiss" FOREIGN KEY ("hadm_id")REFERENCES "MIMIC2"."mimic.tables::admissions" ("hadm_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::icd9" ADD CONSTRAINT "icd9_fk_d_patien" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::censusevents" ADD CONSTRAINT "censusev_fk_d_patien" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::censusevents" ADD CONSTRAINT "censusev_fk_d_careun" FOREIGN KEY ("careunit")REFERENCES "MIMIC2"."mimic.tables::d_careunits" ("cuid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::censusevents" ADD CONSTRAINT "censusev_fk2_d_careun" FOREIGN KEY ("destcareunit")REFERENCES "MIMIC2"."mimic.tables::d_careunits" ("cuid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::censusevents" ADD CONSTRAINT "censusev_fk_icustay" FOREIGN KEY ("icustay_id")REFERENCES "MIMIC2"."mimic.tables::icustayevents" ("icustay_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::microbiologyevents" ADD CONSTRAINT "microbioev_fk_d_patients" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::microbiologyevents" ADD CONSTRAINT "microbioev_fk_admissions" FOREIGN KEY ("hadm_id")REFERENCES "MIMIC2"."mimic.tables::admissions" ("hadm_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::microbiologyevents" ADD CONSTRAINT "microbioev_spec_fk_d_coded" FOREIGN KEY ("spec_itemid")REFERENCES "MIMIC2"."mimic.tables::d_codeditems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::microbiologyevents" ADD CONSTRAINT "microbioev_org_fk_d_coded" FOREIGN KEY ("org_itemid")REFERENCES "MIMIC2"."mimic.tables::d_codeditems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::microbiologyevents" ADD CONSTRAINT "microbioev_ab_fk_d_coded" FOREIGN KEY ("ab_itemid")REFERENCES "MIMIC2"."mimic.tables::d_codeditems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::medevents" ADD CONSTRAINT "medevent_fk_d_careun" FOREIGN KEY ("cuid")REFERENCES "MIMIC2"."mimic.tables::d_careunits" ("cuid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::medevents" ADD CONSTRAINT "medevent_fk2_d_medite" FOREIGN KEY ("solutionid")REFERENCES "MIMIC2"."mimic.tables::d_meditems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::medevents" ADD CONSTRAINT "medevent_fk_d_patien" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::medevents" ADD CONSTRAINT "medevent_fk_d_medite" FOREIGN KEY ("itemid")REFERENCES "MIMIC2"."mimic.tables::d_meditems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::medevents" ADD CONSTRAINT "medevent_fk_d_caregi" FOREIGN KEY ("cgid")REFERENCES "MIMIC2"."mimic.tables::d_caregivers" ("cgid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::medevents" ADD CONSTRAINT "medevents_fk_icustay" FOREIGN KEY ("icustay_id")REFERENCES "MIMIC2"."mimic.tables::icustayevents" ("icustay_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::deliveries" ADD CONSTRAINT "deliveri_fk_d_patien" FOREIGN KEY ("subject_id")REFERENCES "MIMIC2"."mimic.tables::d_patients" ("subject_id") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::deliveries" ADD CONSTRAINT "deliveri_fk_d_ioitem" FOREIGN KEY ("ioitemid")REFERENCES "MIMIC2"."mimic.tables::d_ioitems" ("itemid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::deliveries" ADD CONSTRAINT "deliveri_fk_d_caregi" FOREIGN KEY ("cgid")REFERENCES "MIMIC2"."mimic.tables::d_caregivers" ("cgid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::deliveries" ADD CONSTRAINT "deliveri_fk_d_careun" FOREIGN KEY ("cuid")REFERENCES "MIMIC2"."mimic.tables::d_careunits" ("cuid") ON DELETE CASCADE;
ALTER TABLE "MIMIC2"."mimic.tables::deliveries" ADD CONSTRAINT "deliveri_fk_icustay" FOREIGN KEY ("icustay_id")REFERENCES "MIMIC2"."mimic.tables::icustayevents" ("icustay_id") ON DELETE CASCADE;