drop database if exists MovieCatalogue;

create database MovieCatalogue;

use MovieCatalogue;

create table Movie (
	MovieID varchar(50) primary key,
    GenreID varchar(50) not null,
    DirectorID varchar(50),
    RatingID varchar(50),
    Title varchar(128) not null,
    ReleaseDate varchar(20),
    foreign key fk_Genre_GenreID (GenreID)
		references Genre(GenreID),
	foreign key fk_Director_DirectorID (DirectorID)
		references Director(DirectorID),
	foreign key fk_Rating_RatingID (RatingID)
		references Rating(RatingID)
);

create table Genre (
    GenreID varchar(50) primary key,
    GenreName varchar(30) not null
);

create table Director (
    DirectorID varchar(50) primary key,
    FirstName varchar(30) not null,
    LastName varchar(30) not null,
    BirthDate varchar(20)
);

create table Rating (
	RatingID varchar(50) primary key,
    RatingName char(5) not null
);

create table Actor (
	ActorID varchar(50) primary key,
    FirstName varchar(30) not null,
    LastName varchar(30) not null,
    BirthDate varchar(20)
);

create table CastMembers (
	CastMemberID varchar(50) primary key,
    ActorID varchar(50) not null,
    MovieID varchar(50) not null,
    Role varchar(50) not null,
    foreign key fk_Actor_ActorID (ActorID)
		references Actor(ActorID),
	foreign key fk_Movie_MovieID (MovieID)
		references Movie(MovieID)
);