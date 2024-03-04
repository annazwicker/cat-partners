
CREATE TABLE IF NOT EXISTS  user(
userID INT NOT NULL AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
affiliation VARCHAR(255) NOT NULL,
rescueGroupAffiliation VARCHAR(255), FOREIGN KEY (rescueGroupAffiliation) REFERENCES rescueGroup(rescueID),
phoneNumber VARCHAR(255),
isAdmin BIT(1) NOT NULL,
isLinked BIT(1) NOT NULL,
isPrivateProfile BIT(1) NOT NULL,
createGoogleCalendarEvent BIT(1) NOT NULL,
isOptInEmails BIT(1) NOT NULL,
ForwardEmailTime INT NOT NULL,
abbreviation varchar(255) NOT NULL,
PRIMARY KEY (userID)
);


CREATE TABLE IF NOT EXISTS  rescueGroup(
rescueID INT NOT NULL AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
link VARCHAR(255),
PRIMARY KEY (rescueID)
);






CREATE TABLE IF NOT EXISTS  googleAccount(
googleID VARCHAR(255) NOT NULL,
userID INT NOT NULL, FOREIGN KEY (user) REFERENCES user(userID),
PRIMARY KEY (googleID)
);



CREATE TABLE IF NOT EXISTS  station(
stationID INT NOT NULL AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
description TEXT NOT NULL,
photo VARCHAR(255) NOT NULL,
PRIMARY KEY (stationID)
);



CREATE TABLE IF NOT EXISTS  cat(
catID INT NOT NULL AUTO_INCREMENT,
name VARCHAR(255) NOT NULL,
description TEXT NOT NULL,
photo VARCHAR(255),
stationID INT NOT NULL, FOREIGN KEY (stationID) REFERENCES station(stationID),
PRIMARY KEY (catID)
);


CREATE TABLE IF NOT EXISTS entry(
stationID INT NOT NULL, FOREIGN KEY (stationID) REFERENCES station(stationID),
date DATETIME NOT NULL,
assignedUser INT NOT NULL, FOREIGN KEY (assignedUser) REFERENCES user(userID),
isChecked BIT(1) NOT NULL,
note TEXT,
CONSTRAINT entryKey PRIMARY KEY (stationID, date)
);




CREATE TABLE IF NOT EXISTS  sighting(
date DATETIME NOT NULL,
catID INT NOT NULL, FOREIGN KEY (catID) REFERENCES cat(catID),
stationID INT, FOREIGN KEY (stationID) REFERENCES station(stationID), 
CONSTRAINT sightingKey PRIMARY KEY (date, catID)
);




CREATE TABLE IF NOT EXISTS adminNotification(
notificationID int NOT NULL AUTO_INCREMENT,
date DATETIME NOT NULL,
notificationText TEXT NOT NULL,
PRIMARY KEY (notificationID)
);
