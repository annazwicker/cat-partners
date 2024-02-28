-- CREATE TABLE todos (
--     userid INT NOT NULL PRIMARY KEY AUTOINCREMENT,
--     title TEXT,
--     body TEXT,
--     category INT REFERENCES categories (id)
-- );

CREATE TABLE users (
    userID INT NOT NULL PRIMARY KEY AUTOINCREMENT,
    iAdmin BIT NOT NULL DEFAULT 0,  
    isOptInEmails BIT NOT NULL DEFAULT 0, 
    forwardEmailDays INT NOT NULL DEFAULT 0,
    affID INT NOT NULL,
    CONSTRAINT CHK_forwardEmailDays CHECK (forwardEmailDays >= 0)
) AS User;

CREATE TABLE stations (
    stationID INT NOT NULL PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL,
    shortName VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    photo IMAGE
) AS Station;

CREATE TABLE cats (
    catID INT NOT NULL PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    portrait IMAGE,
    stationID INT NOT NULL,
    FOREIGN KEY (stationID) REFERENCES stations
) AS Cat;

-- CREATE TABLE affiliations (

-- ) AS Affiliation;