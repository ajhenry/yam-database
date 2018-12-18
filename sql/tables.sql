/*
Andrew Henry
12/17/2018
Yam Database
*/
--SET ALL CONSTAINTS DEFERRED;

-- Test table for connectivity checks
CREATE TABLE TEST_TABLE(
    test_key INT DEFAULT 1
);

-- Used for checking for emails
--CREATE EXTENSION citext;
--CREATE DOMAIN email_field AS citext
  --CHECK ( value ~ '^[a-zA-Z0-9.!#$%&''*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$' );


-- Account (Since user is a reserved word :| ) table
CREATE TABLE Account(
    Id BIGSERIAL PRIMARY KEY,
    Email VARCHAR(254), --needs to be changed later
    Name VARCHAR(254),
    CurrentName VARCHAR(100) NOT NULL 
);

-- Username change event table
CREATE TABLE UsernameChange(
    Id BIGSERIAL PRIMARY KEY,
    Name VARCHAR(100),
    CurrentUserId BIGINT REFERENCES Account(Id) DEFERRABLE INITIALLY IMMEDIATE,
    OldUserId BIGINT REFERENCES Account(Id) DEFAULT NULL,
    UpdateTime TIMESTAMP DEFAULT NOW()
);



-- Table for posts/comments
CREATE TABLE Post(
    Id BIGSERIAL PRIMARY KEY,
    PostType VARCHAR(10) CHECK(PostType IN ('comment', 'post')),
    ContentText VARCHAR(400) NOT NULL,
    ContentType VARCHAR(6) CHECK(ContentType IN ('video', 'text', 'image', 'other')),
    VideoUrl VARCHAR(2085),
    ImageUrl VARCHAR(2085),
    OtherUrl VARCHAR(2085),
    ParentId BIGINT REFERENCES Post(Id),
    AuthorId BIGINT REFERENCES Account(Id),
    CurrentAuthorName VARCHAR(100),
    CurrentAuthorImage VARCHAR(2085),
    PostDate TIMESTAMP DEFAULT NOW()
);