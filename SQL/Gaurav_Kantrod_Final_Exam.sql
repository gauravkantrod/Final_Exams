create database sql_final_exam;

use sql_final_exam;

-- 1.A) Get the name of the books written by oskar wilde.
SELECT title
FROM book
where author_name = 'oskar wilde';

-- 1.B) Get the details of the books published either by “tmh” or by “phi”
SELECT *
FROM book
WHERE publiher_name IN ('tmh', 'phi');

-- 1.C) List the total price of the books written by “e balaguruswamy”;
SELECT SUM(price)
FROM book
WHERE author_name = 'e balaguruswamy';

-- 1.D) List the title and author names of the book published by publishers whose name starts with “p”
SELECT title, author_name
FROM book
WHERE publisher_name = 'p%';

-- 1.E) Display a column named “book_code” along with the price , where book_code consists of the 
-- first 3 letters of the title and the first 3 letters of the author separated by an “_”

SELECT concat(substr(title, 1,3),'-',substr(author_name,1,3)) as 'book_code', price
FROM book;

-- 2.A) Display the details of sandwiches which lies within a price range of 20 to 50.
SELECT * 
FROM sandwich
WHERE price BETWEEN 20 and 50;

-- 2.B) Display the names of the sandwiches in uppercase.
SELECT upper(name)
FROM sandwich;

-- 2.C) Display the names of the sandwiches where the filling contains “veg”
SELECT name
FROM sandwich
WHERE filling LIKE '%veg%';

-- 2.D) Replace the “san” of the sandwich name with “mac” and display. e.g. “san-chicken” should be displayed as “mac-chicken”
SELECT replace(name,'san','veg')
FROM sandwich;

-- 2.E) Display the average price of the sandwiches as per the type of bread.
SELECT Bread, avg(price) as 'Avg Price'
FROM sandwich
GROUP BY Bread;

-- 3.A)Display the total number of products which belong to the company “cadburys”
SELECT COUNT(product_name) as 'Total number of products'
FROM Product
WHERE company_name = 'cadburys';

-- 3.B) Display the product name and its price per dozen.
SELECT product_name, (unit_price*12) as 'Price per dozen'
FROM Product;

-- 3.C) Display the names of the products and its price which belong to the same company sorted by the name of the company.
SELECT product_name, unit_price
FROM Product
GROUP BY company_name
ORDER BY company_name;

-- 3.D) List the names of the products in the price range of 500 to 1000.
SELECT product_name
FROM Product
WHERE unit_price BETWEEN 500 AND 1000;

-- 3.E) Display the price of the products in comma separated format up to 4 decimal places. e.g. 25000 should be displayed as 25,000.0000
SELECT FORMAT(unit_price, 4) as 'Price'
FROM Product;

-- 4.A) List the names of the students who study in semester 4 of the course “msc.cs”
SELECT name
FROM Student
WHERE semester = 4 and course = 'msc.cs';

-- 4.B) List the details of the students from the city of “Bangalore”
SELECT *
FROM Student
WHERE address = 'Bangalore';

-- 4.C) List the names of the students who have enrolled in more than one course.
SELECT s1.name
FROM Student s1, Student s2
WHERE s1.name = s2.name AND s2.course != s1.course;

-- 4.D) Display the number of students who got grade “A” or “A+”
SELECT grade
FROM Student
WHERE grade IN ('A', 'A+');

-- 4.E) List the names of the students who study in even semesters.
SELECT name
FROM Student
WHERE semester%2 = 0;

-- 1.A) Find the no: of days since Steve smith played his last match.(2.5 Marks)
SELECT DATEDIFF(day, CURDATE(), Lastmatch_played)
FROM player_batsmen
WHERE FirstName = 'Steve' and LastName = 'Smith' ;

-- 1.B) Select the first and last names of all the players who haven’t got strike rate above 50.(2.5 Marks)
SELECT FirstName, LastName
FROM player_batsmen
WHERE Strikerate <= 50;

-- 1.C)Fetch the names of the players who have played more than 150 matches and strike rate more 
-- than 40 arrange by last match played to show the most recent first. .(2.5 Marks)
SELECT concat(FirstName,' ',LastName) as 'Name'
FROM player_batsmen
WHERE MatchesPlayed > 150 AND Strikerate > 40
ORDER BY Lastmatch_played DESC;

-- 1.D)Fetch the names of the players who have played less than 200 matches and scored more than 5000 runs. .(2.5 Marks)
SELECT concat(FirstName,' ',LastName) as 'Name'
FROM player_batsmen
WHERE MatchesPlayed < 200 AND Runs > 5000;

-- 1.A) list the names of the employees whose salary is greater than the salary of the manager of their respective departments(4 marks)
SELECT E.vname, E.emp_dept
FROM Employee E
INNER JOIN Manager M
ON E.emp_dept = M.dept
WHERE (E.emp_salary > M.man_salary) AND (E.emp_dept = M.dept)
GROUP BY E.emp_dept;

-- 1.B) display the grade of the employee according to their salaries: (6 Marks)
-- If salary <3000 grade “v”
-- if salary between 3000 and 5000 grade ‘iv’
-- if salary >5000 and <=10000 grade ‘iii’
-- if salary>10000 and <=50000 grade ‘ii’
-- if salary>50000 grade ‘i’

SELECT vname,
	CASE WHEN emp_salary < 3000 then  'v'
	WHEN emp_salary between 3000 and 5000 then  ‘iv’
	WHEN emp_salary >5000 and emp_salary<=10000 then  ‘iii’
	WHEN emp_salary>10000 and emp_salary<=50000 then  ‘ii’
	WHEN emp_salary>50000 then ‘i’
	END AS grade
FROM Employee;


-- 1.A) Create the all the above tables with appropriate “CREATE TABLE” statements with the primary key, 
-- foreign key and checked constraints.(5 Marks)

create table customers (
  custid varchar(10) primary key,
  cust_name varchar(50),
  contact_no varchar(50),
  constraint contact_no check (length (contact_no)=10)
) ;

create table movie (
  MovieID varchar(50) primary key,
  movie_name varchar(50),
  ActorName varchar(50),
  ActressName varchar(50),
  DirectorName varchar(50),
  ReleaseDate date,
  CountryName varchar(50)
) ;

create table screen (
  ScreenID varchar(50) primary key not null,
  screen_name varchar(50),
  MovieID varchar(50),
  Capacity int,
  foreign key (MovieID) references movie(MovieID),
   constraint Capacity check (Capacity>50)
);

create table tickets (
  TicketID varchar(50) primary key not null,
  MovieID varchar(50),
  ScreenID varchar(50),
  CustID varchar(50),
  ticket_date date,
  Price bigint,
  foreign key (MovieID) references movie(MovieID),
  foreign key (ScreenID) references screen(ScreenID),
  foreign key (custid) references customers(custid),
  constraint Price check (Price>0)
);

-- 1.B) Display the movie name with the second highest ticket price. (5 Marks)

SELECT m.movie_name, max(t.Price)
FROM movie m
INNER JOIN tickets t
ON m.MovieID = t.MovieID
WHERE t.Price < (SELECT max(Price) FROM tickets);

-- 1.C) List the name of the director of the movie which has been sold the most number of times. .(5 Marks)
SELECT t.MovieID, count(t.TicketID) AS 'Ticket Sold', DirectorName, m.movie_name 
FROM TICKETS t
INNER JOIN MOVIE m
ON m.MovieID=t.MovieID
GROUP BY MovieID
HAVING count(t.TicketID)>=ALL(SELECT count(TicketID) FROM TICKETS t INNER JOIN MOVIE m
ON m.MovieID=t.MovieID
GROUP BY t.MovieID);

-- 2.A) Write the query to derive the following result set. (1 Marks)
SELECT p.PlayerID, p.FirstName, p.LastName, p.Country, f.MatchFees
FROM player_batsmen p
INNER JOIN player_fees f
ON p.PlayerID = f.PlayerID;

-- 2.B) Create a table named player_details with playerid (int), age(int and not nullable), half_centuries (int), centuries (int)  
-- and set playerid as the primary key.(2 Marks)

CREATE TABLE player_details(
	playerid INT PRIMARY KEY,
	age INT NOT NULL,
	half_centuries INT,
	centuries INT
);

-- 2.C) Insert a record for Virat Kohli who is 34 years old and has 70 halfcenturies and 21 centuries. (3 Marks)
ALTER TABLE player_details
ADD palyer_name varchar (20) ;
INSERT INTO player_details (playerid, age, half_centuries, player_name) values (1, 34,70,21, 'Virat kholi');


-- 2.D) Write queries to find SUM () as Total_Runs and AVG () as AverageRuns_Scored  of runs grouped by 
-- country with references to the table player.(2 Marks)
SELECT SUM(Runs) AS 'Total_Runs', AVG(Runs) AS 'AverageRuns_Scored'
FROM player_batsmen
GROUP BY Country;

-- 2.E) List of players with firstname, lastname, age and matchfees who have played more than 200 matches age less than 30  
-- and have a match fees between 10000 and 20000(3 Marks)
SELECT p.FirstName, p.LastName, d.age, f.MatchFees
FROM player_batsmen p
INNER JOIN player_fees f
ON p.PlayerID = f.PlayerID
INNER JOIN player_details d
ON d.PlayerID = p.PlayerID
WHERE p.MatchesPlayed > 200 AND d.age < 30 AND (f.MatchFees BETWEEN 1000 AND 20000);


-- 2.F) Update the match fees of those players who have scored more than 40 half centuries and 20 centuries by 6000$. (4 Marks)

UPDATE d player_details INNER JOIN player_fees f on d.playerid = f.player_fees SET f.matchfees = f.matchfees + 6000
WHERE d.centuries > 20 AND d.half_centuries > 40;


































































