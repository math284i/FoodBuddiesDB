DROP DATABASE IF EXISTS FoodBuddies;
CREATE DATABASE FoodBuddies;
USE FoodBuddies;

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
    ZipCode			VARCHAR(10),
    PRIMARY KEY(UserID)
	);
    
    CREATE TABLE TimeSlot
	(TimeSlotID 	VARCHAR(5),
	 Dato			DATE,
	 StartTime		TIME,
	 EndTime		TIME,
	 PRIMARY KEY(TimeSlotID, Dato, StartTime)
	);
    
    CREATE TABLE Restaurant
	(RestaurantID	VARCHAR(5),
    BrandID			VARCHAR(5) NOT NULL,
    AverageRating	DECIMAL(3,1),
    RestaurantName	VARCHAR(20),
    Country			VARCHAR(20),
    ZipCode			VARCHAR(10),
    StreetName		VARCHAR(40),
    StreetNr		VARCHAR(4),
    PRIMARY KEY(RestaurantID),
    FOREIGN KEY(BrandID) REFERENCES Brand(BrandID) ON DELETE CASCADE
	);
    
    CREATE TABLE Feast
	(FeastID		VARCHAR(5),
    TimeSlotID		VARCHAR(5) NOT NULL,
    RestaurantID	VARCHAR(5) NOT NULL,
    EventName		VARCHAR(40),
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
    FoodType		VARCHAR(20),
    PRIMARY KEY(UserID,FoodType),
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
    DishName		VARCHAR(40),
    DishPrice		DECIMAL(6,2),
    PRIMARY KEY(DishID),
    FOREIGN KEY(MenuID) REFERENCES Menu(MenuID) ON DELETE CASCADE
	);
    
    CREATE TABLE Describes
	(DishID			VARCHAR(5) NOT NULL,
    FoodType		VARCHAR(20) NOT NULL,
    PRIMARY KEY(DishID,FoodType),
    FOREIGN KEY(DishID) REFERENCES Dish(DishID) ON DELETE CASCADE
	);

CREATE TABLE Theme
	(FeastID		VARCHAR(5),
    FoodType		VARCHAR(40),
    PRIMARY KEY(FeastID,FoodType),
    FOREIGN KEY(FeastID) REFERENCES Feast(FeastID) ON DELETE CASCADE
	);
    
CREATE TABLE Attendee
	(FeastID		VARCHAR(5),
    UserID			VARCHAR(5),
    PRIMARY KEY(FeastID,UserID),
    FOREIGN KEY(FeastID) REFERENCES Feast(FeastID) ON DELETE CASCADE,
    FOREIGN KEY(UserID) REFERENCES Users(UserID) ON DELETE CASCADE
	);

CREATE VIEW FoodTypes AS
SELECT FoodType FROM Theme 
UNION 
SELECT FoodType FROM Likes 
UNION 
SELECT FoodType FROM Describes 
GROUP BY FoodType;

INSERT Brand VALUES
	('B0', 'McDonald\'s'),
    ('B1','Mediterraneo'),
	('B2','Mafia'),
	('B3', 'KFC');
    
INSERT Users VALUES
    ('U0','Anders','Keller Poulsen','Denmark','2750'),
    ('U1','Mathias','Rerup-Dyberg','Denmark','3500'),
    ('U2','Markus','Jegstrup','Denmark','3500'),
    ('U3','Rasmus','Højmark Fischer','Denmark','2800'),
    ('U4','Alexander','Thomsen Skovsende','Denmark','3500'),
    ('U5','Mario','Mario Bros','Italy','2500'),
    ('U6','Luigi','Mario Bros','Italy','2500');

INSERT TimeSlot VALUES
	('A','2022-04-07','17:00','19:00'),
	('B','2022-04-08','19:00','24:00'),
	('C','2022-04-09','8:00','11:00');

INSERT Restaurant VALUES
	('R0','B0','0','Maccen','Denmark','2820','Nybrovej','2'),
    ('R1','B0','0','il McDonald','Italy','53100','Via Fiorentina','122'),
    ('R2','B1','0','Mediterraneo','Denmark','3500','Ballerupvej','16'),
    ('R3','B3','0','KFC CPH ','Denmark','1550','Rådhuspladesen','55'),
    ('R4','B3','0','KFC FYN','Denmark','5220','Ejbygade','2'),
    ('R5','B3','0','KFC JYD','Denmark','8210','Blomstervej','2k'),
    ('R6','B2','0','La Sosta','Denmark','2800','Carlshøjvej','49'),
    ('R7','B2','0','Roma','Denmark','2760','Liljevangsvej','6'),
    ('R8','B2','0','Baba\'s Pizza','Denmark','2400','Frederiksgade','4'),
    ('R9','B2','0','Bona Pizza','Italy','00186','Via del Portico d\'Ottavia','7'),
    ('R10','B2','0','Panta Pizza','Italy','53100','Via Pantaneto','80');

INSERT Feast VALUES
	('F0','A','R9','Pre-dinner wine tasting'),
    ('F1','A','R5','Kids eat for free with paying adult'),
    ('F2','A','R0','Burger and beer'),
    ('F3','B','R0','2 for 1 cheeseburgers'),
    ('F4','B','R1','2 for 1 cheeseburgers'),
    ('F5','B','R10','Traditional dinner'),
    ('F6','C','R3','Hangover brunch'),
    ('F7','C','R7','Weekendtilbud');
    
INSERT Menu VALUES
	('M0','R0','Breakfast'),
    ('M1','R0','All-Day'),
    ('M2','R6','Lunch'),
    ('M3','R7','Lunch'),
    ('M4','R8','Lunch'),
    ('M5','R9','Lunch'),
    ('M6','R10','Lunch'),
    ('M7','R1','All-Day'),
    ('M8','R2','All-Day'),
    ('M9','R3','All-Day'),
    ('M10','R4','All-Day'),
    #It is on purpose that KFC JYD does not have a menu
    ('M11','R6','All-Day'),
    ('M12','R7','All-Day'),
    ('M13','R8','All-Day'),
    ('M14','R9','All-Day'),
    ('M15','R10','All-Day'),
    ('M16','R9','Wine-card');

INSERT Friends VALUES
    ('U0','U5'),
    ('U5','U0'),
    ('U2','U3'),
    ('U3','U2'),
    ('U1','U4'),
    ('U4','U1'),
    ('U1','U2'),
    ('U2','U1');
    
INSERT Likes VALUES
    ('U0','Italian'),
    ('U0','Burger'),
    ('U0','Chinese'),
    ('U0','Fish'),
    ('U1','Burger'),
    ('U1','Chicken'),
    ('U1','Pizza'),
    ('U1','Fast Food'),
    ('U1','Beer'),
    ('U2','Italian'),
    ('U2','Pizza'),
    ('U2','Beer'),
    ('U3','Italian'),
    ('U3','Burger'),
    ('U3','Fish'),
    ('U4','Italian'),
    ('U4','Pizza'),
    ('U4','Wine'),
    ('U5','Italian'),
    ('U5','Fast Food'),
    ('U5','Pizza'),
    ('U5','Wine'),
    ('U6','Vegetarian'),
    ('U6','Italian'),
    ('U6','Pizza'),
    ('U6','Wine');
    
INSERT Rating VALUES
	('U0','R0','10'),
    ('U0','R3','3'),
    ('U0','R6','8'),
    ('U0','R7','6'),
    ('U0','R8','9'),
    ('U1','R0','10'),
    ('U1','R3','8'),
    ('U1','R4','8'),
    ('U1','R5','7'),
    ('U1','R6','8'),
    ('U1','R7','7'),
    ('U2','R0','4'),
    ('U2','R2','8'),
    ('U2','R3','1'),
    ('U2','R4','1'),
    ('U2','R5','1'),
    ('U2','R7','7'),
    ('U3','R0','6'),
    ('U3','R2','10'),
    ('U3','R6','5'),
    ('U3','R8','7'),
    ('U4','R0','3'),
    ('U4','R1','4'),
    ('U4','R2','7'),
    ('U4','R4','4'),
    ('U4','R5','1'),
    ('U4','R6','4'),
    ('U4','R8','5'),
    ('U4','R9','10'),
    ('U4','R10','9'),
    ('U5','R0','7'),
    ('U5','R1','9'),
    ('U5','R2','6'),
    ('U5','R3','4'),
    ('U5','R6','10'),
    ('U5','R7','9'),
    ('U5','R8','4'),
    ('U5','R9','6'),
    ('U5','R10','7'),
    ('U6','R1','3'),
    ('U6','R9','8'),
    ('U6','R10','9');
    
INSERT Dish VALUES
	('D0','M1','Cheeseburger','12'),
    ('D1','M1','Hamburger','10'),
    ('D2','M7','Cheeseburger','12'),
    ('D3','M7','McPizza','30'),
    ('D4','M9','Bucket','200'),
    ('D5','M9','Vegan fried "chicken"','100'),
    ('D6','M9','Chicken Wrap','70'),
    ('D7','M10','Bucket','180'),
    ('D8', 'M4','Bolognese Pizza','49'),
    ('D9','M13','Durum ekstra dressing','50'),
    ('D10','M13','Bolognese Pizza','70'),
    ('D11','M15','8 piece calamari','80'),
    ('D12','M15','Penne Arrabiata','100');
    
INSERT Describes VALUES
	('D0','Burger'),
    ('D1','Burger'),
    ('D2','Burger'),
    ('D3','Pizza'),
    ('D3','Fast Food'),
    ('D3','Italian'),
    ('D4','Chicken'),
    ('D5','Vegan'),
    ('D6','Chicken'),
    ('D7','Chicken'),
    ('D8','Pizza'),
    ('D9','Turkish'),
    ('D10','Pizza'),
    ('D11','Italian'),
    ('D12','Italian'),
    ('D12','Pasta');
    

INSERT Theme VALUES
	('F0','Appetizers'),
    ('F0','Wine'),
    ('F2','Fast food'),
    ('F2','Drinks'),
    ('F3','Burger'),
    ('F4','Burger'),
    ('F5','Italian'),
    ('F5','Pizza'),
    ('F5','Wine'),
    ('F6', 'Brunch');

INSERT Attendee VALUES
	('F0','U4'),
    ('F0','U0'),
    ('F0','U3'),
    ('F2','U2'),
    ('F2','U1'),
    ('F3','U1'),
    ('F5','U5'),
    ('F5','U6'),
    ('F5','U4'),
    ('F6','U0'),
    ('F7','U1');
