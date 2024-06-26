-- ************************* SqlDBM: PostgreSQL *************************
-- ***** Generated by SqlDBM: DB-test1 by yisroelrosenblat@gmail.com ****



-- ************************************** "User"

CREATE TABLE "User"
(
 UserID    char(28) NOT NULL,
 Name      char(50) NOT NULL,
 CreatedAt timestamp NOT NULL

);








-- ************************************** Chat

CREATE TABLE Chat
(
 ChatID      uuid NOT NULL,
 Script      char(500) NOT NULL,
 NativeLang  char(50) NOT NULL,
 ForeignLang char(50) NOT NULL,
 Name        char(50) NULL,
 UserID      char(28) NOT NULL

);

CREATE INDEX FK_User ON Chat
(
 UserID
);








-- ************************************** Message

CREATE TABLE Message
(
 MessageID   uuid NOT NULL,
 ChatID      uuid NOT NULL,
 CreatedAt   timestamp NOT NULL,
 TextNative  char(500) NOT NULL,
 TextForeign char(500) NOT NULL,
 Sound       char(500) NULL,
 AI          boolean NOT NULL

);

CREATE INDEX FK_1 ON Message
(
 ChatID
);
