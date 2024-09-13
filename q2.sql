/**************
 *            *
 * Question 2 *
 *            *
 **************/
 
DROP TABLE Q2_Artists;
DROP TABLE Q2_Works;

DROP TABLE Q2_ArtistWorks;

DROP TABLE Q2_WorkMediumCount;
DROP TABLE Q2_NationalityCount;

DROP TABLE Q2_AC_Interest;

DROP TABLE Q2_Customers;
DROP TABLE Q2_Transaction;
DROP TABLE Q2_CustomerTransactions;
DROP TABLE Q2_CustomerInterestArtist;

DROP TABLE Q2_TWA;
DROP TABLE Q2_CTWA;

DROP TABLE Q2_CustomersWhoveBought;
DROP TABLE Q2_ArtistInterestAmount;
DROP TABLE Q2_ArtistProfits;
DROP TABLE Q2_USArtists;
DROP TABLE Q2_CustomersWithUSInterest;
DROP TABLE Q2_CustomersWithUSInterestAmount;

-- Part 1. ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 1.	List the details of any work of art (including the name of the artist who created the work) that has ‘Signed’ in their description.

CREATE TABLE Q2_Artists AS
    (SELECT * FROM tutorials.Artist);
    
CREATE TABLE Q2_Works AS
    (SELECT * FROM tutorials.Work);

-- This will combine the products of both
CREATE TABLE Q2_ArtistWorks AS
    (SELECT Q2_Artists.ArtistID, Q2_Artists.FirstName, Q2_Artists.LastName, 
            Q2_Artists.Nationality, Q2_Artists.DateOfBirth, Q2_Artists.DateDeceased,
            Q2_Works.WorkID, Q2_Works.Title, Q2_Works.Copy, 
            Q2_Works.Medium, Q2_Works.Description 
        FROM Q2_Artists INNER JOIN Q2_Works 
            ON Q2_Artists.ArtistID = Q2_Works.ArtistID);
           
-- Show final 
SELECT * FROM Q2_ArtistWorks
    WHERE LOWER(Description) LIKE '%signed%';
    
    
    
    
-- Part 2. ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2. List all the nationalities with more than one artist represented in the database, and the number of artists of that nationality.

CREATE TABLE Q2_NationalityCount AS
    (SELECT COUNT(Nationality) AS NationalityAmount, Nationality 
        FROM Q2_Artists
        GROUP BY Nationality);
        
SELECT Nationality FROM Q2_NationalityCount
    WHERE NationalityAmount > 1;
    
    
    
-- Part 3. ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3. List the number of works in each medium, ordered from highest to lowest number

CREATE TABLE Q2_WorkMediumCount AS
    (SELECT COUNT(Medium) AS MediumAmount, Medium
        FROM Q2_Works
        GROUP BY Medium);
        
SELECT * FROM Q2_WorkMediumCount
    ORDER BY MediumAmount DESC;
    
-- Part 4. ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 4. List the names of all the customers and the names of the artists each customer has an interest in, in alphabetical order of artist last name within customer last name.

CREATE TABLE Q2_Customers AS
    (SELECT * FROM tutorials.Customer);

CREATE TABLE Q2_AC_Interest AS
    (SELECT * FROM tutorials.CUSTOMER_ARTIST_INT);

CREATE TABLE Q2_CustomerInterestArtist AS
    SELECT 
        C.CustomerID, C.LastName CustLastName, C.FirstName CustFirstName,
        C.AreaCode, C.PhoneNumber, C.Street, C.City, C.State, C.ZipPostalCode,
        C.Country, C.Email,
        A.ArtistID, A.LastName ArtLastName, A.FirstName ArtFirstName, 
        A.Nationality, A.DateOfBirth, A.DateDeceased
    FROM
        Q2_AC_Interest LEFT JOIN Q2_Customers C
            ON Q2_AC_Interest.CustomerID = C.CustomerID
        LEFT JOIN Q2_Artists A
            ON Q2_AC_Interest.ArtistID = A.ArtistID;

SELECT CustFirstName, CustLastName, ArtFirstName, ArtLastName
    FROM Q2_CustomerInterestArtist
    ORDER BY 
        CustLastName ASC, 
        ArtLastName ASC;



-- Part 5. ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 5. List the full name and email of any customers who have no address recorded.

SELECT (FirstName || ' ' || LastName) FullName, Email
    FROM Q2_Customers
    WHERE
        Street IS NULL OR 
        City IS NULL OR
        ZipPostalCode IS NULL OR
        Country IS NULL;


-- Part 6. ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 6. List the work ID, title and artist name of all the works of art that sold for more than the average sales price, and the price they sold for

CREATE TABLE Q2_Transaction AS
    (SELECT * FROM tutorials.Trans);

-- This links the Work and the Transaction of the Table
CREATE TABLE Q2_TWA AS
    (SELECT T.TransactionID, T.DateAcquired, T.AcquisitionPrice, 
            T.DateSold,      T.AskingPrice,  T.SalesPrice,     
            W.WorkID,        W.Title,
            W.Copy,          W.Medium,       W.Description,
            A.ArtistID,      
            A.LastName ArtistLastName,       A.FirstName ArtistFirstName, 
            A.Nationality,   A.DateOfBirth,  A.DateDeceased
        
        FROM Q2_Works W
            LEFT JOIN Q2_Transaction T
                ON W.WorkID = T.WorkID
            LEFT JOIN Q2_Artists A
                ON W.ArtistID = A.ArtistID);


SELECT WorkID, Title, (ArtistFirstName || ' ' || ArtistLastName) FullName
    FROM Q2_TWA
    WHERE 
        SalesPrice > (SELECT AVG(SalesPrice) FROM Q2_TWA);


-- Part 7. ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 7. List the full name of any customers who haven’t bought any works of art

CREATE TABLE Q2_CustomerTransactions AS
    (SELECT Q2_Customers.CustomerID, Q2_Customers.LastName, Q2_Customers.FirstName,
            Q2_Customers.Street, Q2_Customers.City, Q2_Customers.State,
            Q2_Customers.ZipPostalCode, Q2_Customers.AreaCode, Q2_Customers.Country, Q2_Customers.Email,
            Q2_Transaction.TransactionID, Q2_Transaction.DateAcquired, Q2_Transaction.AcquisitionPrice,
            Q2_Transaction.DateSold, Q2_Transaction.AskingPrice, Q2_Transaction.SalesPrice, Q2_Transaction.WorkID
        FROM Q2_Customers INNER JOIN Q2_Transaction
            ON Q2_Customers.CustomerID = Q2_Transaction.CustomerID);

-- Get Customers not in this list.
SELECT (C.FirstName || ' ' || C.LastName) FullName
    FROM Q2_Customers C
    WHERE NOT EXISTS 
        (SELECT T.CustomerID 
            FROM Q2_Transaction T
            WHERE T.CustomerID = C.CustomerID);



-- Part 8. ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 8. Which artist (give his/her full name) has the most customers interested in him or her, and how many customers are interested in them

CREATE TABLE Q2_ArtistInterestAmount AS
    (SELECT COUNT(I.CustomerID) AmountOfCustomers, I.ArtistID
        FROM Q2_AC_Interest I
        GROUP BY I.ArtistID);

CREATE TABLE Q2_ArtistsWithMostInterest AS
    (SELECT * 
        FROM Q2_ArtistInterestAmount
        WHERE AmountOfCustomers = 
            (SELECT MAX(AmountOfCustomers) FROM Q2_ArtistInterestAmount));

SELECT (FirstName || ' ' || LastName) FullName, AmountOfCustomers 
    FROM Q2_ArtistsWithMostInterest I
    LEFT JOIN Q2_Artists A
        ON A.ArtistID = I.ArtistID;








-- Part 9. ------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 9. List the total dollar amount of sales each artist (give his/her full name) has made on their works, in descending order of total. 

CREATE TABLE Q2_ArtistProfits AS
    (SELECT SUM(T.SalesPrice) TotalRevenue, T.ArtistID
        FROM Q2_TWA T
        GROUP BY T.ArtistID);

SELECT ('$' || TotalRevenue) TotalProfit, (FirstName || ' ' || LastName) FullName
    FROM Q2_Artists A
    LEFT JOIN Q2_ArtistProfits P
        ON A.ArtistID = P.ArtistID;

-- Part 10. -----------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE TABLE Q2_USArtists AS
    (SELECT * 
        FROM Q2_Artists
        WHERE Nationality = 'United States');

CREATE TABLE Q2_CustomersWithUSInterest AS
    (SELECT I.CustomerID, USA.ArtistID
        FROM Q2_USArtists USA
        LEFT JOIN Q2_AC_Interest I
            ON USA.ArtistID = I.ArtistID);
    
CREATE TABLE Q2_CustomersWithUSInterestAmount AS 
    (SELECT CustomerID, COUNT(UNIQUE ArtistID) USArtistAmount
        FROM Q2_CustomersWithUSInterest
        GROUP BY CustomerID);
        
SELECT (FirstName || ' ' || LastName) FullName
    FROM Q2_CustomersWithUSInterestAmount CUSA
    LEFT JOIN Q2_Customers C
        ON C.CustomerID = CUSA.CustomerID
    WHERE USArtistAmount = (SELECT COUNT(UNIQUE ArtistID) FROM Q2_USArtists);
    
/*

            
SELECT * FROM Q2_CustomerTransactions;

CREATE TABLE Q2_CTWA AS   -- Customer Transaction Work Artist
    (SELECT CT.CustomerID,    
            CT.LastName AS CustLastName,           CT.FirstName AS CustFirstName,
            CT.Street,        CT.City,             CT.State,        
            CT.ZipPostalCode, CT.AreaCode,         CT.Country,       
            CT.Email,         CT.TransactionID,    CT.DateAcquired,  
            CT.AcquisitionPrice, 
            CT.DateSold,      CT.AskingPrice,      CT.SalesPrice,       
            AW.WorkID,        AW.ArtistID,
            AW.FirstName AS ArtFirstName,     
            AW.LastName AS ArtLastName,            AW.Nationality,   
            AW.DateOfBirth,   AW.DateDeceased,     AW.Title, 
            AW.Copy,          AW.Medium,           AW.Description 
        FROM Q2_CustomerTransactions CT INNER JOIN Q2_ArtistWorks AW
            ON CT.WorkID = AW.WorkID);

SELECT ArtFirstName, ArtLastName, CustFirstName, CustLastNamesn
    FROM Q2_CTWA
    ORDER BY ArtLastName ASC, CustLastName ASC;
    */