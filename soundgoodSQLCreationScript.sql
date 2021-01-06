CREATE TABLE "school"
(
    "school_id" serial PRIMARY KEY,
    "number_of_vacancies" varchar (5) NOT NULL,
    "address" varchar(500) NOT NULL,
    "phone_number" varchar(20) NOT NULL,
    "email" varchar (200) NOT NULL
);


CREATE TABLE "person"
(
  "person_id" serial PRIMARY KEY,
  "person_number" varchar(12) UNIQUE NOT NULL,
  "first_name" varchar(500) NOT NULL,
  "last_name" varchar(500) NOT NULL,
  "address" varchar(500) NOT NULL,
  "school_id" int NOT NULL REFERENCES "school",
  "family" int
);

CREATE TABLE "instructor"
(
  "instructor_id" serial PRIMARY KEY,
  "person_id" int NOT NULL REFERENCES "person",
  "employment_id" varchar(10) UNIQUE NOT NULL
);

CREATE TABLE "instructor_payment"
(
    "instructor_payment_id" serial PRIMARY KEY,
    "special_day_pay" BOOLEAN,
    "amount" int NOT NULL,
    "instructor_id" int NOT NULL REFERENCES "instructor",
    "date" DATE NOT NULL
);

CREATE TABLE "scheduled_time_slot"
(
    "scheduled_time_slot_id" serial PRIMARY KEY,
    "start_time" timestamp NOT NULL,
    "end time" timestamp NOT NULL,
    "instructor_id" int NOT NULL REFERENCES "instructor"
);

CREATE TABLE "ensemble"
(
    "ensemble_id" serial PRIMARY KEY,
    "number_of_students" varchar(4) NOT NULL,
    "max_number_of_students" varchar(4) NOT NULL,
    "min_number_of_students" varchar(4) NOT NULL,
	"skill_level" TEXT CHECK (skill_level IN ('beginner', 'intermediate', 'advanced')),
    "scheduled_time_slot_id" int NOT NULL REFERENCES "scheduled_time_slot",
    "genre" TEXT CHECK (genre IN ('classical', 'pop', 'rock', 'jazz', 'gospel','hiphop')),
    "instructor_payment_id" int NOT NULL REFERENCES "instructor_payment"
);

CREATE TABLE "student"
(
  "student_id" serial PRIMARY KEY,
  "person_id" int NOT NULL REFERENCES "person",
  "age" varchar(3) NOT NULL,
  "ensemble_id" int REFERENCES "ensemble",
"skill_level" TEXT CHECK (skill_level IN ('beginner', 'intermediate', 'advanced'))
);

CREATE TABLE "student_payment"
(
    "student_payment_id" serial PRIMARY KEY,
   "amount" int NOT NULL,
   "student_id" int NOT NULL REFERENCES "student",
   "date" date NOT NULL
);

CREATE TABLE "parent"
(
  "parent_id" serial PRIMARY KEY,
  "person_id" int NOT NULL REFERENCES "person"
);


CREATE TABLE "single_lesson"
(
    "lesson_id" serial PRIMARY KEY,
    "student_payment_id" int NOT NULL REFERENCES "student_payment",
    "instructor_payment_id" int NOT NULL REFERENCES "instructor_payment",
    "student_id" int NOT NULL REFERENCES "student",
    "scheduled_time_slot_id" int NOT NULL REFERENCES "scheduled_time_slot"
);



CREATE TABLE "application"
(
    "student_application_id" serial PRIMARY KEY,
    "skill_level" TEXT CHECK (skill_level IN ('beginner', 'intermediate', 'advanced')),
    "offered_place" BOOLEAN NOT NULL,
    "accepted_place" BOOLEAN NOT NULL,
    "wishes_contact" BOOLEAN NOT NULL,
    "person_id" int NOT NULL REFERENCES "person",
    "role" TEXT CHECK (role IN ('student', 'instructor', 'other'))
);


CREATE TABLE "instrument_played"
(
    "student_id" int NOT NULL REFERENCES "student" ON DELETE CASCADE,
    "instrument_type" TEXT CHECK (instrument_type IN ('piano', 'violin', 'cello', 'guitar', 'flute', 'french horn', 'oboe', 'trumpet', 'saxophone', 'drums')),
    PRIMARY KEY("student_id", "instrument_type")
);

CREATE TABLE "instrument_taught"
(
    "instructor_id" int NOT NULL REFERENCES "instructor" ON DELETE CASCADE,
    "instrument_type" TEXT CHECK (instrument_type IN ('piano', 'violin', 'cello', 'guitar', 'flute', 'french horn', 'oboe', 'trumpet', 'saxophone', 'drums')),
    PRIMARY KEY("instructor_id", "instrument_type")
);

CREATE TABLE "instrument_rental"
(
    "instrument_rental_id" serial PRIMARY KEY,
        "rental_start_date" date NOT NULL,
        "rental_end_date" date NOT NULL,
        "student_id" int NOT NULL REFERENCES "student"
);

CREATE TABLE "schools_instrument"
(
        "schools_instrument_id" serial PRIMARY KEY,
        "instrument_type" TEXT CHECK (instrument_type IN ('piano', 'violin', 'cello', 'guitar', 'flute', 'french horn', 'oboe', 'trumpet', 'saxophone', 'drums')),
        "brand" TEXT CHECK (brand IN ('Yamaha', 'Gibson', 'Fender', 'Roland', 'Steinway')),
        "instrument_rental_id" int REFERENCES "instrument_rental",
        "rental_fee_per_month" int NOT NULL
);

CREATE TABLE "group_lesson"
(
    "group_lesson_id" serial PRIMARY KEY,
    "skill_level" TEXT CHECK (skill_level IN ('beginner', 'intermediate', 'advanced')),
    "minimum_number_of_students" varchar (3) NOT NULL,
    "maximum_number_of_students" varchar(3) NOT NULL,
    "scheduled_time_slot_id" int NOT NULL REFERENCES "scheduled_time_slot",
    "instructor_payment_id" int NOT NULL REFERENCES "instructor_payment",
    "instrument_type" TEXT CHECK (instrument_type IN ('piano', 'violin', 'cello', 'guitar', 'flute', 'french horn', 'oboe', 'trumpet', 'saxophone', 'drums'))
);

CREATE TABLE "group_lesson_student"
(
    "group_lesson_id" int NOT NULL REFERENCES "group_lesson",
    "student_id" int NOT NULL REFERENCES "student",
    "student_payment_id" int NOT NULL REFERENCES "student_payment",
    PRIMARY KEY("group_lesson_id", "student_id")
    
);

CREATE TABLE "ensemble_student"
(
    "ensemble_id" int NOT NULL REFERENCES "ensemble",
    "student_id" int NOT NULL REFERENCES "student",
    "student_payment_id" int NOT NULL REFERENCES "student_payment",
    PRIMARY KEY("ensemble_id", "student_id")
);

CREATE TABLE "phone_number"
(
    "phone_number" char(10) NOT NULL,
    "person_id" int NOT NULL REFERENCES "person" ON DELETE CASCADE,
    PRIMARY KEY("phone_number", "person_id")
);

CREATE TABLE "email"
(
    "email" varchar(200) NOT NULL,
    "person_id" int NOT NULL REFERENCES "person" ON DELETE CASCADE,
    PRIMARY KEY("email", "person_id")
);

CREATE TABLE "audition"
(
    "application_id" int NOT NULL REFERENCES "application" PRIMARY KEY,
    "passed" BOOLEAN NOT NULL,
    "scheduled_time_slot_id" int NOT NULL REFERENCES "scheduled_time_slot"
);

CREATE TABLE "rental_payment"
(
    "instrument_rental_id" int NOT NULL REFERENCES "instrument_rental",
    "student_payment_id" int NOT NULL REFERENCES "student_payment",
    PRIMARY KEY("instrument_rental_id", "student_payment_id")
);

CREATE TABLE "pricing_scheme"
(
    "school_id" int REFERENCES "school" PRIMARY KEY,
    "single_beginner_price" int NOT NULL,
    "intermediate_beginner_price" int NOT NULL,
    "advanced_beginer_price" int NOT NULL,
    "group_beginner_price" int NOT NULL,
    "group_intermediate_price" int NOT NULL,
    "group_advanced_price" int NOT NULL,
    "ensemble_beginner_price" int NOT NULL,
    "ensemble_intermediate_price" int NOT NULL,
    "ensemble_advanced_price" int NOT NULL,
    "sibling_discount_multiplier" float NOT NULL,
    "special_day_multiplier" float NOT NULL
);
