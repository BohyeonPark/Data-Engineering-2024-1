-- -- SELECT문
-- USE 구문
USE employees;

-- SELECT와 FROM
SELECT * FROM titles;
-- SELECT 열 이름
SELECT first_name FROM employees;
SELECT first_name, last_name, gender FROM employees;

-- 조회
-- DB 조회
SHOW DATABASES; 
-- TABLE 조회
SHOW TABLE STATUS;
-- TABLE 이름 조회
SHOW TABLES;
-- TABLE 열 조회
DESC emplyoees;
DESCRIBE employees;

-- <실습 2> --

DROP DATABASE IF EXISTS sqldb; -- 만약 sqldb가 존재하면 우선 삭제한다.
CREATE DATABASE sqldb;

USE sqldb;
CREATE TABLE usertbl -- 회원 테이블
( userID  	CHAR(8) NOT NULL PRIMARY KEY, -- 사용자 아이디(PK)
  name    	VARCHAR(10) NOT NULL, -- 이름
  birthYear   INT NOT NULL,  -- 출생년도
  addr	  	CHAR(2) NOT NULL, -- 지역(경기,서울,경남 식으로 2글자만입력)
  mobile1	CHAR(3), -- 휴대폰의 국번(011, 016, 017, 018, 019, 010 등)
  mobile2	CHAR(8), -- 휴대폰의 나머지 전화번호(하이픈제외)
  height    	SMALLINT,  -- 키
  mDate    	DATE  -- 회원 가입일
);
CREATE TABLE buytbl -- 회원 구매 테이블(Buy Table의 약자)
(  num 		INT AUTO_INCREMENT NOT NULL PRIMARY KEY, -- 순번(PK)
   userID  	CHAR(8) NOT NULL, -- 아이디(FK)
   prodName 	CHAR(6) NOT NULL, --  물품명
   groupName 	CHAR(4)  , -- 분류
   price     	INT  NOT NULL, -- 단가
   amount    	SMALLINT  NOT NULL, -- 수량
   FOREIGN KEY (userID) REFERENCES usertbl(userID)
);

INSERT INTO usertbl VALUES('LSG', '이승기', 1987, '서울', '011', '1111111', 182, '2008-8-8');
INSERT INTO usertbl VALUES('KBS', '김범수', 1979, '경남', '011', '2222222', 173, '2012-4-4');
INSERT INTO usertbl VALUES('KKH', '김경호', 1971, '전남', '019', '3333333', 177, '2007-7-7');
INSERT INTO usertbl VALUES('JYP', '조용필', 1950, '경기', '011', '4444444', 166, '2009-4-4');
INSERT INTO usertbl VALUES('SSK', '성시경', 1979, '서울', NULL  , NULL      , 186, '2013-12-12');
INSERT INTO usertbl VALUES('LJB', '임재범', 1963, '서울', '016', '6666666', 182, '2009-9-9');
INSERT INTO usertbl VALUES('YJS', '윤종신', 1969, '경남', NULL  , NULL      , 170, '2005-5-5');
INSERT INTO usertbl VALUES('EJW', '은지원', 1972, '경북', '011', '8888888', 174, '2014-3-3');
INSERT INTO usertbl VALUES('JKW', '조관우', 1965, '경기', '018', '9999999', 172, '2010-10-10');
INSERT INTO usertbl VALUES('BBK', '바비킴', 1973, '서울', '010', '0000000', 176, '2013-5-5');
INSERT INTO buytbl VALUES(NULL, 'KBS', '운동화', NULL   , 30,   2);
INSERT INTO buytbl VALUES(NULL, 'KBS', '노트북', '전자', 1000, 1);
INSERT INTO buytbl VALUES(NULL, 'JYP', '모니터', '전자', 200,  1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '모니터', '전자', 200,  5);
INSERT INTO buytbl VALUES(NULL, 'KBS', '청바지', '의류', 50,   3);
INSERT INTO buytbl VALUES(NULL, 'BBK', '메모리', '전자', 80,  10);
INSERT INTO buytbl VALUES(NULL, 'SSK', '책'    , '서적', 15,   5);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '청바지', '의류', 50,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);
INSERT INTO buytbl VALUES(NULL, 'EJW', '책'    , '서적', 15,   1);
INSERT INTO buytbl VALUES(NULL, 'BBK', '운동화', NULL   , 30,   2);

SELECT * FROM usertbl;
SELECT * FROM buytbl;

-- </실습 2> --

-- 특정 조건의 데이터 조회 <SELECT .. FROM .. WHERE>
-- 기본적인 WHERE절
SELECT * FROM usertbl WHERE name = '김경호';
-- 관계연산자 사용
SELECT userID, name FROM usertbl WHERE birthYear >= 1978 AND height >= 182;

-- BETWEEN...AND와 In() 그리고 LIKE
-- 데이터 숫자로 구성되어 있으며 연속적인 값 > BETWEEN ... AND 사용
SELECT name, height FROM usertbl WHERE height BETWEEN 180 AND 183;
-- 이산적인 값의 조건 > IN() 사용
SELECT name, addr FROM usertbl WHERE addr IN ('경남','전남','경북');
-- 문자열의 내용 검색 > LIKE 사용 (문자 뒤에 % - 무엇이든 허용, 한 글자와 매치 '_' 사용)
SELECT name, height FROM usertbl WHERE name LIKE '김%';

-- 서브쿼리
SELECT name, height FROM usertbl 
	WHERE height > (SELECT height FROM usertbl WHERE Name = '김경호');

-- 서브쿼리의 결과가 둘 이상이 되면 에러 발생
SELECT name, height FROM usertbl 
	WHERE height > (SELECT height FROM usertbl WHERE addr = '경남');

-- ANY - 서브쿼리의 여러 개의 결과 중 한 가지만 만족해도 가능
SELECT name, height FROM usertbl 
	WHERE height > ANY (SELECT height FROM usertbl WHERE addr = '경남');
-- SOME은 ANY와 동일한 의미로 사용
SELECT name, height FROM usertbl 
	WHERE height > SOME (SELECT height FROM usertbl WHERE addr = '경남');
-- =ANY(서브쿼리)는 IN(서브쿼리)와 동일한 의미
SELECT name, height FROM usertbl 
	WHERE height = ANY (SELECT height FROM usertbl WHERE addr = '경남');
SELECT name, height FROM usertbl 
	WHERE height IN (SELECT height FROM usertbl WHERE addr = '경남');
-- ALL - 서브쿼리의 결과 중 여러 개의 결과를 모두 만족해야 함
SELECT name, height FROM usertbl 
	WHERE height > ALL (SELECT height FROM usertbl WHERE addr = '경남');

-- 원하는 순서대로 정렬하여 출력 : ORDER BY
-- 기본적으로 오름차순 정렬
SELECT name, mDate FROM usertbl ORDER BY mDate;
-- 내림차순 정렬 - 열 이름 뒤에 DESC
SELECT name, mDate FROM usertbl ORDER BY mDate DESC;
-- ORDER BY 구분 혼합 가능 - 키가 큰 순서로 정렬하되 만약 키가 같은 경우 이름 순으로 정렬
SELECT name, height FROM usertbl ORDER BY height DESC, name ASC;

-- 중복된 것을 하나만 남기는 DISTINCT
SELECT addr FROM usertbl;
SELECT DISTINCT addr FROM usertbl;

-- 출력하는 개수를 제한하는 LIMIT N 구문, MySQL의 부담을 많이 줄여줌
USE employees;
SELECT emp_no, hire_date FROM employees ORDER BY hire_date ASC LIMIT 5;

-- 테이블을 복사하는 CREATE TABLE ... SELECT
USE sqldb;
CREATE TABLE buytbl2 (SELECT * FROM buytbl);

SELECT * FROM buytbl2

-- GROUP BY 및 HAVING 그리고 집계 함수
-- GROUP BY절 - 그룹으로 묶어주는 역할
-- 사용자 별로 구매한 개수를 합쳐 출력
SELECT * FROM buytbl;
SELECT userID, SUM(amount) FROM buytbl GROUP BY userID;
-- Alias(AS) 별칭 사용 가능
SELECT userID AS '사용자 아이디', SUM(amount) AS '총 구매 개수' FROM buytbl GROUP BY userID;
-- 집계 함수
SELECT userID, STDDEV(amount) FROM buytbl GROUP BY userID;

-- 그룹별이 아닌 전체 구매자가 구매한 물품의 개수 평균
USE sqldb;
SELECT AVG(amount) AS '평균 구매 개수' FROM buytbl;

-- Having 절 - 집계 함수에 대해서 조건을 제한하는 것, 반드시 GROUP BY절 다음에 나와야 함
SELECT userID AS '사용자 아이디', SUM(price*amount) AS ' 총 구매액' FROM buytbl GROUP BY userID
	HAVING SUM(price*amount) > 1000;

-- ROLLUP - 전체총합과 그룹별 소합계가 필요할 경우 사용, GROUP BY절과 WITH ROLLUP문 사용
SELECT * FROM buytbl;
-- 분류(groupName) 별로 합계 및 그 총합 구하기
SELECT num, groupName, SUM(price*amount) AS '비용'
	FROM buytbl GROUP BY groupName, num WITH ROLLUP;

SELECT groupName, SUM(price*amount) AS '비용'
	FROM buytbl GROUP BY groupName WITH ROLLUP;
	

-- -- 데이터의 변경을 위한 SQL문
-- INSERT
USE sqldb;
CREATE TABLE testTb1 (id int, userName char(3), age int);
INSERT INTO testTb1 VALUES(1, '홍길동', 25);
SELECT * FROM testTb1;

INSERT INTO testTb1(id, userName) VALUES(2, '박보현');
SELECT * FROM testTb1;

-- 테이블 생성 시, 항목의 속성이 AUTO_INCREMENT로 지정되어 있다면, INSERT에서는 NULL 값으로 입력, 1부터 증가하는 값이 자동으로 입력됨
-- 적용할 열이 PRIMARY KEY 혹은 UNIQUE 일 때만 사용 가능, 데이터 형은 숫자 형식만 사용 가능
CREATE TABLE testTbl2 (id int AUTO_INCREMENT PRIMARY KEY, userName char(3), age int);
INSERT INTO testTbl2 VALUES (NULL, '지민', 25);
INSERT INTO testTbl2 VALUES (NULL, '뷔', 27);
SELECT * FROM testTbl2

SELECT LAST_INSERT_ID(); -- 자동 증가된 값 확인 명령

-- AUTO_INCREMENT로 지정되어 있다면, 초기 값을 1000으로 하고, 증가 값을 1이 아닌 3으로 변경 가능 - ALTER, SET
CREATE TABLE testTbl3 (id int AUTO_INCREMENT PRIMARY KEY, userName char(3), age int);
ALTER TABLE testTbl3 AUTO_INCREMENT=1000;
SET @@auto_increment_increment=3;
INSERT INTO testTbl3 VALUES (NULL, '보현', 28);
INSERT INTO testTbl3 VALUES (NULL, '태수', 27);
SELECT * FROM testTbl3;

-- 대량의 샘플 데이터 생성 - INSERT INTO ... SELECT 구문 사용
-- SELECT 문의 열의 개수 = INSERT 할 테이블의 열의 개수
CREATE TABLE testTbl4 (id int, Fname varchar(50), Lname varchar(50));
INSERT INTO testTbl4
	SELECT emp_no, first_name, last_name FROM employees.employees;
SELECT * FROM testTbl4;

-- 테이블 속성 정의 부분 생략 가능함
CREATE TABLE testTbl5
	(SELECT emp_no, first_name, last_name FROM employees.employees);
SELECT * FROM testTbl5;

-- 데이터의 수정 UPDATE문
-- 기존에 입력되어 있는 값 변경하는 구문
SELECT * FROM testtbl2
UPDATE testtbl2 SET userName = 'rm' WHERE userName = '지민';
SELECT * FROM testtbl2

-- 데이터의 삭제 DELETE FROM
-- 행 단위로 삭제하는 구문
DELETE FROM testtbl2 WHERE userName = 'rm';
SELECT * FROM testtbl2 ;

-- 상위 5개 삭제
DELETE FROM testtbl2 WHERE userName = 'rm' LIMIT 5;

-- DML인 DELETE는 트랜잭션 로그 기록 작업 때문에 삭제 느림
-- DDL문인 DROP문, TRUNCATE문은 트랜잭션 없어 빠름. 대용량 데이터의 경우 사용
-- 테이블 자체 삭제
DROP TABLE 테이블명;
-- 테이블 구조 남기고 내용만 삭제
TRUNCATE TABLE 테이블;

-- 오류가 발생해도 계속 진행하는 방법
CREATE TABLE membertbl (SELECT userID, name, addr FROM usertbl LIMIT3); -- 3건만 가져옴
ALTER TABLE membertbl
	ADD CONSTRAINT pk_memberTBL PRIMARY KEY (userID); -- PK 지정
SELECT * FROM membertbl;

INSERT INTO membertbl VALUES('BBK','비비코','미국'); -- 일부러 첫번째에 중복키 데이터 입력
INSERT INTO membertbl VALUES('SJH','서장훈','서울');
INSERT INTO membertbl VALUES('HJY','현주엽','경기');
-> 첫번째 오류 때문에 나머리 쿼리 실행 안됨

-- ->INSERT IGNORE문
-- 에러 발생해도 다음 구문으로 넘어가게 됨
INSERT IGNORE INTO membertbl VALUES('BBK','비비코','미국');
INSERT IGNORE INTO membertbl VALUES('SJH','서장훈','서울');
INSERT IGNORE INTO membertbl VALUES('HJY','현주엽','경기');

-- ->ON DUPLICATE KEY UPDATE문
-- Insert 시도 시, 중복된 기본 키이면 update
INSERT INTO membertbl VALUES('BBK','비비코','미국') -- 업데이트
	ON DUPLICATE KEY UPDATE name = '비비코', addr = '미국';
INSERT INTO membertbl VALUES('DJM','동짜몽','일본') -- 정상 삽입
	ON DUPLICATE KEY UPDATE name = '동짜몽', addr = '일본';

-- WITH절과 CTE
-- WITH절은 CTE(Common Table Expression, 가상의 테이블)를 표현하기 위한 구문
-- CTE는 기존의 뷰, 파싱 테이블, 임시 테이블 등을 대신할 수 있으며 보다 간결한 식으로 표현 가능
-- 재귀적 CTE/ 비재귀적 CTE (아래 예시)
-- 뷰는 계속 존재하지만, CTE는 구문이 끝나면 소멸, 다시 사용할 수 없음
-- 총 구매액이 많은 사용자 순서로 내림차순 정렬
WITH abc(userid, total)
AS
(SELECT userid, SUM(price*amount)
	FROM buyTBL GROUP BY userid)
SELECT * FROM abc ORDER BY total DESC;

-- 지역별로 가장 큰 키의 평균
WITH cte_usertbl(addr, maxHeight)
AS
(SELECT addr, MAX(height) FROM usertbl GROUP BY addr) -- 지역별로 가장 큰 키 뽑기
SELECT AVG(maxHeight*1.0) AS '각 지역별 최고키의 평균' FROM cte_usertbl; -- 큰 키의 평균

