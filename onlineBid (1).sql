

CREATE DATABASE OnlineBidding
use OnlineBidding



--Vai tro cua member
create table Role(
roleID nvarchar(255) PRIMARY KEY,


);

--Role cua account
create table Account_Role(
accountID nvarchar(255) not null unique,
roleID nvarchar(255) not null,
PRIMARY KEY (accountID, roleID),
    FOREIGN KEY (accountID) REFERENCES Account(accountID),
    FOREIGN KEY (roleID) REFERENCES Role(roleID)
);

--Blog 
create table Blog(
blogID nvarchar(255) PRIMARY KEY,
title nvarchar(255) not null,
description nvarchar(255) not null
);

--Account chiu trach nhiem blog
create table Account_Blog(
blogID nvarchar(255) not null unique,
accountID nvarchar(255) not null unique,
PRIMARY KEY (accountID, blogID),
    FOREIGN KEY (accountID) REFERENCES Account(accountID),
    FOREIGN KEY (blogID) REFERENCES Blog(blogID)
);

--phan loai
create table Category(
categoryID nvarchar(255) PRIMARY KEY,
categoryType nvarchar(255) not null
);

--giay chung nhan cua trang suc
create table Certification(
certificateID nvarchar(255) PRIMARY KEY,
information nvarchar(255) not null
);

--Chat lieu trang suc
create table Material(
materialID nvarchar(255) PRIMARY KEY,
materialName nvarchar(255) not null
)

--Trang suc
create table Jewelry(
jewelryID nvarchar(255) PRIMARY KEY,
certificateID nvarchar(255) not null unique,
name nvarchar(255) not null,
productCode nvarchar(255) not null unique,
price int not null check (Price >= 0),
description nvarchar(255) not null,
size nvarchar(100) not null,
condition nvarchar(255) not null,
FOREIGN KEY (certificateID) references Certification(certificateID)
);

--Phan loai trang suc
create table Jewelry_Category(
jewelryID nvarchar(255) not null unique,
categoryID nvarchar(255) not null,
sex nvarchar(255) not null
PRIMARY KEY (jewelryID, categoryID),
    FOREIGN KEY (jewelryID) REFERENCES Jewelry(JewelryID),
    FOREIGN KEY (categoryID) REFERENCES Category(categoryID)
);

--Chat lieu trang suc
create table Jewelry_Material(
jewelryID nvarchar(255) not null unique,
materialID nvarchar(255) not null,
quantity nvarchar(255) not null,
PRIMARY KEY (jewelryID, materialID),
    FOREIGN KEY (jewelryID) REFERENCES Jewelry(jewelryID),
    FOREIGN KEY (jewelryID) REFERENCES Material(materialID)
);

--phien dau gia
create table BID(
bidID nvarchar(255) PRIMARY KEY,
jewelryID nvarchar(255) not null unique,
startPrice int not null check (startPrice >= 0),
currentPrice int not null check (currentPrice >= 0 ),
step int not null check (Step >= 0 ),
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
balance int check (balance >= 0),
email NVARCHAR(255) NOT NULL

FOREIGN KEY (accountID) references Account(accountID)
);

--Yeu cau dau gia
create table Request(
requestID nvarchar(255) PRIMARY KEY,
bidID nvarchar(255) not null unique,
jewelryID nvarchar(255) not null unique,
requestDate date not null,
FOREIGN KEY (bidID) references BID(bidID),
FOREIGN KEY (jewelryID) references Jewelry(jewelryID)
);

--Thong tin ve yeu cau
create table Member_Request(
requestID nvarchar(255) not null unique,
memberID nvarchar(255) not null unique,
status nvarchar(255) not null,
PRIMARY KEY (requestID, memberID),
    FOREIGN KEY (requestID) REFERENCES Request(requestID),
    FOREIGN KEY (memberID) REFERENCES Member(memberID)
);

--Phi giao dich
create table Fee(
feeID nvarchar(255) PRIMARY KEY,
memberID nvarchar(255) not null unique,
amount int not null check (amount >= 0),
FOREIGN KEY (memberID) references Member(memberID)
);

--Thanh toan
create table Payment(
paymentID nvarchar(255) PRIMARY KEY,
bidID nvarchar(255) not null unique,
memberID nvarchar(255) not null unique,
date date not null ,
amountPaid int not null check (amountPaid >= 0),
FOREIGN KEY (bidID) references BID(bidID),
FOREIGN KEY (memberID) references Member(memberID)
);

--Thong tin cua thanh vien tham gia dau gia
create table Member_BID(
bidID nvarchar(255) not null unique,
memberID nvarchar(255) not null unique,
time time not null, 
bidPrice int not null check (bidPrice >= 0),
PRIMARY KEY (bidID, memberID),
FOREIGN KEY (memberID) references Member(memberID),
FOREIGN KEY (bidID) references BID(bidID)
);

--Trang suc nguoi dung yeu cau dau gia
create table Member_Jewelry(
memberID nvarchar(255) not null unique,
jewelryID nvarchar(255) not null unique,
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



