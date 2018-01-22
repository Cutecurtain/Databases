
--Program(_name_, abbreviation)
CREATE TABLE Program (
	name			TEXT		PRIMARY KEY,
	abbreviation	TEXT		NOT NULL
);

--Department(_name_, abbreviation)
CREATE TABLE Department (
	name			TEXT		PRIMARY KEY,
	abbreviation	TEXT		NOT NULL
);

--Hosts(_department_, _program_)
CREATE TABLE Hosts (
	department		Department,
	program			Program,
	PRIMARY KEY(department, program)
);

--Student(_ssn_, name, login, program)
CREATE TABLE Student (
	ssn				TEXT		PRIMARY KEY,
	name			TEXT		NOT NULL,
	login			TEXT		NOT NULL,
	program			Program		NOT NULL
);

--Branch(_name_, _program_)
CREATE TABLE Branch (
	name			TEXT,
	program			Program,
	PRIMARY KEY(name, program)
);

--BelongsTo(_student_, branch, program)
CREATE TABLE BelongsTo (
	student			Student		PRIMARY KEY,
	branch			Branch		NOT NULL,
	program			Program		NOT NULL
);

--Course(_code_, name, credits, department)
CREATE TABLE Course (
	code			CHAR(6)		PRIMARY KEY,
	name			TEXT		NOT NULL,
	credits			TEXT		NOT NULL,
	department		Department	NOT NULL
);

--Prerequisite(_course_, _prerequisite_)
CREATE TABLE Prerequisite (
	course			Course,
	prerequisite	Prerequisite,
	PRIMARY KEY(course, prerequisite)
);

--Classification(_name_)
CREATE TABLE Classification (
	name			TEXT	PRIMARY KEY
);


--Classified(_course_, _classification_)
CREATE TABLE Classified (
	course			Course,
	classification	Classification,
	PRIMARY KEY(course, classification)
);

--MandatoryProgram(_course_, _program_)
CREATE TABLE MandatoryProgram (
	course			Course,
	program			Program,
	PRIMARY KEY(course, program)
);

--MandatoryBranch(_course_, _branch_, _program_)
CREATE TABLE MandatoryBranch (
	course			Course,
	branch			Branch,
	program			Program,
	PRIMARY KEY(course, branch, program)
);

--RecommendedBranch(_course_, _branch_, _program_)
CREATE TABLE RecommendedBranch (
	course			Course,
	branch			Branch,
	program			Program,
	PRIMARY KEY(course, branch, program)
);

--Registered(_student_, _course_)
CREATE TABLE Registered (
	student			Student,
	course			Course,
	PRIMARY KEY(student, course)
);

--Taken(_student_, _course_, grade)
CREATE TABLE Taken (
	student			Student,
	course			Course,
	grade			INT			NOT NULL,
	PRIMARY KEY(student, course)
);

--LimitedCourse(_code_, seats)
CREATE TABLE LimitedCourse (
	code			CHAR(6)		PRIMARY KEY,
	seats			INT			NOT NULL
);

--WaitingList(_student_, _course_, position)
CREATE TABLE WaitingList (
	student			Student,
	course			Course,
	position		TEXT		NOT NULL,
	PRIMARY KEY(student, course)
);
