
CREATE OR REPLACE FUNCTION proccess_register() RETURNS TRIGGER AS $proccess_register$
	BEGIN
		IF ((SELECT student FROM FinishedCourses WHERE student = NEW.student AND course = NEW.course) = NEW.student) THEN
			RAISE EXCEPTION 'Student % has already taken the course %!', NEW.student, NEW.course;
		ELSEIF ((SELECT student FROM Registrations WHERE student = NEW.student AND course = NEW.course) = NEW.student) THEN
			RAISE EXCEPTION 'Student % is already % for the course %!', NEW.student, (SELECT status FROM Registrations WHERE student = NEW.student AND course = NEW.course), NEW.course;
		ELSEIF ((SELECT COUNT(prerequisite) FROM Prerequisite WHERE course = NEW.course) > 0 AND (SELECT prerequisite FROM Prerequisite WHERE course = NEW.course) NOT IN (SELECT course FROM FinishedCourses WHERE student = NEW.student)) THEN
			RAISE EXCEPTION 'Student % does not have the required prerequisite(s) for the course %', NEW.student, NEW.course;
		ELSE
			IF ((SELECT code FROM LimitedCourse WHERE code = NEW.course) = NEW.course AND (SELECT COUNT(*) FROM Registered WHERE course = NEW.course) >= (SELECT seats FROM LimitedCourse WHERE code = NEW.course)) THEN
					INSERT INTO WaitingList VALUES(NEW.student, NEW.course, (SELECT COUNT(*) FROM WaitingList WHERE course = NEW.course) + 1);
			ELSE
				INSERT INTO Registered VALUES(NEW.student, NEW.course);
			END IF;
			RETURN NEW;
		END IF;
		RETURN NULL;
	END;
$proccess_register$ LANGUAGE plpgsql;

CREATE TRIGGER Register
	INSTEAD OF INSERT ON Registrations
		FOR EACH ROW EXECUTE PROCEDURE proccess_register();



CREATE OR REPLACE FUNCTION proccess_unregister() RETURNS TRIGGER AS $proccess_unregister$
	BEGIN
		
	END;
$proccess_unregister$ LANGUAGE plpgsql;

CREATE TRIGGER Unregister
	INSTEAD OF DELETE ON Registrations
		FOR EACH ROW EXECUTE PROCEDURE proccess_unregister();
