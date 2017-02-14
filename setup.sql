/* Tyrus Malmstrom :: CS430 --> Database Managment Systems :: Homework 2 */
/* Script that will setup all the tables required from the ER Diagram */

-- Good Etique --

\echo '\nDropping schema if it already exists.'

DROP SCHEMA IF EXISTS thisMusicProduction CASCADE;

\echo '\nDropping tables if they exist.'

DROP TABLE IF EXISTS thisMusicProduction.Musicians  CASCADE;
DROP TABLE IF EXISTS thisMusicProduction.Instrument CASCADE;
DROP TABLE IF EXISTS thisMusicProduction.Album      CASCADE;
DROP TABLE IF EXISTS thisMusicProduction.Songs      CASCADE;
DROP TABLE IF EXISTS thisMusicProduction.Place      CASCADE;
DROP TABLE IF EXISTS thisMusicProduction.Telephone  CASCADE;

-----------------------------------------------

\echo '\nCreating schema \'thisMusicProduction\' in which all my relational tables will reside.'

-- Creating the Schema in which all my relational tables will live:
CREATE SCHEMA thisMusicProduction;

\echo '\nCreating Musicians table.'

-- Creating the Musicians table:
CREATE TABLE thisMusicProduction.Musicians(

    ssn  varchar (11) PRIMARY KEY,
    name varchar (15)
);

\echo '\nInserting values into Musicians table.'

-- Insterting values into the Musicians
INSERT INTO thisMusicProduction.Musicians(
        ssn,
        name
)
VALUES
('147-45-4789','John'),
('256-69-7858', 'Smith'),
('123-45-6789','Tyrus'),
('789-45-6123','Bob'),
('159-52-1563','deadmau5');

------------------------------------------------------

-----------------------------------------------------

\echo '\nCreating Instrument table.'

-- Creating the instrument table:
CREATE TABLE thisMusicProduction.Instrument(

    instrid integer PRIMARY KEY,
    dname varchar(15),
    key   varchar(15)

);

\echo '\nInserting values into Instrument table.'

-- Inserting values into the Instruments table:
INSERT INTO thisMusicProduction.instrument(
    instrid,
    dname,
    key
)
VALUES
(1,'Violin','C#'),
(2,'Piano', 'A Minor'),
(3,'Guitar', 'G'),
(4,'Electronic DAW','All keys'),
(5,'Harmonica','A Major');

--------------------------------------------------

--------------------------------------------------

\echo '\nCreating Album table.  Also including the \"Producer\" relationship with the \"Musicians\" table'.

-- Creating the Album table:
CREATE TABLE thisMusicProduction.Album(

    albumIdentifier INTEGER PRIMARY KEY,
    copyrightDate   DATE NOT NULL,
    speed           INTERVAL MINUTE,
    title           varchar(25),
    ssn             varchar(11) NOT NULL REFERENCES thisMusicProduction.Musicians( ssn ) ON DELETE CASCADE

);

\echo '\nInserting values into Album table.'

-- Inserting values for the Album table:
INSERT INTO thisMusicProduction.Album(
    albumIdentifier,
    copyrightDate,
    speed,
    title,
    ssn
)
VALUES
( 1,'2010-07-29','10:30','For Lack of a Better Name','159-52-1563' ),
( 2,'2008-04-29','5:00', 'While(1<2)',               '159-52-1563' ),
( 3,'2009-08-29','6:50', 'Random Ablum Title',       '159-52-1563' ),
( 4,'2016-06-29','2:00', '>Album Title Goes Here<',  '159-52-1563' ),
( 5,'2007-05-29','8:30', 'W:/2016 Ablum',            '159-52-1563' );

-- SELECT * FROM thisMusicProduction.Album;

-------------------------------------------------------

-------------------------------------------------------

\echo '\nCreating Songs table. Also including the \"Appears\" relationship with the Album table.'

-- Creating the Songs table:
CREATE TABLE thisMusicProduction.Songs(

    songId integer PRIMARY KEY,
    title  varchar(30),
    suthor varchar(10),
    albumIdentifier INTEGER NOT NULL REFERENCES thisMusicProduction.Album( albumIdentifier ) ON DELETE CASCADE

);

\echo '\nInserting values into Songs table.'

-- Inserting values for the Songs table:
INSERT INTO thisMusicProduction.Songs(
    songId,
    title,
    suthor,
    albumIdentifier
)
VALUES
(1,'Strobe','deadmau5'               , 1),
(2,'My Pet Coelacanth','deadmau5'    , 2),
(3,'I Remeber ft. Kaskade','deadmau5', 3),
(4,'The Vedlt','deadmau5'            , 4),
(5,'4ware','deadmau5'                , 5);

-- SELECT * FROM thisMusicProduction.Songs;

-------------------------------------------------

--------------------------------------------------

\echo '\nCreating Place table.'

-- Creating Place table:
CREATE TABLE thisMusicProduction.Place(

    address varchar(45) PRIMARY KEY

);

\echo '\nInserting values into Place table.'

-- Inserting values for the Places table;
INSERT INTO thisMusicProduction.Place(
    address
)
VALUES
('3140. Ontario drive'),
('5148. 7 Panagioti Gyanapolou'),
('2250 W. South Drive'),
('1337 Leet Drive'),
('7331 A. This address is cool');

------------------------------------------------

--------------------------------------------------

\echo '\nCreating Telephone table.'

-- Creating Telephone table:
CREATE TABLE thisMusicProduction.Telephone(
    phone_no TEXT UNIQUE NOT NULL
);

\echo '\nInserting values into Telephone table.'

INSERT INTO thisMusicProduction.Telephone(
    phone_no
)
VALUES
('303-653-5478'),
('654-251-4789'),
('125-458-7963'),
('111-454-7888'),
('111-222-3334');

--------------------------------------------------------

\echo '\nNow, creating and setting up the relational tables between entities. Some may be many-to-many while others 1-to-many.\n'

-- Identifiying relationships (tables):

-- Creating the relationship talbe between Musicians and Instruments:
-- This is a *m*any to *m*any relationship --> m:m
-- Introducing foreign key constraints:

\echo '\nCreating Perform table: m:m'

CREATE TABLE thisMusicProduction.Perform(

    ssn varchar(11) REFERENCES thisMusicProduction.Musicians(ssn) ON UPDATE CASCADE, -- update automatically if upddated in referenced / parent table.
    songId integer  REFERENCES thisMusicProduction.Songs(songId) ON UPDATE CASCADE,
    PRIMARY KEY(ssn,songId)

);

\echo '\nInserting values into Perfom table. Values are *dependent* on values from other previously defined tables. Specifically Musicians and Songs.'

INSERT INTO thisMusicProduction.Perform(
    ssn,
    songId
)
Values
('147-45-4789',1),
('256-69-7858',3),
('123-45-6789',2),
('789-45-6123',5),
('159-52-1563',4);

------------~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~-----------------

-- Creating the relationship talbe between Musicians and Instruments:
-- This is a *m*any to *m*any relationship --> m:m
-- Introducing foreign key constraints:\

\echo 'Creating Plays table: m:m'

CREATE TABLE thisMusicProduction.Plays(

    ssn varchar(11) REFERENCES thisMusicProduction.Musicians(ssn) ON UPDATE CASCADE,
    instrid integer REFERENCES thisMusicProduction.Instrument(instrid) ON UPDATE CASCADE,
    PRIMARY KEY(ssn,instrid)

);

\echo '\nInserting values into Plays table. Values are *dependent* on values from other previously defined tables. Specifically  Musicians and Instrument.'

INSERT INTO thisMusicProduction.Plays(
    ssn,
    instrid
)
VALUES
('159-52-1563',2),
('123-45-6789',4),
('256-69-7858',1),
('789-45-6123',3),
('147-45-4789',5);

-- SELECT COUNT(*) FROM thisMusicProduction.Plays;

-------------------------------------------------------

\echo '\nCreating the \"Home\" table for the \"Place\" and \"Telephone table relationship\".'

CREATE TABLE thisMusicProduction.Home(

    address varchar(45) REFERENCES thisMusicProduction.Place( address ) ON UPDATE CASCADE,
    phone_no TEXT UNIQUE NOT NULL REFERENCES thisMusicProduction.Telephone( phone_no ) ON UPDATE CASCADE,
    PRIMARY KEY( address )

);

\echo '\nInserting values into Home table. Values are *dependent* on values from other previously defined tables. Specifically  \"Place\" and \"Telephone\".'

INSERT INTO thisMusicProduction.Home(
    address,
    phone_no
)
VALUES
('3140. Ontario drive',          '303-653-5478'),
('5148. 7 Panagioti Gyanapolou','654-251-4789'),
('2250 W. South Drive',         '125-458-7963'),
('1337 Leet Drive',              '111-454-7888'),
('7331 A. This address is cool','111-222-3334');

-- SELECT * FROM thisMusicProduction.Home;

-----------------------------------------------------------


\echo '\nCreating the \"Lives\" relationship bewteen the two tables \"Musicians\" and the aggregation of \"Home\" entity relationship set.'

CREATE TABLE thisMusicProduction.Lives(

    ssn varchar(11) REFERENCES thisMusicProduction.Musicians(ssn) ON UPDATE CASCADE,
    address varchar(45) REFERENCES thisMusicProduction.Home( address ) ON UPDATE CASCADE,
    PRIMARY KEY( ssn, address )

);

\echo '\nInserting values into \"Lives\" table. Values are *dependent* on values from other previously defined tables. Specifically  \"Musicians\" and the aggregation of \"Home\" entity relationship set.'

INSERT INTO thisMusicProduction.Lives(

    ssn,
    address

)
Values
('147-45-4789','2250 W. South Drive'),
('256-69-7858', '1337 Leet Drive'),
('123-45-6789','5148. 7 Panagioti Gyanapolou'),
('789-45-6123','7331 A. This address is cool'),
('159-52-1563','3140. Ontario drive');

-- SELECT * FROM thisMusicProduction.Lives;

-- Show all list of relations in PostgreSQL:
\dt thisMusicProduction.*;

-- done.