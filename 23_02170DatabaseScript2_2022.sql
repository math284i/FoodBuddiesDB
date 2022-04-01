# It must contain:
# (1) the queries made (as in section 7)
# (2) the delete/update statements used to change the tables (as in section 8), and
# (3) the statements used to create and apply functions, procedures, triggers, and events (as in section 9)
USE FoodBuddies;

#Finding the average score of all restaurants with an average score over 6
SELECT RestaurantName,AVG(Score) AS Average FROM Restaurant NATURAL JOIN Rating GROUP BY RestaurantName  HAVING AVG(Score) > 6 ORDER BY Average DESC;

#Showing the names and scores of everyone who has rated a restaurant
SELECT x.Critic,x.Score,RestaurantName FROM Restaurant NATURAL JOIN (
SELECT CONCAT(FirstName, ' ', LastName) AS Critic,Score,RestaurantID FROM Users NATURAL JOIN Rating
) AS x;

#Showing everyone that likes pizza
SELECT FirstName,LastName,FoodName FROM Users NATURAL JOIN Likes WHERE FoodName = 'Pizza';

#Showing everybody going to an event at a restaurant owned by the Mafia with the soonest event first
SELECT x.Attendee,x.EventName,RestaurantName,Country,ZipCode,CONCAT(StreetName, ' ', StreetNr) AS Address,x.Dato FROM Restaurant NATURAL JOIN Brand NATURAL JOIN
(SELECT CONCAT(FirstName, ' ', LastName) As Attendee,EventName,RestaurantID,Dato FROM Users NATURAL JOIN Attendee NATURAL JOIN Feast NATURAL JOIN TimeSlot
) AS x WHERE BrandName = 'Mafia' ORDER BY x.Dato;