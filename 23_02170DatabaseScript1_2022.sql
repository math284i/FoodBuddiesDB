CREATE DATABASE FoodBuddies;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Theme;
DROP TABLE IF EXISTS Feast;
DROP TABLE IF EXISTS TimeSlot;
DROP TABLE IF EXISTS Friends;
DROP TABLE IF EXISTS Attendee;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Rating;
DROP TABLE IF EXISTS Restaurant;
DROP TABLE IF EXISTS Menu;
DROP TABLE IF EXISTS Brand;
DROP TABLE IF EXISTS Likes;
DROP TABLE IF EXISTS FoodType;
DROP TABLE IF EXISTS Describes;
DROP TABLE IF EXISTS Dish;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE Brand
	(BrandID		VARCHAR(5),
    BrandName		VARCHAR(20),
    PRIMARY KEY(BrandID)
	);

CREATE TABLE Users
	(UserID			VARCHAR(5),
    FirstName		VARCHAR(20),
    LastName		VARCHAR(20),
    Country			VARCHAR(20),
    ZipCode			INT(10),
    PRIMARY KEY(UserID)
	);
    
    CREATE TABLE TimeSlot
	(TimeSlotID 	VARCHAR(5),
	 Dato			DATE,
	 StartTime		TIME,
	 EndTime		TIME,
	 PRIMARY KEY(TimeSlotID, DayCode, StartTime)
	);
    
    CREATE TABLE Restaurant
	(RestaurantID	VARCHAR(5),
    BrandID			VARCHAR(5) NOT NULL,
    AverageRating	DECIMAL(3,1),
    RestaurantName	VARCHAR(20),
    Country			VARCHAR(20),
    ZipCode			INT(10),
    StreetName		VARCHAR(40),
    StreetNr		VARCHAR(4),
    PRIMARY KEY(RestaurantID),
    FOREIGN KEY(BrandID) REFERENCES Brand(BrandID) ON DELETE CASCADE
	);
    
    CREATE TABLE Feast
	(FeastID		VARCHAR(5),
    TimeSlotID		VARCHAR(5) NOT NULL,
    RestaurantID	VARCHAR(5) NOT NULL,
    EventName		VARCHAR(20),
    PRIMARY KEY(FeastID),
    FOREIGN KEY(TimeSlotID) REFERENCES TimeSlot(TimeSlotID) ON DELETE CASCADE,
    FOREIGN KEY(RestaurantID) REFERENCES Restaurant(RestaurantID) ON DELETE CASCADE
	);
    
    CREATE TABLE Menu
	(MenuID			VARCHAR(5),
    RestaurantID	VARCHAR(5),
    MenuName		VARCHAR(20),
    PRIMARY KEY(MenuID),
    FOREIGN KEY(RestaurantID) REFERENCES Restaurant(RestaurantID) ON DELETE SET NULL
	);
    
    CREATE TABLE Friends
	(UserID			VARCHAR(5),
    FriendID		VARCHAR(5),
    PRIMARY KEY(UserID,FriendID),
    FOREIGN KEY(UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY(FriendID) REFERENCES Users(UserID) ON DELETE CASCADE
	);
    
    CREATE TABLE Likes
	(UserID			VARCHAR(5),
    FoodName		VARCHAR(20),
    PRIMARY KEY(UserID,FoodName),
    FOREIGN KEY(UserID) REFERENCES Users(UserID) ON DELETE CASCADE
	);
    
    CREATE TABLE Rating
	(UserID			VARCHAR(5),
    RestaurantID	VARCHAR(5),
    Score			DECIMAL(2,0),
    PRIMARY KEY(UserID,RestaurantID),
    FOREIGN KEY(UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY(RestaurantID) REFERENCES Restaurant(RestaurantID) ON DELETE CASCADE
	);
    
    CREATE TABLE Dish
	(DishID			VARCHAR(5),
    MenuID			VARCHAR(5) NOT NULL,
    DishName		VARCHAR(20),
    DishPrice		DECIMAL(6,2),
    PRIMARY KEY(DishID),
    FOREIGN KEY(MenuID) REFERENCES Menu(MenuID) ON DELETE CASCADE
	);
    
    CREATE TABLE Describes
	(DishID			VARCHAR(5) NOT NULL,
    FoodName		VARCHAR(20) NOT NULL,
    PRIMARY KEY(DishID,FoodName),
    FOREIGN KEY(DishID) REFERENCES Dish(DishID) ON DELETE CASCADE
	);

CREATE TABLE Theme
	(FeastID		VARCHAR(5),
    FoodName		VARCHAR(40),
    PRIMARY KEY(FeastID,FoodName),
    FOREIGN KEY(FeastID) REFERENCES Feast(FeastID) ON DELETE CASCADE
	);
    
CREATE TABLE Attendee
	(FeastID		VARCHAR(5),
    UserID			VARCHAR(5),
    PRIMARY KEY(FeastID,UserID),
    FOREIGN KEY(FeastID) REFERENCES Feast(FeastID) ON DELETE CASCADE,
    FOREIGN KEY(UserID) REFERENCES Users(UserID) ON DELETE CASCADE
	);

CREATE VIEW FoodTypes AS SELECT FoodName FROM Theme NATURAL JOIN Likes NATURAL JOIN Describes GROUP BY FoodName;

CREATE VIEW Ratings AS SELECT CONCAT(FirstName, ' ', LastName) AS Critic,Score,RestaurantName FROM Users NATURAL JOIN Rating NATURAL JOIN Restaurant;

INSERT Brand VALUES
	('0', 'Mc Donald\'s'),
    ('1','Mediterraneo'),
	('2','Mafia'),
	('3', 'KFC');
    
INSERT Users VALUES
    ('0','Anders','Keller Poulsen','Denmark','2750'),
    ('1','Mathias','Rerup-Dyberg','Denmark','3500'),
    ('2','Markus','Jegstrup','Denmark','3500'),
    ('3','Rasmus','Højmark Fischer','Denmark','2800'),
    ('4','Alexander','Thomsen Skovsende','Denmark','3500'),
    ('5','Mario','Mario Bros','Italy','2500'),
    ('6','Luigi','Mario Bros','Italy','2500');

INSERT TimeSlot VALUES
	('A','2022-04-07','17:00','19:00'),
	('B','2022-04-08','19:00','24:00'),
	('C','2022-04-09','8:00','11:00');

INSERT Restaurant VALUES
	('0','0','0','Maccen','Denmark','2820','Nybrovej','2'),
    ('1','0','0','il McDonald','Italy','53100','Via Fiorentina','122'),
    ('2','1','0','Mediterraneo','Denmark','3500','Ballerupvej','16'),
    ('3','3','0','KFC CPH ','Denmark','1550','Rådhuspladesen','55'),
    ('4','3','0','KFC FYN','Denmark','5220','Ejbygade','2'),
    ('5','3','0','KFC JYD','Denmark','8210','Blomstervej','2k'),
    ('6','2','0','La Sosta','2800','Carlshøjvej','49'),
    ('7','2','0','Roma','2760','Liljevangsvej','6'),
    ('8','2','0','Baba\'s Pizza','2400','Frederiksgade','4'),
    ('9','2','0','Bona Pizza','00186','Via del Portico d\'Ottavia','7'),
    ('10','2','0','Panta Pizza','53100','Via Pantaneto','80');

INSERT Feast VALUES
	('0','A','9','Pre-dinner wine tasting'),
    ('1','A','5','Kids eat for free with paying adult'),
    ('2','A','0','Burger and beer'),
    ('3','B','0','2 for 1 cheeseburgers'),
    ('4','B','1','2 for 1 cheeseburgers'),
    ('5','B','10','Traditional dinner'),
    ('6','C','3','Hangover brunch'),
    ('7','C','7','Weekendtilbud');
    
INSERT Menu VALUES
	('0','0','Breakfast'),
    ('1','0','All-day'),
    ('2','6','Lunch'),
    ('3','7','Lunch'),
    ('4','8','Lunch'),
    ('5','9','Lunch'),
    ('6','10','Lunch'),
    ('7','1','All-day'),
    ('8','2','Normal'),
    ('9','3','Normal'),
    ('10','4','Normal'),
    #It is on purpose that KFC JYD does not have a menu
    ('11','6','Normal'),
    ('12','7','Normal'),
    ('13','8','Normal'),
    ('14','9','Normal'),
    ('15','10','Normal'),
    ('16','9','Wine-card');

INSERT Friends VALUES
    ('0','5'),
    ('5','0'),
    ('2','3'),
    ('3','2'),
    ('1','4'),
    ('4','1'),
    ('1','2'),
    ('2','1');
    
INSERT Likes VALUES
    ('0','Italian'),
    ('0','Burger'),
    ('0','Chinese'),
    ('0','Fish'),
    ('1','Burger'),
    ('1','Chicken'),
    ('1','Pizza'),
    ('1','Fast Food'),
    ('1','Beer'),
    ('2','Italian'),
    ('2','Pizza'),
    ('2','Beer'),
    ('3','Italian'),
    ('3','Burger'),
    ('3','Fish'),
    ('4','Italian'),
    ('4','Pizza'),
    ('4','Wine'),
    ('5','Italian'),
    ('5','Fast Food'),
    ('5','Pizza'),
    ('5','Wine'),
    ('6','Vegetarian'),
    ('6','Italian'),
    ('6','Pizza'),
    ('6','Wine');
    
INSERT Rating VALUES
	('0','0','10'),
    ('0','3','3'),
    ('0','6','8'),
    ('0','7','6'),
    ('0','8','9'),
    ('1','0','10'),
    ('1','3','8'),
    ('1','4','8'),
    ('1','5','7'),
    ('1','6','8'),
    ('1','7','7'),
    ('2','0','4'),
    ('2','2','8'),
    ('2','3','1'),
    ('2','4','1'),
    ('2','5','1'),
    ('2','7','7'),
    ('3','0','6'),
    ('3','2','10'),
    ('3','6','5'),
    ('3','8','7'),
    ('4','0','3'),
    ('4','1','4'),
    ('4','2','7'),
    ('4','4','4'),
    ('4','5','1'),
    ('4','6','4'),
    ('4','8','5'),
    ('4','9','10'),
    ('4','10','9'),
    ('5','0','7'),
    ('5','1','9'),
    ('5','2','6'),
    ('5','3','4'),
    ('5','6','10'),
    ('5','7','9'),
    ('5','8','4'),
    ('5','9','6'),
    ('5','10','7'),
    ('6','1','3'),
    ('6','9','8'),
    ('6','10','9');
    
INSERT Dish VALUES
	('0','1','Cheeseburger','12'),
    ('1','1','Hamburger','10'),
    ('2','7','Cheeseburger','12'),
    ('3','7','McPizza','30'),
    
    
INSERT Describes VALUES

INSERT Theme VALUES
	('0','Appetizers'),
    ('0','Wine'),
    ('2','Fast food'),
    ('2','Drinks'),
    ('3','Burger'),
    ('4','Burger'),
    ('5','Italian'),
    ('5','Pizza'),
    ('5','Wine'),
    ('6', 'Brunch');

INSERT Attendee VALUES
	('0','4'),
    ('0','0'),
    ('0','3'),
    ('2','2'),
    ('2','1'),
    ('3','1'),
    ('5','5'),
    ('5','6'),
    ('5','4'),
    ('6','0'),
    ('7','1');
