-- =====================================================================
-- Advanced Database - Task 01 Solution
-- Database: Training CenterDB
-- SQL Server Syntax
-- =====================================================================

-- Create Database
CREATE DATABASE [Training CenterDB];
GO

USE [Training CenterDB];
GO

-- ---------------------------------------------------------------------
-- Table Creation
-- ---------------------------------------------------------------------

-- 1. Department Table
CREATE TABLE Department (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50) NOT NULL UNIQUE
);
GO

-- 2. Student Table
CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(100) NOT NULL,
    Age INT CHECK (Age >= 18),
    City VARCHAR(50),
    Email VARCHAR(100) UNIQUE,
    DepartmentID INT FOREIGN KEY REFERENCES Department(DepartmentID)
);
GO

-- 3. Course Table
CREATE TABLE Course (
    CourseID INT PRIMARY KEY,
    CourseName VARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) CHECK (Price > 0),
    Duration INT CHECK (Duration > 0),
    DepartmentID INT FOREIGN KEY REFERENCES Department(DepartmentID)
);
GO

-- ---------------------------------------------------------------------
-- Insert Data
-- ---------------------------------------------------------------------

-- Insert Departments (3 departments)
INSERT INTO Department (DepartmentID, DepartmentName) VALUES
(1, 'Computer Science'),
(2, 'Business Administration'),
(3, 'Graphic Design');
GO

-- Insert Students (8 students with unique ages, shared cities, and one NULL city)
INSERT INTO Student (StudentID, StudentName, Age, City, Email, DepartmentID) VALUES
(1, 'Alice Smith', 22, 'Damascus', 'alice.smith@example.com', 1),
(2, 'Bob Johnson', 24, 'Aleppo', 'bob.johnson@example.com', 2),
(3, 'Charlie Brown', 21, 'Damascus', 'charlie.brown@example.com', 1),
(4, 'Diana Prince', 23, 'Homs', 'diana.prince@example.com', 3),
(5, 'Ethan Hunt', 26, NULL, 'ethan.hunt@example.com', 1),
(6, 'Fiona Gallagher', 20, 'Aleppo', 'fiona.gallagher@example.com', 2),
(7, 'George Clark', 25, 'Damascus', 'george.clark@example.com', 3),
(8, 'Hannah Abbott', 27, 'Latakia', 'hannah.abbott@example.com', 1);
GO

-- Insert Courses (6 courses with unique prices and multiple courses per department)
INSERT INTO Course (CourseID, CourseName, Price, Duration, DepartmentID) VALUES
(101, 'Python Programming', 250.00, 30, 1),
(102, 'Data Structures', 350.00, 40, 1),
(103, 'Financial Accounting', 150.00, 25, 2),
(104, 'Business Management', 450.00, 45, 2),
(105, 'UI/UX Design Principles', 320.00, 20, 3),
(106, 'Advanced Photoshop', 180.00, 15, 3);
GO

-- ---------------------------------------------------------------------
-- Part 1: Standard Requirements (1 to 30)
-- ---------------------------------------------------------------------

-- Q1
SELECT StudentID, StudentName, City 
FROM Student;

-- Q2
SELECT * 
FROM Student 
WHERE Age < 25;

-- Q3
SELECT * 
FROM Student 
WHERE Age >= 21;

-- Q4
SELECT * 
FROM Student 
WHERE Age <= 25;

-- Q5
SELECT * 
FROM Student 
WHERE Age <> 20;

-- Q6
SELECT * 
FROM Course 
WHERE Price BETWEEN 100 AND 500;

-- Q7
SELECT * 
FROM Student 
WHERE City IN ('Damascus', 'Aleppo');

-- Q8
SELECT * 
FROM Student 
WHERE StudentName LIKE 'A%';

-- Q9
SELECT * 
FROM Student 
WHERE StudentName NOT LIKE 'A%';

-- Q10
SELECT * 
FROM Student 
WHERE City IS NULL;

-- Q11
SELECT * 
FROM Student 
WHERE City IS NOT NULL;

-- Q12
SELECT * 
FROM Student 
WHERE Age > 20 AND City = 'Damascus';

-- Q13
SELECT * 
FROM Student 
WHERE City = 'Damascus' OR City = 'Aleppo';

-- Q14
SELECT * 
FROM Student 
WHERE City <> 'Damascus' OR City IS NULL;

-- Q15
SELECT * 
FROM Course 
ORDER BY Price DESC;

-- Q16
SELECT * 
FROM Student 
ORDER BY Age ASC;

-- Q17
SELECT * 
FROM Student 
ORDER BY City ASC, StudentName DESC;

-- Q18
SELECT TOP 3 * 
FROM Course 
ORDER BY Price DESC;

-- Q19
SELECT MAX(Price) AS HighestPrice 
FROM Course;

-- Q20
SELECT COUNT(*) AS TotalStudents 
FROM Student;

-- Q21
SELECT COUNT(DISTINCT City) AS UniqueCitiesCount 
FROM Student;

-- Q22
SELECT City, COUNT(*) AS StudentCount 
FROM Student 
GROUP BY City;

-- Q23
SELECT DepartmentID, AVG(Price) AS AverageCoursePrice 
FROM Course 
GROUP BY DepartmentID;

-- Q24
SELECT DepartmentID, MAX(Price) AS HighestCoursePrice 
FROM Course 
GROUP BY DepartmentID;

-- Q25
SELECT DepartmentID 
FROM Student 
GROUP BY DepartmentID 
HAVING COUNT(*) > 2;

-- Q26
SELECT DepartmentID 
FROM Course 
GROUP BY DepartmentID 
HAVING AVG(Price) > 300;

-- Q27
UPDATE Student 
SET City = 'Tartus', Age = 28 
WHERE StudentID = 1;

-- Q28
UPDATE Student 
SET City = 'Hama' 
WHERE City = 'Aleppo';

-- Q29
UPDATE Course 
SET Price = Price * 1.10;

-- Q30
DELETE FROM Student 
WHERE Age < 21;

-- ---------------------------------------------------------------------
-- Part 2: Final Challenge
-- ---------------------------------------------------------------------

-- Final Challenge 1: Show the 3 oldest students who are not from Damascus, ordered from oldest to youngest.
SELECT TOP 3 * 
FROM Student 
WHERE City <> 'Damascus' OR City IS NULL 
ORDER BY Age DESC;

-- Final Challenge 2: Show each city and the number of students in it, but only for cities containing more than 1 student.
SELECT City, COUNT(*) AS StudentCount 
FROM Student 
WHERE City IS NOT NULL 
GROUP BY City 
HAVING COUNT(*) > 1;

-- Final Challenge 3: Show each department and its average course price, keeping only departments whose average is at least 300.
SELECT DepartmentID, AVG(Price) AS AvgCoursePrice 
FROM Course 
GROUP BY DepartmentID 
HAVING AVG(Price) >= 300;

-- Final Challenge 4: Increase the price of courses costing less than 200 by 5%.
UPDATE Course 
SET Price = Price * 1.05 
WHERE Price < 200;

-- Final Challenge 5: Remove students whose age is below 20.
DELETE FROM Student 
WHERE Age < 20;