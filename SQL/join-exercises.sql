USE PersonalTrainer;

-- Select all columns from ExerciseCategory and Exercise.
-- The tables should be joined on ExerciseCategoryId.
-- This query returns all Exercises and their associated ExerciseCategory.
-- 64 rows
--------------------
SELECT * FROM ExerciseCategory a JOIN Exercise b ON a.ExerciseCategoryID = b.ExerciseCategoryID;
    
-- Select ExerciseCategory.Name and Exercise.Name
-- where the ExerciseCategory does not have a ParentCategoryId (it is null).
-- Again, join the tables on their shared key (ExerciseCategoryId).
-- 9 rows
--------------------
SELECT ExerciseCategory.Name, Exercise.Name FROM ExerciseCategory JOIN Exercise on ExerciseCategory.ExerciseCategoryId = Exercise.ExerciseCategoryId
WHERE ExerciseCategory.ParentCategoryId IS NULL;

-- The query above is a little confusing. At first glance, it's hard to tell
-- which Name belongs to ExerciseCategory and which belongs to Exercise.
-- Rewrite the query using an aliases. 
-- Alias ExerciseCategory.Name as 'CategoryName'.
-- Alias Exercise.Name as 'ExerciseName'.
-- 9 rows
--------------------
SELECT a.Name, b.Name FROM ExerciseCategory a JOIN Exercise b on a.ExerciseCategoryId = b.ExerciseCategoryId
WHERE a.ParentCategoryId IS NULL;

-- Select FirstName, LastName, and BirthDate from Client
-- and EmailAddress from Login 
-- where Client.BirthDate is in the 1990s.
-- Join the tables by their key relationship. 
-- What is the primary-foreign key relationship?
-- 35 rows
--------------------
SELECT a.FirstName, a.LastName, a.BirthDate, b.EmailAddress FROM Client a JOIN Login b on a.ClientId = b.ClientId WHERE a.BirthDate BETWEEN '1990-01-01' AND '1999-12-31';

-- Select Workout.Name, Client.FirstName, and Client.LastName
-- for Clients with LastNames starting with 'C'?
-- How are Clients and Workouts related?
-- 25 rows
--------------------
SELECT c.Name as 'Workout Name', a.FirstName, a.LastName FROM Client a INNER JOIN ClientWorkout b on a.ClientId = b.ClientId
INNER JOIN Workout c on b.WorkoutId = c.WorkoutId 
WHERE a.LastName LIKE 'C%';

-- Select Names from Workouts and their Goals.
-- This is a many-to-many relationship with a bridge table.
-- Use aliases appropriately to avoid ambiguous columns in the result.
--------------------
SELECT a.Name as 'Workout Name', c.Name as 'Goals'  FROM Workout a INNER JOIN WorkoutGoal b on a.WorkoutId = b.WorkoutId 
INNER JOIN Goal c on b.Goalid = c.GoalId;

-- Select FirstName and LastName from Client.
-- Select ClientId and EmailAddress from Login.
-- Join the tables, but make Login optional. (if present in left table)
-- 500 rows
--------------------
SELECT a.FirstName, a.LastName, b.ClientId, b.EmailAddress FROM Client a LEFT OUTER JOIN Login b on a.ClientId = b.ClientId;

-- Using the query above as a foundation, select Clients
-- who do _not_ have a Login.
-- 200 rows
--------------------
SELECT a.FirstName, a.LastName, b.ClientId, b.EmailAddress FROM Client a LEFT OUTER JOIN Login b on a.ClientId = b.ClientId
WHERE b.ClientId IS NULL;

-- Does the Client, Romeo Seaward, have a Login?
-- Decide using a single query.
-- nope :(
--------------------
SELECT a.FirstName, a.LastName, b.ClientId, b.EmailAddress FROM Client a LEFT OUTER JOIN Login b on a.ClientId = b.ClientId
WHERE a.LastName = 'Seaward' AND a.FirstName = 'Romeo';

-- Select ExerciseCategory.Name and its parent ExerciseCategory's Name.
-- This requires a self-join.
-- 12 rows
--------------------
Select a.Name as 'Child Category', b.Name as 'Parent Category' FROM ExerciseCategory a INNER JOIN ExerciseCategory b on a.ExerciseCategoryId = b.ParentCategoryId;
    
-- Rewrite the query above so that every ExerciseCategory.Name is
-- included, even if it doesn't have a parent.
-- 16 rows
--------------------
Select a.Name as 'Child Category', b.Name as 'Parent Category' FROM ExerciseCategory a INNER JOIN ExerciseCategory b on a.ExerciseCategoryId = b.ExerciseCategoryId;

-- Are there Clients who are not signed up for a Workout?
-- 50 rows
--------------------
Select a.FirstName, a.LastName From Client a LEFT OUTER JOIN ClientWorkout b on a.ClientId = b.ClientId
WHERE b.WorkoutId IS NULL;

-- Which Beginner-Level Workouts satisfy at least one of Shell Creane's Goals?
-- Goals are associated to Clients through ClientGoal.
-- Goals are associated to Workouts through WorkoutGoal.
-- 6 rows, 4 unique rows
--------------------
SELECT Workout.WorkoutId, Workout.Name FROM Client
inner join ClientGoal on Client.ClientId=ClientGoal.ClientId
inner join WorkoutGoal on ClientGoal.GoalId=WorkoutGoal.GoalId
inner join Workout on WorkoutGoal.WorkoutId=Workout.WorkoutId
WHERE Client.LastName = 'Creane'
AND Client.FirstName = 'Shell'
AND Workout.LevelId = 1;

-- Select all Workouts. 
-- Join to the Goal, 'Core Strength', but make it optional.
-- You may have to look up the GoalId before writing the main query.
-- If you filter on Goal.Name in a WHERE clause, Workouts will be excluded.
-- Why?
-- 26 Workouts, 3 Goals
--------------------
-- look up GoalId
SELECT GoalId, name FROM Goal WHERE name = 'Core Strength';
-- GoadId = 10
SELECT w.Name, g.name FROM Workout w LEFT OUTER JOIN WorkoutGoal wg on w.WorkoutId=wg.WorkoutId AND wg.GoalId = 10
LEFT OUTER JOIN Goal g on wg.GoalId=g.GoalId;

-- The relationship between Workouts and Exercises is... complicated.
-- Workout links to WorkoutDay (one day in a Workout routine)
-- which links to WorkoutDayExerciseInstance 
-- (Exercises can be repeated in a day so a bridge table is required) 
-- which links to ExerciseInstance 
-- (Exercises can be done with different weights, repetions,
-- laps, etc...) 
-- which finally links to Exercise.
-- Select Workout.Name and Exercise.Name for related Workouts and Exercises.
--------------------
SELECT Workout.Name as 'Workout Name', Exercise.Name as 'Exercise Name' FROM Workout
INNER JOIN WorkoutDay on Workout.WorkoutId = WorkoutDay.WorkoutId
INNER JOIN WorkoutDayExerciseInstance on WorkoutDay.WorkoutDayId=WorkoutDayExerciseInstance.WorkoutDayId
INNER JOIN ExerciseInstance on WorkoutDayExerciseInstance.ExerciseInstanceId=ExerciseInstance.ExerciseInstanceId
INNER JOIN Exercise on ExerciseInstance.ExerciseId=Exercise.ExerciseId
;

-- An ExerciseInstance is configured with ExerciseInstanceUnitValue.
-- It contains a Value and UnitId that links to Unit.
-- Example Unit/Value combos include 10 laps, 15 minutes, 200 pounds.
-- Select Exercise.Name, ExerciseInstanceUnitValue.Value, and Unit.Name
-- for the 'Plank' exercise. 
-- How many Planks are configured, which Units apply, and what 
-- are the configured Values?
-- 4 rows, 1 Unit, and 4 distinct Values
--------------------
SELECT e.Name, eiuv.Value, u.Name FROM Exercise e
INNER JOIN ExerciseInstance ei on e.ExerciseId=ei.ExerciseId
INNER JOIN ExerciseInstanceUnitValue eiuv on ei.ExerciseInstanceId=eiuv.ExerciseInstanceId
INNER JOIN Unit u on eiuv.UnitId=u.UnitId
WHERE e.name = 'Plank';
