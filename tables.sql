
--Program(_name_, abbreviation)
CREATE TABLE Program (
	name			TEXT		PRIMARY KEY,
	abbreviation	TEXT		NOT NULL
);

--Department(_name_, abbreviation)
--	UNIQUE abbreviation
CREATE TABLE Department (
	name			TEXT		PRIMARY KEY,
	abbreviation	TEXT		UNIQUE		NOT NULL
);

--Hosts(_department_, _program_)
--	department -> Department.name
--	program -> Program.name
CREATE TABLE Hosts (
	department		TEXT		REFERENCES Department(name),
	program			TEXT		REFERENCES Program(name),
	PRIMARY KEY(department, program)
);

--Student(_ssn_, name, login, program)
--	program -> Program.name
--	UNIQUE login
--	UNIQUE (ssn, program)
CREATE TABLE Student (
	ssn				TEXT		PRIMARY KEY,
	name			TEXT		NOT NULL,
	login			TEXT		UNIQUE		NOT NULL,
	program			TEXT		REFERENCES Program(name),
	UNIQUE(ssn, program)
);

--Branch(_name_, _program_)
--	program -> Program.name
CREATE TABLE Branch (
	name			TEXT,
	program			TEXT		REFERENCES Program(name),
	PRIMARY KEY(name, program)
);

--BelongsTo(_student_, branch, program)
--	student -> Student.ssn
--	(student, program) -> Student.(ssn, program)
--	(branch, program) -> Branch.(name, program)
CREATE TABLE BelongsTo (-------------------------------------------------
	student			TEXT			PRIMARY KEY,
	branch			TEXT,
	program			TEXT			NOT NULL,
	FOREIGN KEY(student)			REFERENCES Student(ssn),
	FOREIGN KEY(branch, program)	REFERENCES Branch(name, program)
);

--Course(_code_, name, credits, department)
--	department -> Department.name
CREATE TABLE Course (
	code			CHAR(6)		PRIMARY KEY,
	name			TEXT		NOT NULL,
	credits			TEXT		NOT NULL,
	department		TEXT		REFERENCES Department(name)
);

--Prerequisite(_course_, _prerequisite_)
--	course -> Course.code
--	prerequisite -> Course.code
CREATE TABLE Prerequisite (
	course			CHAR(6)		REFERENCES Course(code),
	prerequisite	CHAR(6)		REFERENCES Course(code),
	PRIMARY KEY(course, prerequisite)
);

--Classification(_name_)
CREATE TABLE Classification (
	name			TEXT	PRIMARY KEY
);


--Classified(_course_, _classification_)
--	course -> Course.code
--	classification -> Classification.name
CREATE TABLE Classified (
	course			CHAR(6)		REFERENCES Course(code),
	classification	TEXT		REFERENCES Classification(name),
	PRIMARY KEY(course, classification)
);

--MandatoryProgram(_course_, _program_)
--	course -> Course.code
--	program -> Program.name
CREATE TABLE MandatoryProgram (
	course			CHAR(6)		REFERENCES Course(code),
	program			TEXT		REFERENCES Program(name),
	PRIMARY KEY(course, program)
);

--MandatoryBranch(_course_, _branch_, _program_)
--	course -> Course.code
--	(branch, program) -> Branch.(name, program)
CREATE TABLE MandatoryBranch (
	course			CHAR(6)		REFERENCES Course(code),
	branch			TEXT,
	program			TEXT,
	PRIMARY KEY(course, branch, program),
	FOREIGN KEY(branch, program) REFERENCES Branch(name, program)
);

--RecommendedBranch(_course_, _branch_, _program_)
--	course -> Course.code
--	(branch, program) -> Branch.(name, program)
CREATE TABLE RecommendedBranch (
	course			CHAR(6)		REFERENCES Course(code),
	branch			TEXT,
	program			TEXT,
	PRIMARY KEY(course, branch, program),
	FOREIGN KEY(branch, program) REFERENCES Branch(name, program)
);

--Registered(_student_, _course_)
--	student -> Student.ssn
--	course -> Course.code
CREATE TABLE Registered (
	student			TEXT		REFERENCES Student(ssn),
	course			CHAR(6)		REFERENCES Course(code),
	PRIMARY KEY(student, course)
);

--Taken(_student_, _course_, grade)
--	student -> Student.ssn
--	course -> Course.code
CREATE TABLE Taken (
	student			TEXT		REFERENCES Student(ssn),
	course			CHAR(6)		REFERENCES Course(code),
	grade			CHAR(1)		NOT NULL,
	PRIMARY KEY(student, course)
);

--LimitedCourse(_code_, seats)
--	code -> Course.code
CREATE TABLE LimitedCourse (
	code			CHAR(6)		REFERENCES Course(code),
	seats			INT			NOT NULL,
	PRIMARY KEY(code)
);

--WaitingList(_student_, _course_, position)
--	student -> Student.ssn
--	course -> LimitedCourse.code
--	UNIQUE (position, course)
CREATE TABLE WaitingList (
	student			TEXT		REFERENCES Student(ssn),
	course			CHAR(6)		REFERENCES LimitedCourse(code),
	position		TEXT		NOT NULL,
	PRIMARY KEY(student, course),
	UNIQUE(position, course)
);
