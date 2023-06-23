
set termout on
prompt Building EX Insurance Company database. Please wait...
set pagesize 50

drop TABLE Address CASCADE CONSTRAINT PURGE;
drop TABLE Company CASCADE CONSTRAINT PURGE;
drop TABLE Employee CASCADE CONSTRAINT PURGE;
drop TABLE Customer CASCADE CONSTRAINT PURGE;
drop TABLE Policy CASCADE CONSTRAINT PURGE;
drop TABLE Payment CASCADE CONSTRAINT PURGE;
drop TABLE Claim CASCADE CONSTRAINT PURGE;
drop TABLE Claimant CASCADE CONSTRAINT PURGE;
drop TABLE Incident CASCADE CONSTRAINT PURGE;
drop TABLE Property CASCADE CONSTRAINT PURGE;
drop TABLE Payment_plan CASCADE CONSTRAINT PURGE;
drop TABLE Reserve CASCADE CONSTRAINT PURGE;



CREATE TABLE Address(address_id number(5) PRIMARY KEY,
	street_name varchar(45) ,
	state varchar(25) ,
	city varchar(20) ,
	zip_code number(5));

INSERT INTO Address values(23281,'1834 Post Road','Texas','San Marcos',78666);
INSERT INTO Address values(23282,'6 Pines Rd','Texas','San Marcos',78555);
INSERT INTO Address values(23283,'Acorn St','Texas','San Marcos',76663);
INSERT INTO Address values(23284,'Barnes Dr','Texas','San Marcos',71222);
INSERT INTO Address values(23285,'Buttercup St','Texas','San Marcos',73232);
INSERT INTO Address values(23286,'Canyon Rd','Texas','San Marcos',74324);
INSERT INTO Address values(23287,'Columbia St','Texas','Austin',54423);
INSERT INTO Address values(23288,'Comal St','Texas','Dallas',98989);
INSERT INTO Address values(23289,'County Rd','Texas','San Antonio',12132);
INSERT INTO Address values(23290,'Daisy St','Oregon','Portland',98773);
INSERT INTO Address values(23291,'Encino St','Washington','Seattle',13444);
INSERT INTO Address values(24532,'Cesar Chavez St','Austin','Texas',76542);
INSERT INTO Address values(25433,'Cedar Park','Austin','Texas',65554);
INSERT INTO Address values(25552,'Leander','Austin','Texas',78433);
INSERT INTO Address values(27622,'Churchill St','San Marcos','Texas',98822);

CREATE TABLE Company(name varchar(15) PRIMARY KEY,
	cphone number(10) ,
	no_of_branches number(5),
	no_of_employees number(7),
	address_id number(5) REFERENCES Address(address_id) ON DELETE CASCADE);

INSERT INTO Company values('EX Insurance',9887732334,100,5000,23281);


CREATE TABLE Employee(emp_id number(4) PRIMARY KEY,
	first_name varchar(35) ,
	last_name varchar(35) ,
	phone_emp number(10) ,
	type_of_employee varchar(20) ,
	address_id number(5) REFERENCES Address(address_id) ON q DELETE CASCADE,
	name varchar(15) REFERENCES Company(name) ON DELETE CASCADE);

INSERT INTO Employee values(1221,'Adam','Abhram',5123432222,'Agent',23282,'EX Insurance');
INSERT INTO Employee values(1222,'Adrian','Alen',5124346778,'Rater',23283,'EX Insurance');
INSERT INTO Employee values(1223,'Blake','Ball',5122323322,'Agent',23284,'EX Insurance');
INSERT INTO Employee values(1224,'Boris','Bell',7379933322,'Underwriter',23285,'EX Insurance');
INSERT INTO Employee values(1225,'Michael','James',2324433327,'Adujuster',23286,'EX Insurance');
INSERT INTO Employee values(1226,'Peter','Brading',7376885513,'Rater',23291,'EX Insurance');
INSERT INTO Employee values(1227,'Pete','Cheverton',8943422211,'Agent',24532,'EX Insurance');


CREATE TABLE Customer(customer_id number(5) PRIMARY KEY,
	first_name varchar(20),
	last_name varchar(20),
	phone_c number(10),
	c_type varchar(45),
	email varchar(30),
	dob DATE,
	age number(3),
	claim_id number(5),
	property_id number(5),
	policy_number number(10),
	address_id number(5) REFERENCES Address(address_id) ON DELETE CASCADE);


INSERT INTO Customer values(33223,'Ivor','Thompson',5129093322,'Individual','ivorthompson@gmail.com',TO_DATE('10/05/1998','mm/dd/yyyy'),23,23421,95950,6565532232,23287);
INSERT INTO Customer values(33443,'Harry','Brown',5135543211,'Individual','harryb@gmail.com',TO_DATE('01/01/1993','mm/dd/yyyy'),28,'',95951,7565655231,23288);
INSERT INTO Customer values(44222,'Benjamin','Guy',4324441199,'Individual','benjamin123@gmail.com',TO_DATE('02/23/1992','mm/dd/yyyy'),29,'',95952,1341214324,23289);
INSERT INTO Customer values(22445,'Laurence','Hendy',9874332111,'Individual','laurence33@gmail.com',TO_DATE('05/20/2000','mm/dd/yyyy'),21,98231,95953,9409394328,23290);
INSERT INTO Customer values(66553,'Jhon','Doe',4324551433,'Corporate','jhondoe@gmail.com',TO_DATE('07/19/1990','mm/dd/yyyy'),29,22332,95954,4353254322,23291);
INSERT INTO Customer values(23413,'Roland','Cotter',7379989313,'Individual','roland@gmail.com',TO_DATE('05/11/1994','mm/dd/yyyy'),27,76643,95344,2345254422,25552);
INSERT INTO Customer values(18721,'Henry','Russel',8981313331,'Individual','henry22@gmail.com',TO_DATE('02/14/1996','mm/dd/yyyy'),25,98212,95411,2653232988,27622);


CREATE TABLE Policy(policy_number number(10) PRIMARY KEY,
	deductible number(10),
	issue_date DATE,
	type varchar(30),
	coverages varchar(500),
	coverage_period varchar(45),
	premium float(10),
	payment_id number(5),
	customer_id number(10) REFERENCES Customer(customer_id) ON DELETE CASCADE,
	emp_id number(4) REFERENCES Employee(emp_id) ON DELETE CASCADE,
	name varchar(15) REFERENCES Company(name) ON DELETE CASCADE);

INSERT INTO Policy values(6565532232,5000,TO_DATE('03/03/2020','mm/dd/yyyy'),'home','personal property,electronics,personal liability,loss of use','03/03/2020 - 03/04/2021',700.00,29043,33223,1221,'EX Insurance');
INSERT INTO Policy values(7565655231,6000,TO_DATE('05/30/2020','mm/dd/yyyy'),'automobile','collosion,body injury,property damage,emergency road service','05/30/2020 - 05/31/2021',1000.00,29044,33443,1222,'EX Insurance');
INSERT INTO Policy values(1341214324,5000,TO_DATE('02/22/2021','mm/dd/yyyy'),'automobile','collosion,body injury,property damage,emergency road service','02/22/2021 - 02/23/2022',849.99,28223,44222,1223,'EX Insurance');
INSERT INTO Policy values(9409394328,5000,TO_DATE('04/12/2020','mm/dd/yyyy'),'home','personal property,electronics,personal liability,loss of use','04/12/2020 - 04/13/2021',500.00,20102,22445,1224,'EX Insurance');
INSERT INTO Policy values(4353254322,5000,TO_DATE('09/23/2021','mm/dd/yyyy'),'home','personal property,electronics,personal liability,loss of use','09/23/2021 - 09/24/2022',982.55,13232,66553,1225,'EX Insurance');
INSERT INTO Policy values(2345254422,9000,TO_DATE('01/01/2021','mm/dd/yyyy'),'home','personal property,electronics,personal liability,loss of use','01/01/2021 - 01/02/2022',400.20,15432,23413,1226,'EX Insurance');
INSERT INTO Policy values(2653232988,10000,TO_DATE('06/02/2021','mm/dd/yyyy'),'automobile','collosion,body injury,property damage,emergency road service,loss of use','06/02/2021 - 06/03/2022',784.45,16532,18721,1227,'EX Insurance');


CREATE TABLE Payment(payment_id number(5) PRIMARY KEY,
	payment_mode varchar(15),
	status varchar(10),
	payment_amt float(10),
	payment_date DATE,
	emp_id number(4) REFERENCES Employee(emp_id) ON DELETE CASCADE,
	customer_id number(10) REFERENCES Customer(customer_id) ON DELETE CASCADE,
	policy_number number(10) REFERENCES Policy(policy_number) ON DELETE CASCADE);

INSERT INTO	Payment values(29043,'online','success',700.00,TO_DATE('03/03/2020','mm/dd/yyyy'),1221,33223,6565532232);
INSERT INTO	Payment values(29044,'cheque','success',1000.00,TO_DATE('05/30/2020','mm/dd/yyyy'),1222,33443,1341214324);
INSERT INTO	Payment values(28223,'bank transfer','success',849.99,TO_DATE('02/22/2021','mm/dd/yyyy'),1224,22445,9409394328);
INSERT INTO	Payment values(20102,'online','success',500.00,TO_DATE('09/23/2021','mm/dd/yyyy'),1223,66553,4353254322);
INSERT INTO	Payment values(13232,'cheque','success',982.55,TO_DATE('12/01/2018','mm/dd/yyyy'),1225,44222,7565655231);
INSERT INTO Payment values(15432,'online','success',400.20,TO_DATE('01/01/2021','mm/dd/yyyy'),1226,23413,2345254422);
INSERT INTO Payment values(16532,'online','success',784.45,TO_DATE('06/02/2021','mm/dd/yyyy'),1227,18721,2653232988);


CREATE TABLE Claim(claim_id number(5) PRIMARY KEY,
	status varchar(20),
	amount number(10),
	payment_date DATE, 
	policy_number number(10) REFERENCES Policy(policy_number) ON DELETE CASCADE,
	payment_id number(5) REFERENCES Payment(payment_id) ON DELETE CASCADE,
	emp_id number(4) REFERENCES Employee(emp_id) ON DELETE CASCADE,
	customer_id number(10) REFERENCES Customer(customer_id) ON DELETE CASCADE);

INSERT INTO Claim values(23421,'settled',10000,TO_DATE('02/22/2021','mm/dd/yyyy'),6565532232,29043,1221,33223);
INSERT INTO Claim values(76643,'settled',10000,TO_DATE('12/23/2021','mm/dd/yyyy'),2345254422,15432,1226,23413);
INSERT INTO Claim values(98212,'settled',20000,TO_DATE('12/10/2021','mm/dd/yyyy'),2653232988,16532,1227,18721);
INSERT INTO Claim values(98231,'processing',20000,TO_DATE('04/10/2021','mm/dd/yyyy'),9409394328,29044,1224,22445);
INSERT INTO Claim values(22332,'settled',25000,TO_DATE('01/13/2021','mm/dd/yyyy'),4353254322,28223,1225,66553);


CREATE TABLE Claimant(claimant_id number(6) PRIMARY KEY,
	clname varchar(15),
	phone_num number(10),
	claim_id number(5) REFERENCES Claim(claim_id) ON DELETE CASCADE);

INSERT INTO Claimant values(438892,'Baker',7278833212,23421);
INSERT INTO Claimant values(438893,'Adams',8383223311,76643);
INSERT INTO Claimant values(438894,'Lopez',9832213313,98212);
INSERT INTO Claimant values(438895,'Jones',3432248811,98231);
INSERT INTO Claimant values(438896,'Smith',8743444253,22332);

CREATE TABLE Incident(report_id number(6) PRIMARY KEY,
	inc_date DATE,
	type varchar(30));

INSERT INTO	Incident values(322214,TO_DATE('02/23/2018','mm/dd/yyyy'),'Car accident');
INSERT INTO Incident values(323222,TO_DATE('03/14/2019','mm/dd/yyyy'),'Flood damage');
INSERT INTO	Incident values(543211,TO_DATE('05/10/2018','mm/dd/yyyy'),'Hurrican damage');
INSERT INTO	Incident values(987653,TO_DATE('09/12/2018','mm/dd/yyyy'),'Truck accident');
INSERT INTO Incident values(884332,TO_DATE('10/09/2021','mm/dd/yyyy'),'Car accident');


CREATE TABLE Property(property_id number(5) PRIMARY KEY,
	owner_name varchar(20),
	type_of_property varchar(30),
	accident varchar(4),
	report_id number(6) REFERENCES Incident(report_id) ON DELETE CASCADE,
	address_id number(5) REFERENCES Address(address_id) ON DELETE CASCADE,
	customer_id number(10) REFERENCES Customer(customer_id) ON DELETE CASCADE);

INSERT INTO Property values(95950,'Ivor','house',1,323222,23287,33223);
INSERT INTO Property values(95951,'Benjamin','house',1,543211,23289,44222);
INSERT INTO Property values(95952,'Laurence','automobile',1,322214,23290,22445);
INSERT INTO Property values(95953,'Jhon','house',0,'',23291,66553);
INSERT INTO Property values(95954,'Harry','automobile',0,'',23288,33443);
INSERT INTO Property values(95344,'Roland','Cotter',1,987653,25552,23413);
INSERT INTO Property values(95411,'Henry','Russel',1,884332,27622,18721);


CREATE TABLE Payment_plan(p_id number(6) PRIMARY KEY,
	ptype varchar(30),
	payment_id number(5) REFERENCES Payment(payment_id) ON DELETE CASCADE);

INSERT INTO Payment_plan values(432552,'online',29043);
INSERT INTO Payment_plan values(421877,'cheque',29044);
INSERT INTO Payment_plan values(414122,'bank transfer',28223);
INSERT INTO Payment_plan values(409212,'online',20102);
INSERT INTO Payment_plan values(487212,'cheque',13232);



CREATE TABLE Reserve(r_id number(6) PRIMARY KEY,
	reserve_amt number(10),
	claim_id number(5) REFERENCES Claim(claim_id) ON DELETE CASCADE,
	emp_id number(4) REFERENCES Employee(emp_id) ON DELETE CASCADE);

INSERT INTO Reserve values(986543,20000,23421,1221);
INSERT INTO Reserve values(865622,20000,76643,1226);
INSERT INTO Reserve values(134322,20000,98212,1227);
INSERT INTO Reserve values(987221,30000,98231,1224);
INSERT INTO Reserve values(873422,30000,22332,1225);


ALTER TABLE Customer ADD CONSTRAINT claim_id FOREIGN KEY(claim_id) REFERENCES Claim(claim_id) ON DELETE CASCADE;
ALTER TABLE Customer ADD CONSTRAINT property_id FOREIGN KEY(property_id) REFERENCES Property(property_id) ON DELETE CASCADE;
ALTER TABLE Customer ADD CONSTRAINT policy_number FOREIGN KEY(policy_number) REFERENCES Policy(policy_number) ON DELETE CASCADE;
ALTER TABLE Policy ADD CONSTRAINT payment_id FOREIGN KEY(payment_id) REFERENCES Payment(payment_id) ON DELETE CASCADE;

















