/* 박보현 */

-- (1) MySQL을 이용하여 극장 데이터베이스(theaterdb) 및 4개(극장, 상영관, 예약, 고객) 테이블을 생성하시오.
CREATE DATABASE theaterdb;
USE theaterdb;
CREATE TABLE 극장 (극장번호 INTEGER, 극장이름 VARCHAR(30), 위치 VARCHAR(30));
CREATE TABLE 상영관 (극장번호 INTEGER, 상영관번호 INTEGER, 영화제목 VARCHAR(30), 가격 INTEGER, 좌석수 INTEGER);
CREATE TABLE 예약 (극장번호 INTEGER, 상영관번호 INTEGER, 고객번호 INTEGER, 가격번호 INTEGER, 날짜 DATE);
CREATE TABLE 고객 (고객번호 INTEGER, 이름 VARCHAR(30), 주소 VARCHAR(30));

-- (2) 각 테이블 당 3개씩 총 12개 데이터를 삽입하는 SQL 문을 작성하시오. (insert 문 12개)
INSERT INTO 극장 VALUES(1,'롯데','잠실');
INSERT INTO 극장 VALUES(2,'메가','강남');
INSERT INTO 극장 VALUES(3,'대한','잠실');
INSERT INTO 상영관 VALUES(1,1,'어려운 영화',15000,48);
INSERT INTO 상영관 VALUES(3,1,'멋진 영화',7500,120);
INSERT INTO 상영관 VALUES(3,2,'재밌는 영화',8000,110);
INSERT INTO 예약 VALUES(3,2,3,15,'2020-09-01');
INSERT INTO 예약 VALUES(3,1,4,16,'2020-09-01');
INSERT INTO 예약 VALUES(1,1,9,48,'2020-09-01');
INSERT INTO 고객 VALUES(3,'홍길동','강남');
INSERT INTO 고객 VALUES(4,'김철수','잠실');
INSERT INTO 고객 VALUES(9,'박영희','강남');

-- (3) 모든 극장의 이름과 위치를 조회하는 SQL문을 작성하시오.
SELECT 극장이름, 위치 FROM 극장;

-- (4) '잠실'에 있는 모든 극장을 조회하는 SQL문을 작성하시오.
SELECT * FROM 극장 WHERE 위치 = '잠실';

-- (5) '잠실'에 사는 고객의 이름을 오름차순으로 하여, 고객번호, 이름, 주소를 조회하는 SQL문을 작성하시오.
SELECT 고객번호, 이름, 주소 FROM 고객 WHERE 주소 = '잠실' ORDER BY 이름;

-- (6) 가격이 6,000원 이하인 영화의 극장번호, 상영관번호, 영화제목을 조회하는 SQL문을 작성하시오.
SELECT 극장번호, 상영관번호, 영화제목 FROM 상영관 WHERE 가격 <= 6000;

-- (7) 극장의 수를 조회하는 SQL문을 작성하시오.
SELECT COUNT(*) AS '극장의 수' FROM 극장;

-- 또는 FOUND_ROWS()를 사용하여 극장에서 조회한 행의 개수 파악 가능
SELECT * FROM 극장;
SELECT FOUND_ROWS();

-- (8) 상영되는 영화의 평균 가격을 조회하는 SQL문을 작성하시오.
SELECT AVG(가격) AS '상영되는 영화의 평균 가격' FROM 상영관;

-- (9) 극장별 상영관 수를 조회하는 SQL문을 작성하시오.
SELECT 극장번호, COUNT(*) AS '극장별 상영관 수' FROM 상영관 GROUP BY 극장번호;

-- (10) 영화 가격을 모두 10% 인상하여 변경하는 SQL문을 작성하시오.
UPDATE 상영관 SET 가격 = 가격 * 1.1;
SELECT * FROM 상영관;

