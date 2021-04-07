-----------------------------------------------
------- Blood Donation Database Project -------
----------- Author: Aleksei Volkov ------------
---------------- Group: Б05-932 ---------------
----------------- Spring 2021 -----------------
----------------- Initial Data ----------------
-----------------------------------------------

-- Insert organizations
insert into blood_donation.organization (organization_id, organization_nm, address_txt, phone_no)
                                values  (default, 'Больница №1 г. Воронежа', 'г. Воронеж, пр-т Хайповой Проги, 23', '+7(401)863-58-42');

insert into blood_donation.organization (organization_id, organization_nm, address_txt, phone_no)
                                values  (default, 'Больница №1 г. Махачкалы', 'г. Махачкала, ул. Современной Матеши, 1337', '+7(401)808-87-76');

insert into blood_donation.organization (organization_id, organization_nm, address_txt, phone_no)
                                values  (default, 'Больница №1 г. Москвы', 'г. Москва, ул. Нереального Флекса, 4417', '+7(401)410-52-95');

insert into blood_donation.organization (organization_id, organization_nm, address_txt, phone_no)
                                values  (default, 'Больница №2 г. Москвы', 'г. Москва, пер. Gachi-Ремиксов, 11', '+7(401)998-51-08');

insert into blood_donation.organization (organization_id, organization_nm, address_txt, phone_no)
                                values  (default, 'Больница №3 г. Москвы', 'г. Москва, Чиллерное шоссе, 228', '+7(401)912-74-38');

insert into blood_donation.organization (organization_id, organization_nm, address_txt, phone_no)
                                values  (default, 'Станция переливания крови №1 г. Воронежа', 'г. Воронеж, ул. Двойного Яблочка, 212', '+7(401)146-62-69');

insert into blood_donation.organization (organization_id, organization_nm, address_txt, phone_no)
                                values  (default, 'Станция переливания крови №2 г. Воронежа', 'г. Воронеж, ул. Кринжа, 65', '+7(401)214-42-36');

insert into blood_donation.organization (organization_id, organization_nm, address_txt, phone_no)
                                values  (default, 'Станция переливания крови №1 г. Махачкалы', 'г. Махачкала, пр-т Чучхе, 232', '+7(401)521-08-96');

insert into blood_donation.organization (organization_id, organization_nm, address_txt, phone_no)
                                values  (default, 'Станция переливания крови №1 г. Москвы', 'г. Москва, ул. Академщиков, 98', '+7(401)264-22-45');

insert into blood_donation.organization (organization_id, organization_nm, address_txt, phone_no)
                                values  (default, 'Станция переливания крови №2 г. Москвы', 'г. Москва, пер. Выгорания, 434', '+7(401)321-29-30');

-- Insert hospitals
insert into blood_donation.hospital (hospital_id, organization_id, beds_cnt)
                            values  (default, 1, 0);

insert into blood_donation.hospital (hospital_id, organization_id, beds_cnt)
                            values  (default, 2, 0);

insert into blood_donation.hospital (hospital_id, organization_id, beds_cnt)
                            values  (default, 3, 0);

insert into blood_donation.hospital (hospital_id, organization_id, beds_cnt)
                            values  (default, 4, 0);

insert into blood_donation.hospital (hospital_id, organization_id, beds_cnt)
                            values  (default, 5, 0);

-- Insert bloodbanks

insert into blood_donation.bloodbank    (bloodbank_id, organization_id, capacity_cnt)
                            values      (default, 6, 0);

insert into blood_donation.bloodbank    (bloodbank_id, organization_id, capacity_cnt)
                            values      (default, 7, 0);

insert into blood_donation.bloodbank    (bloodbank_id, organization_id, capacity_cnt)
                            values      (default, 8, 0);

insert into blood_donation.bloodbank    (bloodbank_id, organization_id, capacity_cnt)
                            values      (default, 9, 0);

insert into blood_donation.bloodbank    (bloodbank_id, organization_id, capacity_cnt)
                            values      (default, 10, 0);

-- Insert hospital_x_bloodbank (who works with who)

insert into blood_donation.hospital_x_bloodbank (hospital_id, bloodbank_id)
                                        values  (1, 1);

insert into blood_donation.hospital_x_bloodbank (hospital_id, bloodbank_id)
                                        values  (1, 2);

insert into blood_donation.hospital_x_bloodbank (hospital_id, bloodbank_id)
                                        values  (2, 3);

insert into blood_donation.hospital_x_bloodbank (hospital_id, bloodbank_id)
                                        values  (3, 4);

insert into blood_donation.hospital_x_bloodbank (hospital_id, bloodbank_id)
                                        values  (4, 4);

insert into blood_donation.hospital_x_bloodbank (hospital_id, bloodbank_id)
                                        values  (5, 4);

insert into blood_donation.hospital_x_bloodbank (hospital_id, bloodbank_id)
                                        values  (3, 5);

insert into blood_donation.hospital_x_bloodbank (hospital_id, bloodbank_id)
                                        values  (4, 5);

insert into blood_donation.hospital_x_bloodbank (hospital_id, bloodbank_id)
                                        values  (5, 5);

-- Insert people
-- To-be donors
insert into blood_donation.person   (person_id, person_nm, gender_code, bloodtype_code, rhesus_flg, birth_dt)
                        values      (default, 'Алексей Волков', 'male', 3, true, '2001-03-10');

insert into blood_donation.person   (person_id, person_nm, gender_code, bloodtype_code, rhesus_flg, birth_dt)
                        values      (default, 'Борис Табачников', 'male', 2, true, '2001-04-23');

insert into blood_donation.person   (person_id, person_nm, gender_code, bloodtype_code, rhesus_flg, birth_dt)
                        values      (default, 'Максим Кокряшкин', 'male', 2, true, '2002-05-22');

insert into blood_donation.person   (person_id, person_nm, gender_code, bloodtype_code, rhesus_flg, birth_dt)
                        values      (default, 'Кристина Кулабухова', 'female', 1, true, '2001-11-06');

insert into blood_donation.person   (person_id, person_nm, gender_code, bloodtype_code, rhesus_flg, birth_dt)
                        values      (default, 'Адам Ильдаров', 'male', 3, true, '2001-11-24');

-- To-be patients
insert into blood_donation.person   (person_id, person_nm, gender_code, bloodtype_code, rhesus_flg, birth_dt)
                        values      (default, 'Наталья Иванова', 'female', 1, true, '1976-07-09');

insert into blood_donation.person   (person_id, person_nm, gender_code, bloodtype_code, rhesus_flg, birth_dt)
                        values      (default, 'Казимир Сергеев', 'male', 3, false, '1978-04-08');

insert into blood_donation.person   (person_id, person_nm, gender_code, bloodtype_code, rhesus_flg, birth_dt)
                        values      (default, 'Арина Николаева', 'female', 2, true, '1998-02-16');

insert into blood_donation.person   (person_id, person_nm, gender_code, bloodtype_code, rhesus_flg, birth_dt)
                        values      (default, 'Анфиса Егорова', 'female', 4, false, '2002-11-11');

insert into blood_donation.person   (person_id, person_nm, gender_code, bloodtype_code, rhesus_flg, birth_dt)
                        values      (default, 'Демьян Морозов', 'male', 1, true, '2003-07-28');

-- Insert donors
insert into blood_donation.donor    (donor_id, person_id, last_checkup_dt)
                        values      (default, 1, '2020-03-18');

insert into blood_donation.donor    (donor_id, person_id, last_checkup_dt)
                        values      (default, 2, '2020-07-01');

insert into blood_donation.donor    (donor_id, person_id, last_checkup_dt)
                        values      (default, 3, '2020-09-21');

insert into blood_donation.donor    (donor_id, person_id, last_checkup_dt)
                        values      (default, 4, '2020-12-25');

insert into blood_donation.donor    (donor_id, person_id, last_checkup_dt)
                        values      (default, 5, '2020-06-15');

-- Insert blood_donation_x_hospitals, i. e.
-- This table seems to be redundant, I do not remember its original purpose, so it is going to be deleted(

-- Insert donated blood units
insert into blood_donation.blood_unit   (unit_id, donor_id, bloodbank_id, harvested_dttm, available_flg)
                            values      (default, 1, 2, '2020-12-09', true);

insert into blood_donation.blood_unit   (unit_id, donor_id, bloodbank_id, harvested_dttm, available_flg)
                            values      (default, 1, 5, '2020-12-10', true);

insert into blood_donation.blood_unit   (unit_id, donor_id, bloodbank_id, harvested_dttm, available_flg)
                            values      (default, 5, 3, '2021-01-27', true);

insert into blood_donation.blood_unit   (unit_id, donor_id, bloodbank_id, harvested_dttm, available_flg)
                            values      (default, 5, 4, '2021-02-03', true);

insert into blood_donation.blood_unit   (unit_id, donor_id, bloodbank_id, harvested_dttm, available_flg)
                            values      (default, 1, 1, '2021-02-08', true);

insert into blood_donation.blood_unit   (unit_id, donor_id, bloodbank_id, harvested_dttm, available_flg)
                            values      (default, 3, 5, '2021-02-09', true);

insert into blood_donation.blood_unit   (unit_id, donor_id, bloodbank_id, harvested_dttm, available_flg)
                            values      (default, 4, 4, '2021-02-10', true);

insert into blood_donation.blood_unit   (unit_id, donor_id, bloodbank_id, harvested_dttm, available_flg)
                            values      (default, 5, 5, '2021-02-12', true);

insert into blood_donation.blood_unit   (unit_id, donor_id, bloodbank_id, harvested_dttm, available_flg)
                            values      (default, 3, 4, '2021-03-26', true);

insert into blood_donation.blood_unit   (unit_id, donor_id, bloodbank_id, harvested_dttm, available_flg)
                            values      (default, 4, 5, '2021-04-01', true);

-- Insert patient records
insert into blood_donation.patient  (patient_id, version_no, person_id, hospital_id, finished_flg, diagnosis_desc)
                            values  (1, 1, 6, 3, false, 'Недостаток калика в организме');

insert into blood_donation.patient  (patient_id, version_no, person_id, hospital_id, finished_flg, diagnosis_desc)
                            values  (2, 1, 7, 1, false, 'Передоз диффуров');

-- Differential equations have killed me, I'm running low on imagination, though I can make more as a part of upcoming task
insert into blood_donation.patient  (patient_id, version_no, person_id, hospital_id, finished_flg, diagnosis_desc)
                            values  (3, 1, 8, 2, false, null);

insert into blood_donation.patient  (patient_id, version_no, person_id, hospital_id, finished_flg, diagnosis_desc)
                            values  (4, 1, 9, 4, false, null);

insert into blood_donation.patient  (patient_id, version_no, person_id, hospital_id, finished_flg, diagnosis_desc)
                            values  (5, 1, 10, 5, false, null);

-- Insert transfusion requests

insert into blood_donation.transfusion_request  (request_id, valid_from_dttm, valid_to_dttm, patient_id, version_no, request_dttm, satisfied_flg)
                                        values  (1, '2021-04-07', 'infinity', 1, 1, '2021-04-07', false);

insert into blood_donation.transfusion_request  (request_id, valid_from_dttm, valid_to_dttm, patient_id, version_no, request_dttm, satisfied_flg)
                                        values  (2, '2021-04-03', 'infinity', 2, 1, '2021-04-03', false);

insert into blood_donation.transfusion_request  (request_id, valid_from_dttm, valid_to_dttm, patient_id, version_no, request_dttm, satisfied_flg)
                                        values  (3, '2021-04-04', 'infinity', 3, 1, '2021-04-04', false);

insert into blood_donation.transfusion_request  (request_id, valid_from_dttm, valid_to_dttm, patient_id, version_no, request_dttm, satisfied_flg)
                                        values  (4, '2021-04-06', 'infinity', 4, 1, '2021-04-06', false);

insert into blood_donation.transfusion_request  (request_id, valid_from_dttm, valid_to_dttm, patient_id, version_no, request_dttm, satisfied_flg)
                                        values  (5, '2021-03-31', 'infinity', 5, 1, '20201-03-31', false);

-- This is it, I guess. Thank you for your attention!
