/**************
 * Question 3 *
 **************/

-- Drop everything

ALTER TABLE Event 
    DROP CONSTRAINT fkVenue;
    
ALTER TABLE Event
    DROP CONSTRAINT fkSport;

DROP TABLE Venue;
DROP TABLE Event;
DROP TABLE Sport;

-- Create Venue and Event



-- Q1

CREATE TABLE Venue(
    VenueName VARCHAR(255)       NOT NULL PRIMARY KEY,
    Location VARCHAR(255)        NOT NULL,
    Capacity NUMBER(38, 0)       NOT NULL);
    
    
    
-- Q2 
    
CREATE TABLE Event(
    EventName VARCHAR(255)       NOT NULL PRIMARY KEY,
    ScheduledStart VARCHAR(255),
    VenueName VARCHAR(255)       NOT NULL,       
    
    CONSTRAINT fkVenue 
        FOREIGN KEY (VenueName)  
            REFERENCES Venue(VenueName));
   
            

-- Q3.

INSERT INTO Venue
    VALUES ('Maracana Stadium', 'Avenida Maracana', 78838);
    
    
-- Q4.

CREATE TABLE Sport(
    SportName VARCHAR(255) NOT NULL PRIMARY KEY);

INSERT INTO Sport 
    VALUES ('Athletics');
    
INSERT INTO Sport 
    VALUES ('Swimming');
    
INSERT INTO Sport 
    VALUES ('Tennis');
    
-- Add Foreign Key Constraint
ALTER TABLE Event
    ADD SportName VARCHAR(255) NOT NULL;
ALTER TABLE Event
    ADD CONSTRAINT fkSport 
        FOREIGN KEY (SportName)
            REFERENCES Sport(SportName);



-- Q5.

-- Change Maracana Stadium
UPDATE Venue
    SET Capacity = 80000
    WHERE VenueName = 'Maracana Stadium';





    
SELECT * FROM Venue;
SELECT * FROM Event;
SELECT * FROM Sport;