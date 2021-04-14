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
-- Show the amount of blood units donated by each donor
select distinct p.person_id, p.person_nm, count(*) over (partition by d.donor_id) as units_donated from blood_donation.donor d
        inner join blood_donation.person p on d.person_id = p.person_id
        left join blood_donation.blood_unit bu on d.donor_id = bu.donor_id;

-- func + OVER() + ORDER BY
-- Show rating of donors by the amount of units donated
select person_id, person_nm, dense_rank() over (order by units_donated desc) as place from
    (select distinct p.person_id, p.person_nm, count(*) over (partition by d.donor_id) as units_donated from blood_donation.donor d
        inner join blood_donation.person p on d.person_id = p.person_id
        left join blood_donation.blood_unit bu on d.donor_id = bu.donor_id) as dt;

-- Show minimal and maximal time intervals between donations for each donor
-- func + OVER() + PARTITION BY + ORDER BY
select person_id, person_nm, min(diff) as minimal_interval, max(diff) as maximal_interval from
    (select * from
        (select distinct p.person_id, p.person_nm, bu.harvested_dttm - lag(harvested_dttm) over (partition by d.donor_id order by harvested_dttm) as diff from blood_donation.donor d
            inner join blood_donation.person p on d.person_id = p.person_id
            left join blood_donation.blood_unit bu on d.donor_id = bu.donor_id) diff_table
        where diff is not null) as filtered_diff
    group by person_id, person_nm;

-- Thank you for your attention!
-- Here is another cute picture of wolves
-- Link A: https://xn--fp8haaa.tk/🐺🐺🐺🐺.jpg
-- Link B: https://xn--fp8haaa.tk/wolf-scarf.jpg