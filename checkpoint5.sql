-----------------------------------------------
------- Blood Donation Database Project -------
----------- Author: Aleksei Volkov ------------
---------------- Group: Б05-932 ---------------
----------------- Spring 2021 -----------------
-- INSERT, SELECT, UPDATE and DELETE queries --
-----------------------------------------------

-- 1) View information about open transfusion requests equipped with basic patient information
select person_nm as "Имя Фамилия", gender_code as "Пол", bloodtype_code as "Группа крови", rhesus_flg as "Резус-фактор",
       organization_nm as "Лечебное учреждение", request_dttm as "Время запроса"

    from blood_donation.transfusion_request tr
        inner join blood_donation.patient p
            on p.patient_id = tr.patient_id and p.version_no = tr.version_no
        inner join blood_donation.person p2
            on p2.person_id = p.person_id
        inner join blood_donation.hospital h
            on h.hospital_id = p.hospital_id
        inner join blood_donation.organization o
            on o.organization_id = h.organization_id
    where not satisfied_flg and now() between valid_from_dttm and valid_to_dttm;

-- 2) Let's now find matches for transfusion requests among blood units
-- For the sake of simplicity we will only consider full matches
-- In WHERE clause check that blood type does match and that both request is not satisfied and blood unit is available
-- We will output only minimal required information for us to implement a donation
select tr.*, bu.unit_id
    from blood_donation.transfusion_request as tr
        inner join blood_donation.patient p
            on p.patient_id = tr.patient_id and p.version_no = tr.version_no
        inner join blood_donation.person p2
            on p2.person_id = p.person_id
        inner join blood_donation.hospital h
            on h.hospital_id = p.hospital_id
        inner join blood_donation.hospital_x_bloodbank hxb
            on h.hospital_id = hxb.hospital_id
        inner join blood_donation.bloodbank b
            on b.bloodbank_id = hxb.bloodbank_id
        inner join blood_donation.blood_unit bu
            on b.bloodbank_id = bu.bloodbank_id
        inner join blood_donation.donor d
            on d.donor_id = bu.donor_id
        inner join blood_donation.person p3
            on p3.person_id = d.person_id
    where p3.bloodtype_code = p2.bloodtype_code and p3.rhesus_flg = p2.rhesus_flg and bu.available_flg and not tr.satisfied_flg
            and now() between valid_from_dttm and valid_to_dttm;

-- Let's say a donation of blood unit 7 was assigned to the request with id 1 and valid_to_dttm = infty
-- Now we should update both tables
-- 3) Marking blood unit as used. Since table with blood units is SCD1, we will simply update the value:
update blood_donation.blood_unit
    set available_flg = false
    where unit_id = 7;

-- 4) We need to set the old value of the table to expired...
update blood_donation.transfusion_request
    set valid_to_dttm = now()
    where request_id = 1;

-- 5) ...and provide a new version that has satisfied_flg set to True
insert into blood_donation.transfusion_request (request_id, valid_from_dttm, valid_to_dttm, patient_id, version_no, request_dttm, satisfied_flg)
                                        values (1, now(), 'infinity', 1, 1, '2021-04-07', true);

-- We can verify that everything is nice by reinvoking SELECT query No. 2. Now it shows only one possible transfusion

-- Let's say that a new person decided to become a donor, and now they want to make their first donation
-- 6) Insert the main information about the said person
insert into blood_donation.person (person_id, person_nm, gender_code, bloodtype_code, rhesus_flg, birth_dt)
                           values (default, 'Иван Иванов', 'male', 1, false, '1995-05-06');

-- View his ID since (I do not count this as part of the task):
select * from blood_donation.person
    where person_nm = 'Иван Иванов';

-- 7) And now we will have to register them as a donor. We'll assume that he had his checkup today
insert into blood_donation.donor (donor_id, person_id, last_checkup_dt)
                          values (default, 11, now());

-- We need to know his donor id
select * from blood_donation.donor
    where person_id = 11;

-- 8) Now he makes a donation. Let's add information about it into the system.
insert into blood_donation.blood_unit (donor_id, bloodbank_id, harvested_dttm, available_flg)
                               values (6, 3, now(), true);

-- Let's say that after a short period of time Ivan Ivanov joins a cult that fights against modern technology and he
-- wants to opt out of our information system. Fine, we'll delete all the information regarding him
-- 9) First delete information about transfusion. Who cares if the blood bag is gone?
delete from blood_donation.blood_unit
    where donor_id = 6;

-- 10) Now delete information about him being a donor
delete from blood_donation.donor
    where donor_id = 6;

-- 11) Finally, completely erase him from the system
delete from blood_donation.person
    where person_id = 11;

-- And this is it. Thank you for your attention!