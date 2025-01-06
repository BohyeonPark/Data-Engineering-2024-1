-- 테이블 만들기
-- 1)MySQL Workbench에서 테이블 생성
CREATE DATABASE tabledb;

SELECT * FROM usertbl;
SELECT * FROM buytbl;


-- 2)SQL로 테이블 생성
DROP DATABASE tabledb;
CREATE DATABASE tabledb;

-- usertbl 생성
DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl
( userID CHAR(8) NOT NULL PRIMARY KEY, -- 기본 키 설정
 name VARCHAR(10) NOT NULL, 
 birthYear INT NOT NULL, 
 addr CHAR(2) NOT NULL,
 mobile1 CHAR(3) NULL, 
 mobile2 CHAR(8) NULL, 
 height SMALLINT NULL, 
 mDate DATE NULL 
);

-- buytbl 생성
DROP TABLE IF EXISTS buytbl;
CREATE TABLE buytbl
( num INT AUTO_INCREMENT NOT NULL PRIMARY KEY, 
 userid CHAR(8) NOT NULL ,
 prodName CHAR(6) NOT NULL,
 groupName CHAR(4) NULL , 
 price INT NOT NULL,
 amount SMALLINT NOT NULL,
 FOREIGN KEY(userid) REFERENCES usertbl(userID)
);


-- 회원 테이블 데이터 입력
INSERT INTO usertbl VALUES('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO usertbl VALUES('KBS', '김범수', 1979, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO usertbl VALUES('KKH', '김경호', 1971, '전남', '019', '3333333', 177, '2007-7-7');

SELECT * FROM usertbl;

-- 구매 테이블 데이터 입력
INSERT INTO buytbl VALUES(NULL, 'KBS', '운동화', NULL, 30, 2);
INSERT INTO buytbl VALUES(NULL, 'KBS', '노트북', '전자', 1000, 1);
INSERT INTO buytbl VALUES(NULL, 'JYP', '모니터', '전자', 200, 1); -- 구매 테이블 데이터 입력시 3번째 행은 앞과 같이 에러 발생하므로 삭제하고 입력

SELECT * FROM buytbl;


-- 제약 조건(Constraint) : 데이터의 무결성을 지키기 위하여 제약을 두는 조건
-- ㄴ 무결성 => 데이터를 결점이 없도록 유지하는 성질
-- ㄴ 특정 데이터 입력 시 어떠한 조건을 만족했을 때만 입력되도록 제약
-- ㄴ 데이터 무결성을 위한 제약 조건 6개: PRIMARY KEY 제약 조건, FOREIGN KEY 제약 조건, UNIQUE 제약 조건, CHECK 제약 조건, DEFAULT 정의, NULL 값 허용 유무

-- 1) PRIMARY KEY 제약 조건
-- 기본 키 생성: 맨 밑에 제약 조건 이름을 붙이는 방식으로도 생성 가능
DROP TABLE IF EXISTS usertbl2;
CREATE TABLE usertbl2
( userID CHAR(8) NOT NULL, 
 name VARCHAR(10) NOT NULL, 
 birthYear INT NOT NULL, 
 CONSTRAINT PK_usertbl_userID PRIMARY KEY(userID)
);

-- 테이블 수정을 통한 기본키 설정
ALTER TABLE usertbl
 ADD CONSTRAINT PK_usertbl_userID
 PRIMARY KEY (userID);

-- 2개 열 기본키 설정
DROP TABLE IF EXISTS prodTbl2;
CREATE TABLE prodTbl2
( prodCode CHAR(3) NOT NULL,
 prodID CHAR(4) NOT NULL,
 prodDate DATETIME NOT NULL,
 prodCur CHAR(10) NULL,
 CONSTRAINT PK_prodTbl_proCode_prodID
PRIMARY KEY (prodCode, prodID) 
);

SHOW INDEX FROM prodTbl2; -- 테이블 정보 확인

-- 2) FOREIGN KEY 제약 조건
-- 외래 키 테이블이 참조하는 기준 테이블의 열은 반드시 Primary Key이거나 Unique 제약 조건이 설정 되어 있어야 함
-- 외래 키의 옵션 중 ON DELETE CASCADE 또는 ON UPDATE CASCADE -> 기존 테이블의 데이터가 변경되었을 때 외래 키 테이블도 자동으로 적용되도록 설정

-- 외래 키 생성 방법1: CREATE TABLE 끝에 FOREIGN KEY 키워드로 설정
DROP TABLE IF EXISTS buytbl, usertbl;
CREATE TABLE usertbl
( userID CHAR(8) NOT NULL PRIMARY KEY, 
 name VARCHAR(10) NOT NULL, 
 birthYear INT NOT NULL 
);
CREATE TABLE buytbl
( num INT AUTO_INCREMENT NOT NULL PRIMARY KEY , 
 userID CHAR(8) NOT NULL, 
 prodName CHAR(6) NOT NULL,
 FOREIGN KEY(userID) REFERENCES usertbl(userID)
);

-- 외래 키 생성 방법2: ALTER TABLE 구문 이용
DROP TABLE IF EXISTS buytbl;
CREATE TABLE buytbl
( num INT AUTO_INCREMENT NOT NULL PRIMARY KEY,
 userID CHAR(8) NOT NULL, 
 prodName CHAR(6) NOT NULL 
);
ALTER TABLE buytbl
 ADD CONSTRAINT FK_usertbl_buytbl
 FOREIGN KEY (userID) REFERENCES usertbl(userID);

-- 외래 키 변경 설정
ALTER TABLE buytbl
	DROP FOREIGN KEY FK_usertbl_buytbl; -- 외래 키 제거
ALTER TABLE buytbl
	ADD CONSTRAINT FK_usertbl_buytbl
	FOREIGN KEY (userID)
	REFERENCES usertbl (userID)
	ON UPDATE CASCADE; -- 기존 테이블 업데이트 -> 외래 키 테이블 자동으로 적용
	
-- 3) UNIQUE 제약 조건
-- 중복되지 않는 유일한 값을 입력해야 하는 조건
-- PRIMARY KEY와 비슷하나, UNIQUE는 NULL 값 허용
-- NULL은 여러 개가 입력되어도 상관 없음

-- 회원 테이블 Email 주소 Unique로 설정
CREATE TABLE usertbl3
( userID CHAR(8) NOT NULL PRIMARY KEY, 
 name VARCHAR(10) NOT NULL, 
 birthYear INT NOT NULL, 
 email CHAR(30) NULL UNIQUE
);

-- 4) CHECK 제약 조건
-- 입력되는 데이터를 점검하는 기능
-- 키 제한(마이너스 값 안됨), 출생년도 제한 등

-- 출생연도가 1900년 이후 그리고 2023년 이전, 이름은 반드시 넣어야 함
DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl
( userID CHAR(8) PRIMARY KEY,
 name VARCHAR(10) , 
 birthYear INT CHECK (birthYear >= 1900 AND birthYear <= 2024),
 mobile1 char(3) NULL, 
 CONSTRAINT CK_name CHECK ( name IS NOT NULL) 
);

-- 제약 조건 추가
ALTER TABLE usertbl
	ADD CONSTRAINT CK_mobile1
	CHECK (mobile1 IN ('010','011','016','017','018','019')) ;

-- 5) DEFAULT 정의
-- 값 입력하지 않았을 때 자동으로 입력되는 기본 값을 정의

DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl
( userID CHAR(8) NOT NULL PRIMARY KEY, 
 name VARCHAR(10) NOT NULL, 
 birthYear INT NOT NULL DEFAULT -1,
 addr CHAR(2) NOT NULL DEFAULT '서울',
 mobile1 CHAR(3) NULL, 
 mobile2 CHAR(8) NULL, 
 height SMALLINT NULL DEFAULT 170, 
 mDate DATE NULL
);

-- Alter table 문을 이용하여 default 적용 시, alter column 문 사용
DROP TABLE IF EXISTS usertbl;
CREATE TABLE usertbl
( userID CHAR(8) NOT NULL PRIMARY KEY, 
 name VARCHAR(10) NOT NULL, 
 birthYear INT NOT NULL,
 addr CHAR(2) NOT NULL,
 mobile1 CHAR(3) NULL, 
 mobile2 CHAR(8) NULL, 
 height SMALLINT NULL, 
 mDate DATE NULL
);

ALTER TABLE usertbl
	ALTER COLUMN birthYear SET DEFAULT -1;
ALTER TABLE usertbl
	ALTER COLUMN addr SET DEFAULT '서울';
ALTER TABLE usertbl
	ALTER COLUMN height SET DEFAULT 170;
	
-- 6) Null 값 허용
-- NULL 값을 허용하려면 NULL을, 허용하지 않으려면 NOT NULL을 사용
-- PRIMARY KEY가 설정된 열에는 생략하면 자동으로 NOT NULL
-- NULL 값은 ‘아무 것도 없다’라는 의미, 공백(‘ ‘) 이나 0과 다름


	
	