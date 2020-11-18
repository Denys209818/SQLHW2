CREATE DATABASE BookShop

USE BookShop

CREATE TABLE BookAuthor (
Id INT NOT NULL IDENTITY PRIMARY KEY,
bookId INT NOT NULL FOREIGN KEY (bookId) REFERENCES Book(Id),
AuthorId INT NOT NULL FOREIGN KEY (AuthorId) REFERENCES Author(Id)
)

CREATE TABLE Author (
Id INT IDENTITY PRIMARY KEY NOT NULL,
Name nvarchar(MAX) NOT NULL CHECK(LEN(Name)>0),
[Address] nvarchar(MAX) CHECK(LEN([Address]) > 0)
)

CREATE TABLE Book (
Id INT NOT NULL IDENTITY PRIMARY KEY,
Name nvarchar(MAX) NOT NULL CHECK(LEN(Name) > 0),
Description nvarchar(MAX) NOT NULL CHECK(LEN(Description) > 0)
)

CREATE TABLE BookForSale ( -- книга для продажу 
Id INT NOT NULL PRIMARY KEY,
Price money NOT NULL CHECK(Price > 0),
[Date] date NOT NULL DEFAULT GETDATE(),
Amount INT NOT NULL CHECK(Amount >= 0),
CONSTRAINT FK_BOOK_ID FOREIGN KEY (Id) REFERENCES Book(Id)
)

INSERT INTO Book (Name, Description) VALUES ('Мандри Гулівера', 'Гулівер потравив до країни ліліпутів')
INSERT INTO Book (Name, Description) VALUES ('Мартин Боруля', 'Головний герой намагається відновити дворянство')
INSERT INTO Book (Name, Description) VALUES ('Сто тисяч', 'Розповідь про багатія, якого надурили і він втратив все і не зміг втерти носа найблищому ворогові')
INSERT INTO Book (Name, Description) VALUES ('Голодні Ігри', 'Турнір для усачників з різних округів де переможець лише один')
INSERT INTO Book (Name, Description) VALUES ('Чарлі і шоколадна фабрика', 'Віллі Вонка у пошуках наслідника фабрики проводить випробування для декількох дітей')

INSERT INTO Author (Name, Address) VALUES ('Джонатан Свіфт', 'Ірландія')
INSERT INTO Author (Name, Address) VALUES ('Іван Карпенко-Карий', 'Україна')
INSERT INTO Author (Name, Address) VALUES ('Сюзанна Коллінз', 'США')
INSERT INTO Author (Name, Address) VALUES ('Роальд Дал', 'Велика Британія')
INSERT INTO Author (Name, Address) VALUES ('Іван Карпенко-Карий 2', 'Україна')
INSERT INTO Author (Name, Address) VALUES ('Іван Карпенко-Карий 3', 'Україна')

INSERT INTO BookAuthor (bookId, AuthorId) VALUES (1,1)
INSERT INTO BookAuthor (bookId, AuthorId) VALUES (2,2)
INSERT INTO BookAuthor (bookId, AuthorId) VALUES (5,2)
INSERT INTO BookAuthor (bookId, AuthorId) VALUES (3,3)
INSERT INTO BookAuthor (bookId, AuthorId) VALUES (2,5)
INSERT INTO BookAuthor (bookId, AuthorId) VALUES (2,6)
INSERT INTO BookAuthor (bookId, AuthorId) VALUES (5,5)
INSERT INTO BookAuthor (bookId, AuthorId) VALUES (5,6)


INSERT INTO BookForSale (Id, Price, Amount) VALUES (2, 70, 100)
INSERT INTO BookForSale (Id, Price, Amount) VALUES (4, 140, 10)
INSERT INTO BookForSale (Id, Price, Amount) VALUES (5, 160, 13)

--	вивести всі книжки першого автора
SELECT b.Name, b.Description FROM Author as a
JOIN BookAuthor as ba on a.Id = ba.AuthorId
JOIN Book as b on b.Id = ba.bookId
WHERE a.Id = 1

--	вивести кількість книжок в продажі
SELECT COUNT(Id) as [кількість книжок в продажі] FROM BookForSale

--	вивести книжки в яких більше двох авторів
SELECT b.Name, b.Description FROM Book as b
JOIN BookAuthor as ba on ba.bookId = b.Id
JOIN Author as a on ba.AuthorId = a.Id
GROUP BY b.Id, b.Name, b.Description
HAVING COUNT(a.Id) > 2


--	вивести середню ціну книжки Івана Карпенка-Карого
SELECT CONVERT(nvarchar,AVG(bfs.Price)) + '.грн' as [Середня ціна ни книжки Івана Карпенка-Карого] FROM BookForSale as bfs
JOIN Book as b on  b.Id = bfs.Id
JOIN BookAuthor as ba on ba.bookId = b.Id
JOIN Author as a on a.Id = ba.AuthorId
WHERE a.Name = 'Іван Карпенко-Карий'


--	вивести авторів книжки "Мартин Боруля"
SELECT a.Name, a.Address FROM Book as b
JOIN BookAuthor as ba on ba.bookId = b.Id
JOIN Author as a on a.Id = ba.AuthorId
WHERE b.Name = 'Мартин Боруля'
