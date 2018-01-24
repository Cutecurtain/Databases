--StudentsFollowing(student, program, branch) For all students, their SSN,
-- the program and the branch (if any) they are following. The branch 
--column is the only column in any of the views that is allowed to be NULLABLE.
CREATE VIEW StudentsFollowing AS 
	SELECT ssn AS student,program,branch 
	FROM BelongsTo;

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
	SELECT student,course
	FROM 