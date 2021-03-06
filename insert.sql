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
INSERT INTO Taken VALUES('4', 'muumuu', '3');

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

INSERT INTO LimitedCourse VALUES('hojhoj', 3);
INSERT INTO LimitedCourse VALUES('hajhaj', 3);

INSERT INTO WaitingList VALUES('1', 'hojhoj', 1);
INSERT INTO WaitingList VALUES('4', 'hajhaj', 1);
INSERT INTO WaitingList VALUES('5', 'hajhaj', 2);