CREATE DATABASE OnlineBidding
use OnlineBidding

--Vai tro cua member
create table Role(
roleID int PRIMARY KEY IDENTITY(1,1),
roleName nvarchar(255) not null unique,
description TEXT not null
);

--Account
create table Account(
accountID nvarchar(255) PRIMARY KEY ,
password nvarchar(255) not null,
fullName nvarchar(255) not null,
email NVARCHAR(255) unique NOT NULL,
roleID int not null,
foreign key (roleID) references Role(roleID),
);

--Blog 
create table Blog(
blogID int PRIMARY KEY IDENTITY(1,1),
title nvarchar(255) not null,
description TEXT  not null
);

--Account chiu trach nhiem blog
create table Account_Blog(
blogID int not null IDENTITY(1,1),
accountID nvarchar(255) not null unique,
PRIMARY KEY (accountID, blogID),
    FOREIGN KEY (accountID) REFERENCES Account(accountID),
    FOREIGN KEY (blogID) REFERENCES Blog(blogID)
);

--phan loai
create table Category(
categoryID int PRIMARY KEY IDENTITY(1,1),
categoryType nvarchar(255) not null
);


--giay chung nhan cua trang suc
create table Certification(
certificateID int PRIMARY KEY IDENTITY(1,1),
certificateURL nvarchar(255) not null
);

--Chat lieu trang suc
create table Material(
materialID int PRIMARY KEY IDENTITY(1,1),
materialName nvarchar(255) not null,
price float not null check (price > 0)
);

--Trang suc
create table Jewelry(
jewelryID int PRIMARY KEY IDENTITY(1,1),
certificateID int not null unique,
name nvarchar(255) not null,
productCode nvarchar(255) not null unique,
estimatePrice float check (estimatePrice > 0),
description nvarchar(255) not null,
size nvarchar(100) not null,
condition nvarchar(255) not null,
FOREIGN KEY (certificateID) references Certification(certificateID)
);

--Hinh anh
CREATE TABLE Image (
    imageID int PRIMARY KEY IDENTITY(1,1),
    jewelryID int NOT NULL unique,
    imageURL nvarchar(255) NOT NULL,
    FOREIGN KEY (jewelryID) REFERENCES Jewelry(jewelryID)
);

--Phan loai trang suc
create table Jewelry_Category(
jewelryID int not null IDENTITY(1,1),
categoryID int not null unique,
sex nvarchar(255) not null
PRIMARY KEY (jewelryID, categoryID),
    FOREIGN KEY (jewelryID) REFERENCES Jewelry(JewelryID),
    FOREIGN KEY (categoryID) REFERENCES Category(categoryID)
);

--Chat lieu trang suc
create table Jewelry_Material(
jewelryID int not null IDENTITY(1,1),
materialID int not null unique,
quantity nvarchar(255) not null,
PRIMARY KEY (jewelryID, materialID),
    FOREIGN KEY (jewelryID) REFERENCES Jewelry(jewelryID),
    FOREIGN KEY (jewelryID) REFERENCES Material(materialID)
);

--phien dau gia
create table BID(
bidID int PRIMARY KEY IDENTITY(1,1),
jewelryID int not null unique,
startPrice float not null check (startPrice >= 0),
currentPrice float not null check (currentPrice >= 0 ),
step float not null check (Step >= 0 ),
status nvarchar(255) not null,
startDate date not null,
endDate date not null,
FOREIGN KEY (jewelryID) references Jewelry(jewelryID)
);

--Thanh vien
create table Member(
memberID nvarchar(255) PRIMARY KEY,
accountID nvarchar(255) not null unique,
fullName nvarchar(255) not null,
phone nvarchar(255),
address nvarchar(255),
balance float check (balance >= 0),
email NVARCHAR(255) NOT NULL
FOREIGN KEY (accountID) references Account(accountID)
);

--Yeu cau dau gia
create table Request(
requestID int PRIMARY KEY IDENTITY(1,1),
bidID int not null unique,
jewelryID int not null unique,
requestDate date not null,
FOREIGN KEY (bidID) references BID(bidID),
FOREIGN KEY (jewelryID) references Jewelry(jewelryID)
);

--Thong tin ve yeu cau
create table Member_Request_Sell(
requestID int not null IDENTITY(1,1),
memberID nvarchar(255) not null,
status nvarchar(255) not null,
PRIMARY KEY (requestID, memberID),
    FOREIGN KEY (requestID) REFERENCES Request(requestID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID)
);

--Phi giao dich
create table Fee(
feeID int PRIMARY KEY IDENTITY(1,1),
memberID nvarchar(255) not null unique,
amount float not null check (amount >= 0),
FOREIGN KEY (memberID) references Member(memberID)
);

--Thanh toan
create table Payment(
paymentID int PRIMARY KEY IDENTITY(1,1),
bidID int not null unique,
memberID nvarchar(255) not null unique,
date date not null ,
amountPaid float not null check (amountPaid >= 0),
FOREIGN KEY (bidID) references BID(bidID),
FOREIGN KEY (memberID) references Member(memberID)
);

--xem lich su va thong tin trong phien dau gia 
create table Detail_BID(
detailID int PRIMARY KEY IDENTITY(1,1),
bidID int not null unique,
time datetime not null,
bidPrice float not null check (bidPrice > 0),
FOREIGN KEY (bidID) references BID(bidID),
);

--Thong tin cua thanh vien tham gia dau gia
CREATE TABLE Member_BID (
    detailID INT NOT NULL unique,
    memberID NVARCHAR(255) NOT NULL,
    time DATETIME NOT NULL,
    startPrice FLOAT NOT NULL CHECK (startPrice > 0),
    PRIMARY KEY (detailID,memberID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID),
    FOREIGN KEY (detailID) REFERENCES Detail_BID(detailID)
);

--Trang suc nguoi dung yeu cau dau gia
create table Member_Jewelry(
memberID nvarchar(255) not null unique,
jewelryID int not null IDENTITY(1,1),
PRIMARY KEY (memberID,jewelryID),
FOREIGN KEY (memberID) references Member(memberID),
FOREIGN KEY (jewelryID) references Jewelry(jewelryID)
);









--trigger add account vo member

CREATE TRIGGER after_account_insert
ON Account
AFTER INSERT
AS
BEGIN
    INSERT INTO Member (memberID, accountID, fullName, phone, address, balance,email)
    SELECT accountID, accountID, fullName, '', '', 0, email
    FROM inserted;
END;





--Lenh delete db
use master go
alter database OnlineBidding set single_user with rollback immediate
drop database OnlineBidding



update Member set phone = 0902590349 where accountID = 'admin'

select * from Member

SET IDENTITY_INSERT Category ON;
INSERT INTO Category (categoryID, categoryType) VALUES
('1', 'Necklaces'),
('2', 'Rings'),
('3', 'Bracelets'),
('4', 'Earrings'),
('5', 'Watches'),
('6', 'Pendants'),
('7', 'Brooches'),
('8', 'Anklets'),
('9', 'Charms'),
('10', 'Sets');

SET IDENTITY_INSERT Role on;
INSERT INTO Role (roleID, roleName,description) VALUES
( '1', 'Admin','Manage'),
( '2','Staff','Takecare'),
( '3', 'Member', 'See')

select * from Account
Insert into Account(accountID,password,fullName,email,roleID) values('quan','123','Quan Tran Member','quantdm2510@fpt.edu.vn',3)