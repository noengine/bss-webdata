DROP TABLE IF EXISTS flight_log;
CREATE TABLE flight_log (
        log_type                        text (1),
        flight_date                     date,
        flight_number                   integer,
        glider_registration             text (3),
        pilot_in_command                integer,
        second_pilot                    integer,
        flight_type                     text (1),
        tug_registration                text (3),
        tug_pilot                       integer,
        time_off                        time,
        tug_down                        time,
        glider_down                     time,
        tow_height                      text (5),
        retrieve_tug_time               integer,
        retrieve_glider_time            integer,
        processed                       boolean,
        flight_cost                     decimal(10,2),
        member_code_1                   integer,
        member_code_2                   integer,
        peak_flag                       boolean,
        comment                         text (50),
        distance                        integer,
        airfield                        text (50),
	INDEX (flight_date),
	INDEX (flight_number),
	INDEX (glider_registration(3)),
	INDEX (pilot_in_command),
	INDEX (second_pilot),
	INDEX (tug_pilot)
);

DROP TABLE IF EXISTS membership_types;
CREATE TABLE membership_types (
	member_type			text (2) NOT NULL,
	explanation			text (20),
	bss_fee				decimal(10,2),
	gfa				decimal(10,2),
	caravanfee			decimal(10,2),
	airconfee			decimal(10,2),
	PRIMARY KEY (member_type(2))
);

DROP TABLE IF EXISTS member_transactions;
CREATE TABLE member_transactions (
	member_id			integer,
	date				date,
	type				text (10),
	sequence_number			integer NOT NULL,
	transaction			text (30),
	ref_no				text (10),
	origin				text (15),
	amount				decimal (10,2),
	comment				varchar (255),
	PRIMARY KEY (sequence_number),
	INDEX (member_id)
);

DROP TABLE IF EXISTS members;
CREATE TABLE members (
	member_id			integer NOT NULL,
	first_name			text (16),
	surname				text (25),
	initials			text (6),
	member_type			text (2),
	street_address			text (200),
	suburb				text (32),
	post_code			text (10),
	phone_number			text (16),
	fax_number			text (15),
	home_number			text (16),
	mobile_number			text (50),
	email_address			text (50),
	birth_date			datetime,
	partner_spouse_first_name	text (20),
	next_of_kin			text (32),
	next_of_kin_phone_no		text (16),
	occupation			text (20),
	di_ticket			boolean,
	duty_pilot			boolean,
	instructor			text (10),
	form2				text (10),
	towpilot			boolean,
	membership_expiry_date		date,
	gfa_expiry_date			date,
	caravan_expiry_date		date,
	caravanaircon			text (50),
	caravanshare			integer,
	caravannumber			integer,
	caravan_a_cond			boolean,
	monthly				boolean,
	post_soardid			boolean,
	done_check_flight		boolean,
	check_flight_due		date,
	gfa_number			text (50),
	solo				boolean,
	badge_a				boolean, 
	badge_b				boolean,
	badge_c				boolean,
	badge_silver			boolean,
	badge_gold			boolean,
	badge_diamond			boolean,
	badge_distance			text (50),
	official_observer		boolean,
	notes				varchar (255),
	diamond_goal			boolean,
	diamond_distance		boolean,
	diamond_height			boolean,
	gold_duration			boolean,
	gold_distance			boolean,
	gold_height			boolean,
	silver_duration			boolean,
	silver_distance			boolean,
	silver_height			boolean,
	PRIMARY KEY (member_id),
	INDEX (first_name(10)),
	INDEX (surname(10))
);

DROP TABLE IF EXISTS gliders;
CREATE TABLE gliders (
	registration			text NOT NULL,
	model				text,
	seats				integer(1) default NULL,
	year_of_manufacture		date default NULL,
	club_aircraft			boolean,
	form_2_date			date default NULL,
	form_2_minutes			integer default NULL,
	form_2_landings			integer default NULL,
	PRIMARY KEY (registration(3))
);

DROP TABLE IF EXISTS tugs;
CREATE TABLE tugs (
	registration			text NOT NULL,
	model				text,
	seats				integer(1) default NULL,
	rate				decimal(10,2),
	last_service_date		date default NULL,
	last_service_minutes		integer default NULL,
	last_service_landings		integer default NULL,
	PRIMARY KEY (registration(3))
);
