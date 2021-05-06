-----------------------------------------------
------- Blood Donation Database Project -------
----------- Author: Aleksei Volkov ------------
---------------- Group: Б05-932 ---------------
----------------- Spring 2021 -----------------
-------------- Stored procedures --------------
-----------------------------------------------

-- Procedure 1: More sophisticated check of donor and recipient compatibility that should allow for more matches to be
-- discovered

create function donor_recipient_compatible(donor_bloodtype int, donor_rhesus bool,
                                           recipient_bloodtype int, recipient_rhesus bool)  RETURNS bool AS $$
    DECLARE
        -- Fields for whether a person has a specific antigen
        donor_a bool := false;
        donor_b bool := false;
        recipient_a bool := false;
        recipient_b bool := false;
    BEGIN
        -- Let's break down person's bloodtype into antigens they have
        IF (donor_bloodtype = 2) OR (donor_bloodtype = 4) THEN donor_a := true;
        END IF;
        IF (donor_bloodtype = 3) OR (donor_bloodtype = 4) THEN donor_b := true;
        END IF;

        IF (recipient_bloodtype = 2) OR (recipient_bloodtype = 4) THEN recipient_a := true;
        END IF;
        IF (recipient_bloodtype = 3) OR (recipient_bloodtype = 4) THEN recipient_b := true;
        END IF;

        -- We're allowed to perform transfusion unless a donor has an antigen that recipient does not
        -- Check for Rh
        IF donor_rhesus AND (NOT recipient_rhesus) THEN RETURN false;
        END IF;
        -- Check for A
        IF donor_a AND (NOT recipient_a) THEN RETURN false;
        END IF;
        -- Check for B
        IF donor_b AND (NOT recipient_b) THEN RETURN false;
        END IF;

        -- if we're here, then everything's fine.
        RETURN true;
    END;
    $$ LANGUAGE plpgsql;

-- Let's make a select with the new function to check it out
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

-- P. S. We still have only one entry since this person has bloodtype O+, and there are no O- donors that would've
-- become available

-- Procedure 2: Simplified update for a patient record that takes care of the version number.
-- Let's assume that if NULL is passed as a parameter, that means that no update on that specific field should be
-- performed.
create or replace procedure update_patient_record(pid int, description text, finished_flg bool)
    LANGUAGE plpgsql
    AS $$
    DECLARE
        last_entry record;
    BEGIN
        IF pid IS NULL THEN
            RAISE EXCEPTION 'NULL is provided instead of a patient ID';
        END IF;

        -- We first need to check that the record is present at all and identify the current version number
        select * into last_entry from blood_donation.patient p where p.patient_id = pid order by version_no desc;

        IF NOT FOUND THEN
            RAISE EXCEPTION 'Patiend with ID % is not found', pid;
        END IF;

        IF description IS NULL THEN
            description := last_entry.diagnosis_desc;
        END IF;

        IF finished_flg IS NULL THEN
            finished_flg := last_entry.finished_flg;
        END IF;

        EXECUTE 'insert into blood_donation.patient (patient_id, version_no, person_id, hospital_id, finished_flg, diagnosis_desc) '
            || 'values ($1, $2, $3, $4, $5, $6)'
            USING pid, last_entry.version_no + 1, last_entry.person_id, last_entry.hospital_id, finished_flg, description;
    END;
    $$;

-- Let's give the new procedure a try and see how it works
-- Right now the patient with ID = 3 has no diagnosis
select * from blood_donation.patient where patient_id = 3;

-- Let's try setting it via new procedure
call update_patient_record(3, 'A victim of a new procedure test', null);
-- And check out the result:
select * from blood_donation.patient where patient_id = 3;
-- Splendid! Everything works as expected! Now let's try to set flag showing that the treatment is finished
call update_patient_record(3, null, true);
select * from blood_donation.patient where patient_id = 3;
-- Again, everything is fine. Let's try to update both fields simultaneously:
call update_patient_record(4, 'Another victim of a procedure test', true);
select * from blood_donation.patient where patient_id = 4;
-- Once again, the procedure seems to work. Let's try to provide it with an ID that is not in the database
call update_patient_record(4417, 'This ID should not exist', true);
-- As expected, an error message is produced. The same goes for null instead of ID:
call update_patient_record(null, null, null);

-- That's all regarding procedures. Here are wolves:
-- https://🐺🐺🐺🐺.tk/wolf-belly.jpg
-- OR
-- https://xn--fp8haaa.tk/wolf-belly.jpg
