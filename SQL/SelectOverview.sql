use PersonalTrainer;

SELECT * FROM Exercise;

SELECT * FROM Client;

SELECT * FROM Client WHERE City = 'Metairie';

SELECT * FROM Client WHERE ClientId = '818u7faf-7b4b-48a2-bf12-7a26c92de20c';

SELECT COUNT(*) FROM Goal;

SELECT Name, LevelId FROM Workout;

SELECT Name, LevelId, Notes FROM Workout WHERE LevelId = '2';

SELECT FirstName, LastName, City FROM Client WHERE (City = 'Metairie' ) OR (City = 'Kenner') OR (City = 'Gretna');

SELECT FirstName, LastName, BirthDate FROM Client WHERE Birthdate BETWEEN '1980-01-01' AND '1989-12-31';

SELECT FirstName, LastName, BirthDate FROM Client WHERE Birthdate >= '1980-01-01' AND Birthdate <= '1989-12-31';

SELECT COUNT(*) FROM Login WHERE EmailAddress LIKE '%.gov';

SELECT COUNT(*) FROM Login WHERE EmailAddress NOT LIKE '%.com';

SELECT firstname, lastname FROM Clients WHERE Birthdate IS NULL;

SELECT Name FROM ExerciseCategory WHERE ParentCatergoryId IS NOT NULL;

SELECT Name, Notes FROM Workout WHERE level='3' AND word LIKE '%you%';

SELECT FirstName, LastName, City FROM CLIENT WHERE LastName='L%' OR LastName='M%' OR LastName='N%' AND city='LaPlace';

SELECT InvoiceId, Description, Price, Quantity, ServiceDate, line_item_total WHERE line_item_total >= '15' and line_item_total <= '25';

SELECT ClientId, Firstname FROM Client WHERE Firstname = 'Estrella' AND Lastname = 'Bazely';
SELECT EmailAddress FROM Login WHERE ClientId='87976c42-9226-4bc6-8b32-23a8cd7869a5';
### Email Address = ebazelybf@123-reg.co.uk ###

SELECT WorkoutId FROM Workout WHERE Name = 'This Is Parkour';
SELECT GoalId FROM WorkoutGoal WHERE WorkoutId ='12';
SELECT Name FROM Goal WHERE GoalId = '3' OR GoalId ='8' OR GoalId = '15';



