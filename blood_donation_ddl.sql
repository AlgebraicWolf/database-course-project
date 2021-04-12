-----------------------------------------------
------- Blood Donation Database Project -------
----------- Author: Aleksei Volkov ------------
---------------- Group: Б05-932 ---------------
----------------- Spring 2021 -----------------
-------------- Database Structure -------------
-----------------------------------------------

drop schema if exists blood_donation cascade;

create schema blood_donation;

create type blood_donation.gender as enum('male', 'female');

create table blood_donation.person (
    person_id       serial                  primary key,
    person_nm       varchar(200)            not null,
    gender_code     blood_donation.gender   not null,
    bloodtype_code  int                     not null check(bloodtype_code >= 1 and bloodtype_code <= 4),  -- Check that bloodtype is valid
    rhesus_flg      bool                    not null,
    birth_dt        date                    not null check(birth_dt <= now() and birth_dt >= '1900-01-01') -- Person can't be in the system before they are born. Also, it seems that the current longest living human was born in the 20th century, so we can safely implement a cutoff
);

create table blood_donation.organization (
    organization_id serial       primary key,
    organization_nm varchar(200) not null,      -- Whatever, this should be enough
    address_txt     text         not null,      -- Given certain practical examples, it is hard to set precise constraint
    phone_no        varchar(20)                 -- Some countries have longer phone numbers
);

create table blood_donation.donor (
    donor_id            serial  primary key,
    person_id           int     references blood_donation.person(person_id) not null,
    last_checkup_dt     date    not null
);

create table blood_donation.hospital (
    hospital_id     serial  primary key,
    organization_id int     references blood_donation.organization(organization_id) not null,
    beds_cnt        int     not null
);

create table blood_donation.bloodbank (
    bloodbank_id    serial  primary key,
    organization_id int     references blood_donation.organization(organization_id) not null,
    capacity_cnt    int     not null
);

create table blood_donation.patient (
    patient_id      int     not null,
    version_no      int     not null,
    person_id       int     references blood_donation.person(person_id) not null,
    hospital_id     int     references blood_donation.hospital(hospital_id) not null,
    finished_flg    bool    not null,
    diagnosis_desc  text,
    primary key (patient_id, version_no)
);

create table blood_donation.transfusion_request (
    request_id      int         not null,
    valid_from_dttm timestamp   not null,
    valid_to_dttm   timestamp   not null,
    patient_id      int         not null,
    version_no      int         not null,
    request_dttm    timestamp   not null,
    satisfied_flg   bool        not null,
    primary key (request_id, valid_to_dttm),
    foreign key (patient_id, version_no) references blood_donation.patient(patient_id, version_no)
);

create table blood_donation.blood_unit (
    unit_id         serial      primary key,
    donor_id        int         references blood_donation.donor(donor_id) not null,
    bloodbank_id    int         references blood_donation.bloodbank(bloodbank_id) not null,
    harvested_dttm  timestamp   not null,
    available_flg   bool        not null
);

-- It seems that this table has lost its original purpose. Removing it does not break project requirements,
-- so I will remove it c:

-- create table blood_donation.donor_x_hostpital (
--     donor_id    int references blood_donation.donor(donor_id) not null,
--     hospital_id int references blood_donation.hospital(hospital_id) not null,
--     primary key (donor_id, hospital_id)
-- );

create table blood_donation.hospital_x_bloodbank (
    hospital_id     int references blood_donation.hospital(hospital_id) not null,
    bloodbank_id    int references blood_donation.bloodbank(bloodbank_id) not null,
    primary key (hospital_id, bloodbank_id)
);

-- This seems to be it. Thank you for dedicating your time to go through all of this mess.
-- If you want to see a cute photo of a wolf, follow the link:
-- https://🐺🐺🐺🐺.tk/sleepy-wolf.jpg (This is an actual URL, emojis are supposed to be in the link, but your text editor
-- might handle them incorrectly, i. e. do not display them at all. DataGrip does not handle them correnctly in my case).
-- If the link does not work, there is a punycode-converted version:
-- https://xn--fp8haaa.tk/sleepy-wolf.jpg
