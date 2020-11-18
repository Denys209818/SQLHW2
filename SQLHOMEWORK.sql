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

CREATE TABLE BookForSale ( -- ����� ��� ������� 
Id INT NOT NULL PRIMARY KEY,
Price money NOT NULL CHECK(Price > 0),
[Date] date NOT NULL DEFAULT GETDATE(),
Amount INT NOT NULL CHECK(Amount >= 0),
CONSTRAINT FK_BOOK_ID FOREIGN KEY (Id) REFERENCES Book(Id)
)

INSERT INTO Book (Name, Description) VALUES ('������ �������', '������ �������� �� ����� ������')
INSERT INTO Book (Name, Description) VALUES ('������ ������', '�������� ����� ���������� �������� ����������')
INSERT INTO Book (Name, Description) VALUES ('��� �����', '�������� ��� ������, ����� �������� � �� ������� ��� � �� ��� ������ ���� ���������� �������')
INSERT INTO Book (Name, Description) VALUES ('������ ����', '����� ��� �������� � ����� ������ �� ���������� ���� ����')
INSERT INTO Book (Name, Description) VALUES ('���� � ��������� �������', '³�� ����� � ������� ��������� ������� ��������� ������������ ��� �������� ����')

INSERT INTO Author (Name, Address) VALUES ('�������� ����', '�������')
INSERT INTO Author (Name, Address) VALUES ('���� ��������-�����', '������')
INSERT INTO Author (Name, Address) VALUES ('������� ������', '���')
INSERT INTO Author (Name, Address) VALUES ('������ ���', '������ �������')
INSERT INTO Author (Name, Address) VALUES ('���� ��������-����� 2', '������')
INSERT INTO Author (Name, Address) VALUES ('���� ��������-����� 3', '������')

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

--	������� �� ������ ������� ������
SELECT b.Name, b.Description FROM Author as a
JOIN BookAuthor as ba on a.Id = ba.AuthorId
JOIN Book as b on b.Id = ba.bookId
WHERE a.Id = 1

--	������� ������� ������ � ������
SELECT COUNT(Id) as [������� ������ � ������] FROM BookForSale

--	������� ������ � ���� ����� ���� ������
SELECT b.Name, b.Description FROM Book as b
JOIN BookAuthor as ba on ba.bookId = b.Id
JOIN Author as a on ba.AuthorId = a.Id
GROUP BY b.Id, b.Name, b.Description
HAVING COUNT(a.Id) > 2


--	������� ������� ���� ������ ����� ��������-������
SELECT CONVERT(nvarchar,AVG(bfs.Price)) + '.���' as [������� ���� �� ������ ����� ��������-������] FROM BookForSale as bfs
JOIN Book as b on  b.Id = bfs.Id
JOIN BookAuthor as ba on ba.bookId = b.Id
JOIN Author as a on a.Id = ba.AuthorId
WHERE a.Name = '���� ��������-�����'


--	������� ������ ������ "������ ������"
SELECT a.Name, a.Address FROM Book as b
JOIN BookAuthor as ba on ba.bookId = b.Id
JOIN Author as a on a.Id = ba.AuthorId
WHERE b.Name = '������ ������'
