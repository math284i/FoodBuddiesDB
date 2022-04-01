USE FoodBuddies;

#6
SELECT * FROM Restaurant;

#7
#Finding the average score of all restaurants with an average score over 6
SELECT RestaurantName,AVG(Score) AS Average FROM Restaurant NATURAL JOIN Rating GROUP BY RestaurantName  HAVING AVG(Score) > 6 ORDER BY Average DESC;

#Showing the names and scores of everyone who has rated a restaurant
SELECT x.Critic,x.Score,RestaurantName FROM Restaurant NATURAL JOIN (
SELECT CONCAT(FirstName, ' ', LastName) AS Critic,Score,RestaurantID FROM Users NATURAL JOIN Rating
) AS x;

#Showing everyone that likes pizza
SELECT FirstName,LastName,FoodType FROM Users NATURAL JOIN Likes WHERE FoodType = 'Pizza';

#Showing everybody going to an event at a restaurant owned by the Mafia with the soonest event first
SELECT x.Attendee,x.EventName,RestaurantName,Country,ZipCode,CONCAT(StreetName, ' ', StreetNr) AS Address,x.Dato FROM Restaurant NATURAL JOIN Brand NATURAL JOIN
(SELECT CONCAT(FirstName, ' ', LastName) As Attendee,EventName,RestaurantID,Dato FROM Users NATURAL JOIN Attendee NATURAL JOIN Feast NATURAL JOIN TimeSlot
) AS x WHERE BrandName = 'McDonald\'s' ORDER BY x.Dato;

#8
DELETE FROM Users WHERE UserID='U6';
SELECT * FROM Users;

UPDATE Dish SET DishName = "Fiskefilet" WHERE DishID = 'D5';
SELECT * FROM Dish;

#9
#Function
DELIMITER //
CREATE FUNCTION CountUsersGoing (vEventName VARCHAR(40)) RETURNS INT
BEGIN
	DECLARE vAmountGoing INT;
    SELECT COUNT(UserID) INTO vAmountGoing FROM Feast NATURAL JOIN Attendee
    WHERE EventName = vEventName;
    RETURN vAmountGoing;
    END;//
DELIMITER ;

SELECT EventName, CountUsersGoing(EventName) AS Going FROM Feast;

DROP PROCEDURE AddRestaurant;

#Procedure
DELIMITER //
CREATE PROCEDURE AddRestaurant
	(IN vResID VARCHAR(5), IN vBrandID VARCHAR(5), IN vName VARCHAR(20), IN vCountry VARCHAR(20),
    IN vZIP VARCHAR(10), IN vStreetName VARCHAR(40), IN vStreetNr VARCHAR(4))
BEGIN
	INSERT Restaurant(RestaurantID,BrandID,AverageRating,RestaurantName,Country,ZipCode,StreetName,StreetNr) VALUES
	(vResID,vBrandID,NULL,vName,vCountry,vZIP,vStreetName,vStreetNr);
END//
DEMILITER ;

CALL AddRestaurant('Test','B0','Test','Test','Test','Test','Test');
SELECT * FROM Restaurant;

#Trigger
DELIMITER $$
CREATE TRIGGER Update_Avg_Rating
AFTER INSERT ON Rating FOR EACH ROW
BEGIN
  UPDATE Restaurant SET AverageRating = (SELECT 
    AVG(Score) FROM Rating WHERE RestaurantID = NEW.RestaurantID) 
    WHERE RestaurantID = NEW.RestaurantID;
END $$
DELIMITER ;