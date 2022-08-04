use PersonalTrainer;

-- Use an aggregate to count the number of Clients.
-- 500 rows
--------------------
SELECT COUNT(*) FROM Client; 

-- Use an aggregate to count Client.BirthDate.
-- The number is different than total Clients. Why?
-- 463 rows
--------------------
SELECT COUNT(Birthdate) FROM Client;
-- Some clients did not include birthdate.

-- Group Clients by City and count them.
-- Order by the number of Clients desc.
-- 20 rows
--------------------
SELECT COUNT(*), City FROM Client GROUP BY City Order by COUNT(*) DESC;

-- Calculate a total per invoice using only the InvoiceLineItem table.
-- Group by InvoiceId.
-- You'll need an expression for the line item total: Price * Quantity.
-- Aggregate per group using SUM().
-- 1000 rows
--------------------
SELECT InvoiceId, SUM(Price * Quantity) as 'Invoice Total' FROM InvoiceLineItem
GROUP BY InvoiceId;

-- Calculate a total per invoice using only the InvoiceLineItem table.
-- (See above.)
-- Only include totals greater than $500.00.
-- Order from lowest total to highest.
-- 234 rows
--------------------
SELECT InvoiceId, SUM(Price * Quantity) as 'Invoice_Total' FROM InvoiceLineItem
GROUP BY InvoiceId
HAVING SUM(Price * Quantity) > 500.0
ORDER BY SUM(Price * Quantity);

-- Calculate the average line item total
-- grouped by InvoiceLineItem.Description.
-- 3 rows
--------------------
SELECT Description, AVG(Price * Quantity) as 'Avg_Total' FROM InvoiceLineItem
GROUP BY Description;

-- Select ClientId, FirstName, and LastName from Client
-- for clients who have *paid* over $1000 total.
-- Paid is Invoice.InvoiceStatus = 2.
-- Order by LastName, then FirstName.
-- 146 rows
--------------------
SELECT a.ClientId, a.FirstName, a.LastName FROM Client a
INNER JOIN Invoice i on a.ClientId=i.ClientId
INNER JOIN InvoiceLineItem ilt on i.InvoiceId=ilt.InvoiceId
WHERE i.InvoiceStatus = 2
GROUP BY a.ClientId, a.FirstName, a.LastName
HAVING SUM(ilt.Price * ilt.Quantity) > 1000.00
ORDER BY a.LastName, a.FirstName;

-- Count exercises by category.
-- Group by ExerciseCategory.Name.
-- Order by exercise count descending.
-- 13 rows
--------------------
SELECT COUNT(e.Name) as 'Exercise_Count)', ec.Name as 'Excercise_Category' FROM ExerciseCategory ec
INNER JOIN Exercise e on ec.ExerciseCategoryId=e.ExerciseCategoryId
GROUP BY ec.Name
ORDER BY COUNT(e.Name) DESC;

-- Select Exercise.Name along with the minimum, maximum,
-- and average ExerciseInstance.Sets.
-- Order by Exercise.Name.
-- 64 rows
--------------------
SELECT e.Name as 'Exercise_name', MIN(ei.Sets) MinSets, MAX(ei.Sets) MaxSets, AVG(ei.Sets) AvgSets
FROM ExerciseInstance ei
INNER JOIN Exercise e on ei.ExerciseId=e.ExerciseId
GROUP BY e.Name, e.ExerciseId
ORDER BY e.Name;

-- Find the minimum and maximum Client.BirthDate
-- per Workout.
-- 26 rows
-- Sample: 
-- WorkoutName, EarliestBirthDate, LatestBirthDate
-- '3, 2, 1... Yoga!', '1928-04-28', '1993-02-07'
--------------------
SELECT w.name WorkoutName, MIN(c.Birthdate) EarliestBirthDate, MAX(c.Birthdate) LatestBirthDate
FROM Client c
INNER JOIN ClientWorkout cw on c.ClientId=cw.ClientId
INNER JOIN Workout w on cw.WorkoutId=w.WorkoutId
GROUP BY w.WorkoutId, w.name
ORDER BY w.name;

-- Count client goals.
-- Be careful not to exclude rows for clients without goals.
-- 500 rows total
-- 50 rows with no goals
--------------------
SELECT c.clientId, COUNT(cg.GoalId) Goal_Count FROM Client c
LEFT OUTER JOIN ClientGoal cg on c.ClientId=cg.ClientId
GROUP BY c.ClientId
ORDER BY COUNT(cg.GoalId) ASC;

-- Select Exercise.Name, Unit.Name, 
-- and minimum and maximum ExerciseInstanceUnitValue.Value
-- for all exercises with a configured ExerciseInstanceUnitValue.
-- Order by Exercise.Name, then Unit.Name.
-- 82 rows
--------------------
SELECT e.Name, u.Name, MIN(eiuv.Value), MAX(eiuv.Value)
FROM Exercise e 
INNER JOIN ExerciseInstance ei on e.ExerciseId=ei.ExerciseId
INNER JOIN ExerciseInstanceUnitValue eiuv on ei.ExerciseInstanceId=eiuv.ExerciseInstanceId
INNER JOIN Unit u on eiuv.UnitId=u.UnitId
GROUP BY e.ExerciseId, e.Name, u.UnitId, u.Name
ORDER BY e.Name, u.Name;

-- Modify the query above to include ExerciseCategory.Name.
-- Order by ExerciseCategory.Name, then Exercise.Name, then Unit.Name.
-- 82 rows
--------------------
SELECT ec.Name ExCat, e.Name ExName, u.Name UnitName, MIN(eiuv.Value) Min_value, MAX(eiuv.Value) Max_value
FROM Exercise e 
INNER JOIN ExerciseInstance ei on e.ExerciseId=ei.ExerciseId
INNER JOIN ExerciseInstanceUnitValue eiuv on ei.ExerciseInstanceId=eiuv.ExerciseInstanceId
INNER JOIN Unit u on eiuv.UnitId=u.UnitId
INNER JOIN ExerciseCategory ec on e.ExerciseCategoryId=ec.ExerciseCategoryId
GROUP BY ec.Name, e.ExerciseId, e.Name, u.UnitId, u.Name
ORDER BY ec.Name, e.Name, u.Name;

-- Select the minimum and maximum age in years for
-- each Level.
-- To calculate age in years, use the MySQL function DATEDIFF.
-- 4 rows
--------------------
SELECT * FROM Level;
SELECT l.Name ExerciseLevel, MIN(datediff(c.Birthdate, CURDATE())/365 ) MinAge, MAX(datediff(c.Birthdate, CURDATE()) / 365) MaxAge
FROM Level l
INNER JOIN Workout w on l.LevelId=w.LevelId
INNER JOIN ClientWorkout cw on w.WorkoutId=cw.WorkoutId
INNER JOIN Client c on cw.ClientId=c.ClientId
GROUP BY l.LevelId, l.Name;

-- Stretch Goal!
-- Count logins by email extension (.com, .net, .org, etc...).
-- Research SQL functions to isolate a very specific part of a string value.
-- 27 rows (27 unique email extensions)
--------------------
SELECT COUNT(EmailAddress), 
SUBSTRING(EmailAddress, POSITION('.' IN EmailAddress)) SUBSTRING FROM Login
GROUP BY SUBSTRING(EmailAddress, POSITION('.' IN EmailAddress))
ORDER BY COUNT(EmailAddress) DESC;

-- Match client goals to workout goals.
-- Select Client FirstName and LastName and Workout.Name for
-- all workouts that match at least 2 of a client's goals.
-- Order by the client's last name, then first name.
-- 139 rows
--------------------
SELECT c.FirstName, c. LastName, w.Name WorkoutName, count(cg.GoalId)
FROM Client c
INNER JOIN ClientWorkout cw on c.ClientId=cw.ClientId
INNER JOIN ClientGoal cg on cw.ClientId=cg.ClientId
INNER JOIN WorkoutGoal wg on cg.GoalId=wg.GoalId
INNER JOIN Workout w on wg.WorkoutId=w.WorkoutId
-- always ensure that id for quried tables have to be indicated in GROUP BY to prevent coagulation
GROUP BY w.WorkoutId, w.Name, c.ClientId, c.FirstName, c.LastName
HAVING COUNT(cg.GoalId) >= 2
ORDER BY c.LastName, c.FirstName;