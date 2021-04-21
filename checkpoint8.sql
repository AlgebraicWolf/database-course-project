-----------------------------------------------
------- Blood Donation Database Project -------
----------- Author: Aleksei Volkov ------------
---------------- Group: Б05-932 ---------------
----------------- Spring 2021 -----------------
---------------- Various views ----------------
-----------------------------------------------

-- 1. Views that implement field masking
-- 1.1) Fancy view with basic information about donors and masked first and last name
create view blood_donation.donors_masked ("Имя Фамилия", "Пол", "Дата рождения", "Группа крови") as
select regexp_replace(person_nm, '([а-яА-Я])[а-яА-Я]+([а-яА-Я])', '\1*****\2', 'g'),
       case gender_code
        when 'male' then 'М'
        when 'female' then 'Ж'
       end,
       birth_dt,
       concat(case bloodtype_code
        when 1 then 'O'
        when 2 then 'A'
        when 3 then 'B'
        when 4 then 'AB'
       end,
       case rhesus_flg
        when true then '+'
        when false then '-'
       end) from blood_donation.donor d inner join blood_donation.person p on p.person_id = d.person_id;
select * from blood_donation.donors_masked;

-- 1.2) View with hospitals and masked phone numbers (Let's assume that these are some sort of phone numbers for internal
-- communication and they must not be leaked)
create view blood_donation.hospitals_masked ("Название организации", "Адрес", "Номер телефона") as
select organization_nm, address_txt, left(phone_no, 2) || '(***)***-**-' || right(phone_no, 2)
    from blood_donation.hospital h inner join blood_donation.organization o on o.organization_id = h.organization_id;

select * from blood_donation.hospitals_masked;

-- 1.3) Anonymous information on people who received blood transfusion (one record per transfusion). For the sake of fun
-- I've used masking different to the one used in 1.1
create view blood_donation.finished_requests ("ID человека", "ID пациентской записи", "Номер версии", "Фамилия И.", "ID запроса") as
select p2.person_id, p.patient_id, p.version_no,
       overlay(split_part(person_nm, ' ', 2) placing repeat('*', char_length(split_part(person_nm, ' ', 2)) - 2) from 2) || ' ' || left(split_part(person_nm, ' ', 1), 1) || '.',
       request_id from blood_donation.transfusion_request tr
    inner join blood_donation.patient p on p.patient_id = tr.patient_id and p.version_no = tr.version_no
    inner join blood_donation.person p2 on p2.person_id = p.person_id
    where tr.satisfied_flg = true and now() between tr.valid_from_dttm and tr.valid_to_dttm;

select * from blood_donation.finished_requests;

-- 2. Views based on JOINs of tables
-- 2.1) It is useful to have information about open transfusions at hand.
create view blood_donation.open_requests ("Имя Фамилия", "Пол", "Группа крови", "Лечебное учреждение", "Время запроса") as
select person_nm,
       case gender_code
        when 'male' then 'М'
        when 'female' then 'Ж'
       end,
       concat(case bloodtype_code
        when 1 then 'O'
        when 2 then 'A'
        when 3 then 'B'
        when 4 then 'AB'
       end,
       case rhesus_flg
        when true then '+'
        when false then '-'
       end),
       organization_nm,
       request_dttm
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

select * from blood_donation.open_requests;

-- 2.2) We would also want to have convenient access to the table of matches between blood units and transfusion requests
-- that can be used to satisfy them. Let's implement them as view
create view blood_donation.matches ("Имя пациента", "ID запроса", "ID единицы крови") as
select p2.person_nm, tr.request_id, bu.unit_id
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

select * from blood_donation.matches;

-- 2.3) Donor donation count and ranking
create view blood_donation.donor_rank ("ID донора", "Имя донора", "Число сдач крови", "Место") as
select person_id, person_nm, units_donated, dense_rank() over (order by units_donated desc) as place from
    (select distinct p.person_id, p.person_nm, count(*) over (partition by d.donor_id) as units_donated from blood_donation.donor d
        inner join blood_donation.person p on d.person_id = p.person_id
        left join blood_donation.blood_unit bu on d.donor_id = bu.donor_id) as dt;

select * from blood_donation.donor_rank;

-- Thank you for your attention!
-- As per usual, here is a link to a picture of a very handsome wolf:
-- https://🐺🐺🐺🐺.tk/wolf-costume.png
-- OR
-- https://xn--fp8haaa.tk/wolf-costume.png
