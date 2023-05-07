CREATE DATABASE Spotify
USE Spotify

CREATE TABLE Artists(
Id int IDENTITY PRIMARY KEY,
[Name] nvarchar(35),
ListenerCount int
)
CREATE TABLE Albums(
Id int IDENTITY PRIMARY KEY,
[Name] nvarchar(35),
MusicCount int,
ArtistId int REFERENCES Artists(Id)
)

CREATE TABLE Musics(
Id int IDENTITY PRIMARY KEY,
[Name] nvarchar(35),
TotalSecondCount int,
AlbumId int REFERENCES Albums(Id)
)
SELECT * FROM Albums

----------1 Musics -in name-ni totalSecondunu artist name-ni album name-ni gosteren view
CREATE VIEW  MusicReport
AS
SELECT m.Name MusicName, m.TotalSecondCount TotalSecond,
ar.Name ArtistName,
al.Name AlbumName
FROM Musics  m
JOIN Albums al
ON m.AlbumId=al.Id
JOIN Artists ar
ON al.ArtistId=ar.Id
 SELECT * FROM MusicReport

 ---------2 Album adi ve hemin albumdaki mahni sayin gosteren view
 CREATE VIEW AlbumReport
 As
 SELECT Name AlbumName,MusicCount FROM Albums
 SELECT * FROM AlbumReport

 --------------3 ListenerCount-u  parametr kimi gonderilen  ListenerCount-dan boyuk olan ve Album adinda paramter olaraq gonderilen search  deyeri olan butun
 ----mahnilarin adini  ListenerCount-nu  ve Album adini gosteren Procedure 

 CREATE PROCEDURE MusicsListenerCountAlbumName @ListenerCount int,@AlbumName nvarchar(50)
 AS
 SELECT m.Name MusicName,
 ar.ListenerCount ,
 al.Name AlbumName
 FROM Musics m
 JOIN  Albums al
 ON m.AlbumId=al.Id
 JOIN Artists ar
 ON al.ArtistId=ar.Id
 WHERE ar.ListenerCount>@ListenerCount AND al.Name=@AlbumName
  
  EXEC dbo.MusicsListenerCountAlbumName 65,'Kamikaze'

  -----------4 her hansis view ve triger
--4.1 view

CREATE VIEW MusicByTotalsecondreport
AS
SELECT m.Name SongName, m.TotalSecondCount SongTime,
al.Name SongAlbum,
ar.Name ArtistName
FROM Musics m
JOIN Albums al
ON al.Id=m.AlbumId
JOIN Artists ar
ON ar.Id=al.ArtistId
WHERE m.TotalSecondCount BETWEEN 2 AND 4

SELECT *FROM MusicByTotalsecondreport ORDER BY (SongTime) desc

--4.2 trigger
 CREATE TRIGGER SelectMusicNameArtistNameAfterUpdateDelete
 ON Musics
 AFTER UPDATE,DELETE
 AS
 BEGIN 
 SELECT m.Name Songname,ar.Name ArtistName
 FROM Musics m
 JOIN Albums al
 ON m.AlbumId=al.Id
 JOIN Artists ar
 ON al.ArtistId=ar.Id
END

