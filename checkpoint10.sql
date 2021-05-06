-----------------------------------------------
------- Blood Donation Database Project -------
----------- Author: Aleksei Volkov ------------
---------------- Group: Б05-932 ---------------
----------------- Spring 2021 -----------------
------------------- Triggers ------------------
-----------------------------------------------

-- Trigger 1: Trigger that checks whether a person fits age requirements for being a donor.
-- First, we need to define a procedure for that will be called
create function age_verification() returns trigger
    as $$
    DECLARE
        person_record record;
    BEGIN
        -- Get an associated person record
        select * into person_record from blood_donation.person where person_id = new.person_id;

        -- In case person should not be allowed to be a donor, raise an exception
        IF person_record.birth_dt + '18 years'::interval >= now()::date THEN
            RAISE EXCEPTION 'This person is under 18 years of age';
        ELSE
            RETURN new;
        END IF;
    END;
    $$ language plpgsql;

-- Now we can create a trigger itself
create trigger check_age
    before insert on blood_donation.donor
    for each row
    execute procedure age_verification();

-- Let's try this out. We have a person with person_id = 10 that is under 18. Let's try to register them as a donor
insert into blood_donation.donor (donor_id, person_id, last_checkup_dt) values (default, 10, now());
select * from blood_donation.donor;
-- As expected, we've received an error and no record was added. Now let's try and insert a person that we should be
-- able to insert
insert into blood_donation.donor (donor_id, person_id, last_checkup_dt) values (default, 9, now());
select * from blood_donation.donor;
-- Everything had worked as expected. Neat!

-- Trigger 2: Automates addition of a blood transfusion. Let's also implement a check that ensures that both ids
-- exist and that both request is open and blood unit is available

-- (At this moment I've realized that I have no mechanism that stores matches between blood units and requests. Welp,
-- whatever, such things can happen. Let's implement such. To do that, let's add a foreign key to the table with
-- transfusion requests.
alter table blood_donation.transfusion_request
    add column unit_id int references blood_donation.blood_unit(unit_id);

-- Now we can implement trigger function itself

create or replace function transfuse() returns trigger
    as $$
    DECLARE
        unit record;
        cur_time timestamp without time zone;
    BEGIN
        IF new.satisfied_flg THEN
            RAISE EXCEPTION 'Transfusion request is already satisfied';
        END IF;

        select * into unit from blood_donation.blood_unit where blood_unit.unit_id = new.unit_id;
        IF NOT FOUND THEN
            RAISE EXCEPTION 'Blood unit does not exist';
        END IF;

        IF NOT unit.available_flg THEN
            RAISE EXCEPTION 'Blood unit is not available';
        END IF;

        -- If we're here, then we can do all the updates. Let's mark blood unit as non-available
        update blood_donation.blood_unit set available_flg = false where unit_id = new.unit_id;

        -- Let's fix timestamp
        cur_time := now();
        -- And now we should mark an old version expired and add a new version.
        EXECUTE 'update blood_donation.transfusion_request set valid_to_dttm = $1 where request_id = $2
            and valid_to_dttm = $3' USING cur_time, new.request_id, new.valid_to_dttm at time zone 'Europe/Moscow';
        insert into blood_donation.transfusion_request (request_id, valid_from_dttm, valid_to_dttm, patient_id, version_no, request_dttm, satisfied_flg, unit_id)
            values (new.request_id, cur_time, 'infinity'::timestamp, new.patient_id, new.version_no, new.request_dttm, true, new.unit_id);
        -- And this is it.
        RETURN NULL;
    END;
    $$ language plpgsql;

-- Now the trigger will work as follows: in order to add a transfusion one should perform an update on unit_id field.
-- This update will be replaced by an insert with a new version of a row and an update in a table with blood units

create trigger transfusion_automation
    before update on blood_donation.transfusion_request
    for each row
    when (old.unit_id is distinct from new.unit_id)
    execute procedure transfuse();

-- Let's find a request that we can satisfy
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
    where donor_recipient_compatible(p3.bloodtype_code, p3.rhesus_flg, p2.bloodtype_code, p2.rhesus_flg) and bu.available_flg and not tr.satisfied_flg
            and now() between valid_from_dttm and valid_to_dttm;

-- And try satisfying it:
update blood_donation.transfusion_request
    set unit_id = 10
    where now() between valid_from_dttm and valid_to_dttm
          and request_id = 5;

-- If we will check now, there is no more request to satisfy. Let's check tables with blood units and transfusion
-- requests to make sure that they were properly updated
select * from blood_donation.transfusion_request where request_id = 5;
select * from blood_donation.blood_unit where unit_id = 10;

-- Everything seems to be correct.

-- Thank you for your attention! If you are here for the wolves, here is the picture (this time I was unable to decide
-- between two pictures, so each checkpoint is equipped with one):
-- https://🐺🐺🐺🐺.tk/wolf-hug.jpg
-- OR
-- https://xn--fp8haaa.tk/wolf-hug.jpg


