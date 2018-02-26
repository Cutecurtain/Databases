
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
		IF(OLD.course IN (SELECT code from LimitedCourse)) THEN
			IF(OLD.status = 'registered') THEN 
				IF((SELECT COUNT(status) FROM Registrations WHERE status = 'registered' AND course = OLD.course) <= (SELECT seats FROM LimitedCourse WHERE code = OLD.course)) THEN
					INSERT INTO Registered (student, course) SELECT student, course FROM WaitingList where position = 1 AND course = OLD.course; 
					DELETE FROM WaitingList where position = 1 AND course = OLD.course;
					UPDATE WaitingList
					SET position = position - 1
					WHERE course = OLD.course;
				END IF;
				DELETE FROM Registered where student = OLD.student;
			ELSE
				DECLARE
					oldPos INT := (SELECT position FROM WaitingList WHERE student = OLD.student AND course = OLD.course);
				BEGIN
					DELETE FROM WaitingList where student = OLD.student AND course = OLD.course;
					UPDATE WaitingList
					SET position = position - 1
					WHERE course = OLD.course AND position > oldPos;
				END;
			END IF;
		ELSE
			DELETE FROM Registered where student = OLD.student;
		END IF;
		RETURN NULL;
	END;
$proccess_unregister$ LANGUAGE plpgsql;

CREATE TRIGGER Unregister
	INSTEAD OF DELETE ON Registrations
		FOR EACH ROW EXECUTE PROCEDURE proccess_unregister();
