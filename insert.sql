INSERT INTO Program VALUES('Informationsteknik', 'TKITE');
INSERT INTO Program VALUES('Datateknik', 'TKDE');
INSERT INTO Program VALUES('ALLA ANDRA', 'NOOB');

INSERT INTO Department VALUES('Data IT & Elektro', 'EDIT');
INSERT INTO Department VALUES('ALLA ANDRA', 'NOOB');

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
INSERT INTO BelongsTo VALUES('2', NULL, 'Informationsteknik');
INSERT INTO BelongsTo VALUES('3', NULL, 'Datateknik');
INSERT INTO BelongsTo VALUES('4', 'Briber', 'Datateknik');
INSERT INTO BelongsTo VALUES('5', NULL, 'ALLA ANDRA');
INSERT INTO BelongsTo VALUES('6', 'ULTRA', 'ALLA ANDRA');

INSERT INTO Course VALUES('ABC123', 'Bebis', 7.5, 'Data IT & Elektro');
INSERT INTO Course VALUES('DEF456', 'Gamling', 7.5, 'Data IT & Elektro');
INSERT INTO Course VALUES('asdfgh', 'Frukt', 7.5, 'ALLA ANDRA');
INSERT INTO Course VALUES('zxcvbn', 'Grönsak', 7.5, 'ALLA ANDRA');

INSERT INTO Classification VALUES('math');
INSERT INTO Classification VALUES('research');
INSERT INTO Classification VALUES('seminar');

INSERT INTO Classified VALUES('ABC123', 'math');
INSERT INTO Classified VALUES('DEF456', 'math');
INSERT INTO Classified VALUES('asdfgh', 'research');
INSERT INTO Classified VALUES('zxcvbn', 'seminar');

INSERT INTO MandatoryProgram VALUES('ABC123', 'Informationsteknik');
INSERT INTO MandatoryProgram VALUES('DEF456', 'Datateknik');
INSERT INTO MandatoryProgram VALUES('asdfgh', 'ALLA ANDRA');

INSERT INTO MandatoryBranch VALUES('DEF456', 'Cyber', 'Informationsteknik');
INSERT INTO MandatoryBranch VALUES('zxcvbn', 'ULTRA', 'ALLA ANDRA');

INSERT INTO Registered VALUES('1', 'DEF456');
INSERT INTO Registered VALUES('2', 'DEF456');
INSERT INTO Registered VALUES('3', 'asdfgh');
INSERT INTO Registered VALUES('4', 'zxcvbn');
INSERT INTO Registered VALUES('5', 'ABC123');
INSERT INTO Registered VALUES('6', 'ABC123');

INSERT INTO Taken VALUES('1', 'ABC123', 'U');


