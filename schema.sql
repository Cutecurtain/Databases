Domain(
	 	departmentName,
	 	departmentAbr,
	 	programName,
	 	programAbr,
	 	branchName,
		mandatoryBranch,
		mandatoryProgram,
		recommendedBranch,
	 	_ssn_,
	 	studentName,
	 	login,
	 	_code_,
	 	coursename,
	 	credits,
	 	seats,
        prerequisite,
	 	position,
	 	grade,
 		_classificationName_
 )

potential keys: (ssn, code, classificationName), (login, code, classificationName)
Both ssn and login is unique values of a student.
A student can have only one relation to a course.
code is the only unique value of the course.
a course can have zero or more classifications.
Thus the only keys are a tuple of code, classificationName and ssn or login.
BCNF violations: every dependency above except the keys

Functional dependencies:
departmentName -> departmentAbr
departmentAbr -> departmentName
programName -> programAbr
programName -> departmentName
programName -> mandatoryProgram
(branchName,programName) -> mandatoryBranch
(branchName,programName) -> recommendedBranch
ssn -> studentName 
ssn -> login 
ssn -> programName 
ssn -> branchName
login -> studentName 
login -> ssn
login -> programName 
login -> branchName
code -> coursename
code -> credits
code -> seats
code -> prerequisite
code -> classificationName
code -> departmentName
(code,ssn) -> position
(code,ssn) -> grade
(code,login) -> position
(code,login) -> grade


============================================================================
FD SCHEMA
Decomposed domain:
Departments(_name_,abr)
unique(abr)

Programs(_name_,abr)

Hosts(_program_, _department_)
references: program -> Programs.name
references: department -> Departments.name

Branch(_name_, _program_)
references: program -> Programs.name

Student(_ssn_,login,name,program)
references: program -> Programs.name
unique(login)
unique(ssn,program)

BelongsTo(_student_,_branch_,_program_)
references: (student,program) -> Student(ssn,program)
references: (branch,program) -> Branch(name,program)

Course(_code_,name,credits)

limitedCourse(_code_, seats)
references: code -> Course.code

waitingLine(_student_,_course_,position)
references: student -> Student.ssn
references: course -> Course.code

taken(student,course,grade)
references: student -> Student.ssn
references: course -> Course.code

classifications(classificationName)

courseClassification(classificationName, course)
references: classificationName -> classifications.classificationName
references: course -> Course.code

prerequisite(course, requiredCourse)
references: course -> Course.code
references: requiredCourse -> Course.code

mandatoryBranch(_branch_, _program_, _course_)
references: (branch,program) -> Branch(name,program)
references: course -> Course.code

mandatoryProgram(_program_,_course_)
references: program -> Programs.name
references: course -> Course.code

recommendedBranch(_branch_, _program_, _course_)
references: (branch,program) -> Branch(name,program)
references: course -> Course.code



=================================================================
Design report:
