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
