
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
	login			TEXT		NOT NULL UNIQUE,
	program			TEXT		NOT NULL REFERENCES Program(name),
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
CREATE TABLE BelongsTo (
	student			TEXT			REFERENCES Student(ssn),
	branch			TEXT			NOT NULL,
	program			TEXT			NOT NULL,
	FOREIGN KEY(student, program)	REFERENCES Student(ssn, program),
	FOREIGN KEY(branch, program)	REFERENCES Branch(name, program),
	PRIMARY KEY(student)
);

--Course(_code_, name, credits, department)
--	department -> Department.name
CREATE TABLE Course (
	code			CHAR(6)		PRIMARY KEY,
	name			TEXT		NOT NULL,
	credits			FLOAT		NOT NULL,
	department		TEXT		NOT NULL REFERENCES Department(name),
	CHECK(credits > 0)
);

--Prerequisite(_course_, _prerequisite_)
--	course -> Course.code
--	prerequisite -> Course.code
CREATE TABLE Prerequisite (
	course			CHAR(6)		REFERENCES Course(code),
	prerequisite	CHAR(6)		REFERENCES Course(code),
	PRIMARY KEY(course, prerequisite),
	CHECK(course != prerequisite)
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
	classification	TEXT		NOT NULL REFERENCES Classification(name),
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
	PRIMARY KEY(student, course),
	CHECK(grade = 'U' OR (grade >= '3' AND grade <= '5'))
);

--LimitedCourse(_code_, seats)
--	code -> Course.code
CREATE TABLE LimitedCourse (
	code			CHAR(6)		REFERENCES Course(code),
	seats			INT			NOT NULL,
	PRIMARY KEY(code),
	CHECK(seats > 0)
);

--WaitingList(_student_, _course_, position)
--	student -> Student.ssn
--	course -> LimitedCourse.code
--	UNIQUE (position, course)
CREATE TABLE WaitingList (
	student			TEXT		REFERENCES Student(ssn),
	course			CHAR(6)		REFERENCES LimitedCourse(code),
	position		INT			NOT NULL,
	PRIMARY KEY(student, course),
	UNIQUE(position, course),
	CHECK(position > 0)
);

------------------ INSERTS
INSERT INTO Program VALUES('Informationsteknik', 'TKITE');
INSERT INTO Program VALUES('Datateknik', 'TKDE');
INSERT INTO Program VALUES('ALLA ANDRA', 'NOOB');

INSERT INTO Department VALUES('Data IT & Elektro', 'EDIT');
INSERT INTO Department VALUES('ALLA ANDRA', 'NOOB');

INSERT INTO Hosts VALUES('Data IT & Elektro', 'Informationsteknik');
INSERT INTO Hosts VALUES('Data IT & Elektro', 'Datateknik');
INSERT INTO Hosts VALUES('ALLA ANDRA', 'ALLA ANDRA');

INSERT INTO Student VALUES('1', 'a', '1a', 'Informationsteknik');
INSERT INTO Student VALUES('2', 'b', '2b', 'Informationsteknik');
INSERT INTO Student VALUES('3', 'c', '3c', 'Datateknik');
INSERT INTO Student VALUES('4', 'd', '4d', 'Datateknik');
INSERT INTO Student VALUES('5', 'e', '5e', 'ALLA ANDRA');
INSERT INTO Student VALUES('6', 'f', '6f', 'ALLA ANDRA');

INSERT INTO Branch VALUES('Cyber', 'Informationsteknik');
INSERT INTO Branch VALUES('Briber', 'Datateknik');
INSERT INTO Branch VALUES('ULTRA', 'ALLA ANDRA');

INSERT INTO BelongsTo VALUES('1', 'Cyber', 'Informationsteknik');
INSERT INTO BelongsTo VALUES('3', 'Briber', 'Datateknik');
INSERT INTO BelongsTo VALUES('5', 'ULTRA', 'ALLA ANDRA');
INSERT INTO BelongsTo VALUES('6', 'ULTRA', 'ALLA ANDRA');

INSERT INTO Course VALUES('ABC123', 'Databases', 10, 'Data IT & Elektro');
INSERT INTO Course VALUES('DEF456', 'Gamling', 10, 'Data IT & Elektro');
INSERT INTO Course VALUES('asdfgh', 'Frukt', 10, 'ALLA ANDRA');
INSERT INTO Course VALUES('hejhej', 'Sallad', 10, 'ALLA ANDRA');
INSERT INTO Course VALUES('hojhoj', 'Hide and seek', 10, 'ALLA ANDRA');
INSERT INTO Course VALUES('hajhaj', 'Computergames', 10, 'ALLA ANDRA');
INSERT INTO Course VALUES('muumuu', 'Fasting', 10, 'ALLA ANDRA');
INSERT INTO Course VALUES('miimii', 'Grönsak', 10, 'ALLA ANDRA');

INSERT INTO Classification VALUES('math');
INSERT INTO Classification VALUES('research');
INSERT INTO Classification VALUES('seminar');

INSERT INTO Classified VALUES('ABC123', 'math');
INSERT INTO Classified VALUES('DEF456', 'math');
INSERT INTO Classified VALUES('asdfgh', 'research');
INSERT INTO Classified VALUES('miimii', 'seminar');

INSERT INTO MandatoryProgram VALUES('ABC123', 'Informationsteknik');
INSERT INTO MandatoryProgram VALUES('DEF456', 'Datateknik');
INSERT INTO MandatoryProgram VALUES('asdfgh', 'ALLA ANDRA');

INSERT INTO MandatoryBranch VALUES('DEF456', 'Cyber', 'Informationsteknik');
INSERT INTO MandatoryBranch VALUES('miimii', 'ULTRA', 'ALLA ANDRA');
INSERT INTO MandatoryBranch VALUES('muumuu', 'Briber', 'Datateknik');

INSERT INTO RecommendedBranch VALUES('hejhej', 'Cyber', 'Informationsteknik');
INSERT INTO RecommendedBranch VALUES('hojhoj', 'ULTRA', 'ALLA ANDRA');
INSERT INTO RecommendedBranch VALUES('hajhaj', 'Briber', 'Datateknik');

INSERT INTO Registered VALUES('1', 'DEF456');
INSERT INTO Registered VALUES('2', 'DEF456');
INSERT INTO Registered VALUES('3', 'asdfgh');
INSERT INTO Registered VALUES('4', 'miimii');
INSERT INTO Registered VALUES('5', 'ABC123');
INSERT INTO Registered VALUES('3', 'hajhaj');
INSERT INTO Registered VALUES('2', 'hajhaj');
INSERT INTO Registered VALUES('1', 'hajhaj');
INSERT INTO Registered VALUES('3', 'hojhoj');
INSERT INTO Registered VALUES('2', 'hojhoj');
INSERT INTO Registered VALUES('1', 'hojhoj');

INSERT INTO Taken VALUES('1', 'ABC123', 'U');
INSERT INTO Taken VALUES('2', 'ABC123', '3');
INSERT INTO Taken VALUES('3', 'ABC123', '4');
INSERT INTO Taken VALUES('4', 'ABC123', '5');

INSERT INTO Taken VALUES('2', 'DEF456', '3');
INSERT INTO Taken VALUES('2', 'asdfgh', '4');
INSERT INTO Taken VALUES('2', 'miimii', '5');

INSERT INTO Taken VALUES('6', 'asdfgh', '3');
INSERT INTO Taken VALUES('6', 'hojhoj', '3');
INSERT INTO Taken VALUES('6', 'ABC123', '3');
INSERT INTO Taken VALUES('6', 'DEF456', '3');
INSERT INTO Taken VALUES('6', 'muumuu', '3');
INSERT INTO Taken VALUES('6', 'miimii', '3');

INSERT INTO Prerequisite VALUES('miimii', 'muumuu');

INSERT INTO LimitedCourse VALUES('hojhoj', 4);
INSERT INTO LimitedCourse VALUES('hajhaj', 3);

INSERT INTO WaitingList VALUES('1', 'hojhoj', 1);
INSERT INTO WaitingList VALUES('4', 'hajhaj', 1);
INSERT INTO WaitingList VALUES('5', 'hajhaj', 2);



-----------------VIEWS

--StudentsFollowing(student, program, branch) For all students, their SSN,
-- the program and the branch (if any) they are following. The branch 
--column is the only column in any of the views that is allowed to be NULLABLE.
CREATE VIEW StudentsFollowing AS 
	(SELECT student, program, branch
	FROM BelongsTo)
		UNION
	(SELECT ssn AS student, program, NULL AS branch 
	FROM Student
	WHERE ssn NOT IN(SELECT student FROM BelongsTo));

--View: FinishedCourses(student, course, grade, credits)
--For all students, all finished courses, along with their codes,
-- grades (grade 'U', '3', '4' or '5') and number of credits.
-- The type of the grade should be a character type, e.g. TEXT.
CREATE VIEW FinishedCourses AS
	SELECT student,course,grade,credits
	FROM Taken,Course
	WHERE course = code;

--View: Registrations(student, course, status) All registered and
--waiting students for all courses, along with their waiting status 
--('registered' or 'waiting').
CREATE VIEW Registrations AS
	(SELECT student,course,'waiting' AS status
	FROM WaitingList)
		UNION
	(SELECT student,course,'registered' AS status
	FROM Registered);


--View: PassedCourses(student, course, credits) For all students, all passed 
--courses, i.e. courses finished with a grade other than 'U', and the number 
--of credits for those courses. This view is intended as a helper view towards
-- the PathToGraduation view (and for task 4), and will not be directly used by
-- your application.
CREATE VIEW PassedCourses AS
	SELECT student,course,credits
	FROM Taken,Course
	WHERE grade != 'U' AND course = code;

--View: UnreadMandatory(student, course) For all students, the mandatory courses 
--(branch and programme) they have not yet passed. This view is intended as a 
--helper view towards the PathToGraduation view, and will not be directly used 
--by your application.
CREATE VIEW UnreadMandatory AS
	((SELECT s.ssn AS student, mp.course
	FROM Student s, MandatoryProgram mp
	WHERE s.program = mp.program)
		UNION
	(SELECT bt.student AS student, mb.course
	FROM BelongsTo bt, MandatoryBranch mb
	WHERE bt.branch = mb.branch))
		EXCEPT
	(SELECT student, course
	FROM PassedCourses);

--Returns the students who have mandatory courses left.
CREATE VIEW StudentsWithMandatory AS
	SELECT student, COUNT(course) AS mandatoryLeft
	FROM UnreadMandatory
	GROUP BY student;
	
--Returns the amount of mandatory courses left for each student.
CREATE VIEW MandatoryLeft AS
	(SELECT student, mandatoryLeft FROM StudentsWithMandatory)
		UNION
	(SELECT ssn AS student, 0 AS mandatoryLeft
	FROM Student
	WHERE ssn NOT IN(SELECT student FROM StudentsWithMandatory));

--Returns the students who have not passed any course.
CREATE VIEW NotPassedAny AS
	SELECT ssn AS student
	FROM Student
	WHERE ssn NOT IN(SELECT student FROM PassedCourses)
	GROUP BY student;

--Returns the total amount of credits for each student.
CREATE VIEW TotalCredits AS
	(SELECT student, SUM(credits) as credits
	FROM PassedCourses
	GROUP BY student)
		UNION
	(SELECT student, 0 AS credits
	FROM NotPassedAny);

--Returns the students who has math credits.
CREATE VIEW PassedMath AS
	SELECT student, SUM(credits) as credits
	FROM PassedCourses 
	WHERE course in (	SELECT course FROM Classified 
						WHERE classification = 'math')
	GROUP BY student;

--Returns the total math credits for each student.
CREATE VIEW MathCredits AS
	(SELECT student, credits FROM PassedMath)
		UNION
	(SELECT ssn AS student, 0 AS credits
	FROM Student
	WHERE ssn NOT IN(SELECT student FROM PassedMath));

---Returns the students who has research credits.
CREATE VIEW PassedResearch AS
	(SELECT student, SUM(credits) as credits
	FROM PassedCourses 
	WHERE course in (	SELECT course FROM Classified
						WHERE classification = 'research')
	GROUP BY student);

--Returns the total research credits for each student.
CREATE VIEW ResearchCredits AS
	(SELECT student, credits FROM PassedResearch)
		UNION
	(SELECT ssn AS student, 0 AS credits
	FROM Student
	WHERE ssn NOT IN(SELECT student FROM PassedResearch));

--Returns the students who has taken at least one seminar course.
CREATE VIEW PassedSeminar AS
	(SELECT student, count(course) AS courses
	FROM PassedCourses
	WHERE course in (	SELECT course FROM Classified
						WHERE classification = 'seminar')
	GROUP BY student);

--Returns the amount of seminar courses read for each student.
CREATE VIEW SeminarCoursesRead AS
	(SELECT student, courses FROM PassedSeminar)
		UNION
	(SELECT ssn as student, 0 as courses
	FROM Student
	WHERE ssn NOT IN(SELECT student FROM PassedSeminar));

--Returns the student who has recommended credits.
CREATE VIEW PassedRecommended AS
	SELECT pc.student, SUM(pc.credits) AS credits
	FROM BelongsTo bt, RecommendedBranch rb, PassedCourses pc
	WHERE bt.branch = rb.branch AND rb.course = pc.course AND bt.student = pc.student
	GROUP BY pc.student;
	
--Returns the total recommended credits for each student.
CREATE VIEW RecommendedCredits AS
	(SELECT student, credits FROM PassedRecommended)
		UNION
	(SELECT ssn AS student, 0 AS credits
	FROM Student
	WHERE ssn NOT IN(SELECT student FROM PassedRecommended));

--Return the status of being able to graduate for each student.
CREATE VIEW GraduationStatus AS
	(SELECT ml.student, TRUE AS status
	FROM StudentsFollowing sf, MandatoryLeft ml, TotalCredits tc, MathCredits mc, ResearchCredits rc, SeminarCoursesRead sc, RecommendedCredits recm
	WHERE ml.student = sf.student AND ml.student = tc.student AND ml.student = mc.student AND ml.student = rc.student AND ml.student = sc.student AND ml.student = recm.student
	AND sf.branch IS NOT NULL AND ml.mandatoryLeft = 0 AND tc.credits >= 0 AND mc.credits >= 20 AND rc.credits >= 10 AND sc.courses >= 1 AND recm.credits >= 10)
		UNION
	(SELECT ml.student, FALSE AS status
	FROM StudentsFollowing sf, MandatoryLeft ml, TotalCredits tc, MathCredits mc, ResearchCredits rc, SeminarCoursesRead sc, RecommendedCredits recm
	WHERE ml.student = sf.student AND ml.student = tc.student AND ml.student = mc.student AND ml.student = rc.student AND ml.student = sc.student AND ml.student = recm.student
	AND (sf.branch IS NULL OR ml.mandatoryLeft > 0 OR tc.credits < 0 OR mc.credits < 20 OR rc.credits < 10 OR sc.courses < 1 OR recm.credits < 10));
	

--View: PathToGraduation(student, totalCredits, mandatoryLeft, mathCredits, researchCredits, seminarCourses, status) 
--For all students, their path to graduation, i.e. a view with columns for 
-- - ssn: the student's SSN. - totalCredits: the number of credits they have taken. 
-- - mandatoryLeft: the number of courses that are mandatory for a branch or a program they have yet to read. 
-- - mathCredits: the number of credits they have taken in courses that are classified as math courses. 
-- - researchCredits: the number of credits they have taken in courses that are classified as research courses. 
-- - seminarsCourses: the number of seminar courses they have read. 
-- - status: whether or not they qualify for graduation. The SQL type of this field should be BOOLEAN (i.e. TRUE or FALSE).
CREATE VIEW PathToGraduation AS
	SELECT ml.student, tc.credits AS totalCredits, ml.mandatoryLeft, mc.credits AS mathCredits, rc.credits AS researchCredits, sc.courses as seminarCourses, gs.status
	FROM MandatoryLeft ml, TotalCredits tc, MathCredits mc, ResearchCredits rc, SeminarCoursesRead sc, GraduationStatus gs
	WHERE ml.student = tc.student AND ml.student = mc.student AND ml.student = rc.student AND ml.student = sc.student AND ml.student = gs.student;

--View: CourseQueuePositions(course,student,place)
CREATE VIEW CourseQueuePositions AS
	SELECT course, student, position AS place
	FROM WaitingList
	GROUP BY course, student
	ORDER BY place;
