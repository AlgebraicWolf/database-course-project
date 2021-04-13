-----------------------------------------------
------- Blood Donation Database Project -------
----------- Author: Aleksei Volkov ------------
---------------- Group: Б05-932 ---------------
----------------- Spring 2021 -----------------
--------------- Various SELECTs ---------------
-----------------------------------------------

-- GROUP BY + HAVING
-- Select donors who have made three donations or more.
select p.person_id, person_nm, count(*) as donated from blood_donation.donor
    inner join blood_donation.person p on p.person_id = donor.person_id
    left join blood_donation.blood_unit bu on donor.donor_id = bu.donor_id
    group by p.person_id
    having count(*) >= 3;

-- ORDER BY
-- Show available blood units ordering them by their harvest time (might be useful for the purpose of selecting them in
-- the way that minimizes spoiling)
select * from blood_donation.blood_unit
    where available_flg
    order by harvested_dttm desc;

-- func + OVER() + PARTITION BY

-- func + OVER() + ORDER BY

-- func + OVER() + PARTITION BY + ORDER BY

-- am tired :c