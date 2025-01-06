-- -- 조인
-- 조인: 두 개 이상의 테이블을 서로 묶어서 하나의 결과 집합으로 만들어 내는 것
-- 종류: INNER JOIN, OUTER JOIN, CROSS JOIN, SELF JOIN
-- 중복과 공간 낭비를 피하고, 데이터의 무결성을 위해서 여러 개의 테이블을 분리하여 저장 -> 분리된 테이블들은 서로 관계(relation)를 가짐
-- 1대 다 관계가 보편적임 -한쪽 테이블에는 하나의 값만 존재해야 하지만, 다른 쪽 테이블에는 여러 개가 존재할 수 있는 관계

-- INNER JOIN(내부 조인)
-- JOIN만 써도 INNER JOIN으로 인식함
-- 예) 구매 테이블에 회원 테이블을 결합, 구매 테이블에는 배송에 필요한 주소 정보가 없음
USE sqldb;
SELECT *
	FROM buytbl
		INNER JOIN usertbl
			ON buytbl.userID = usertbl.userID
		WHERE buytbl.userID = 'JYP';
		
-- WHERE 생략하여 전체 테이블 출력
SELECT *
	FROM buytbl
		INNER JOIN usertbl
			ON buytbl.userID = usertbl.userID
		ORDER BY num; -- num 기준 오름차순 정렬
		
-- 필요한 열만 추출
SELECT buytbl.userID, name, prodName, addr, mobile1 + mobile2 AS '연락처'
	FROM buytbl
		INNER JOIN usertbl
			ON buytbl.userID = usertbl.userID
		ORDER BY num;

-- 별칭을 부여하여 더 간결하고 명확하게 표현
SELECT B.userID, U.name, B.prodName, U.addr, U.mobile1 + U.mobile2 AS '연락처'
	FROM buytbl B
		INNER JOIN usertbl U
			ON B.userID = U.userID
		ORDER BY B.num;
		
-- 예) 회원 테이블에 구매 테이블 결합 (앞서와 동일 결과)
SELECT U.userID, U.name, B.prodName, U.addr, U.mobile1 + U.mobile2 AS '연락처'
	FROM usertbl U
		INNER JOIN buytbl B
			ON U.userID = B.userID
		ORDER BY U.userID;
		
-- 한 번이라도 구매한 기록이 있는 회원 목록 추출 - distinct 문 활용 (중복 배제, 하나씩만 출력)
SELECT DISTINCT U.userID, U.name, U.addr
	FROM usertbl U
		INNER JOIN buytbl B
			ON U.userID = B.userID
		ORDER BY U.userID;

-- exists 문으로 동일 결과 - sub query (메인 쿼리 실행 -> WHERE EXISTS 서브쿼리 실행)
SELECT U.userID, U.name, U.addr
	FROM usertbl U
	WHERE EXISTS (
		SELECT * FROM buytbl B
			WHERE U.userID = B.userID );

-- 3개 테이블 조인 : 다대다 관계
-- 두 테이블 사이에 연결 테이블을 추가하고, 두 테이블이 각각 추가한 연결 테이블과 일대다 관계 구성
-- 예) 학생과 동아리 관계 - 한 학생은 여러 동아리 가입 가능, 한 동아리에도 여러 학생이 가입

-- 학생, 동아리, 학생_동아리 테이블 생성 및 데이터 입력
CREATE TABLE stdtbl
( stdName VARCHAR(10) NOT NULL PRIMARY KEY,
 addr CHAR(4) NOT NULL
);
CREATE TABLE clubtbl
( clubName VARCHAR(10) NOT NULL PRIMARY KEY,
 roomNo CHAR(4) NOT NULL
);
CREATE TABLE stdclubtbl
( num int AUTO_INCREMENT NOT NULL PRIMARY KEY, 
 stdName VARCHAR(10) NOT NULL,
 clubName VARCHAR(10) NOT NULL,
FOREIGN KEY(stdName) REFERENCES stdtbl(stdName),
FOREIGN KEY(clubName) REFERENCES clubtbl(clubName)
);

INSERT INTO stdtbl VALUES ('김범수','경남'), ('성시경','서울'), ('조용필','경기'), ('은지원','경북'),('바비킴','서울');
INSERT INTO clubtbl VALUES ('수영','101호'), ('바둑','102호'), ('축구','103호'), ('봉사','104호');
INSERT INTO stdclubtbl VALUES (NULL, '김범수','바둑'), (NULL,'김범수','축구'), (NULL,'조용필','축구'), (NULL,'은지원','축구'), 
	(NULL,'은지원','봉사'), (NULL,'바비킴','봉사');

SELECT * FROM stdtbl;
SELECT * FROM clubtbl;
SELECT * FROM stdclubtbl;

-- 학생 기준으로 학생 이름/지역/가입한 동아리/동아리방 출력
SELECT S.stdName, S.addr, SC.clubName, C.roomNo
	FROM stdtbl S
		INNER JOIN stdclubtbl SC
			ON S.stdName = SC.stdName
		INNER JOIN clubtbl C
			ON SC.clubName = C.clubName
	ORDER BY S.stdName;
	
-- OUTER JOIN(외부 조인)
-- 조인의 조건에 만족되지 않는 행까지도 포함시키는 것
-- 예) 구매와 회원 테이블을 조인한 경우, 구매 내역이 없는 사용자는 출력되지 않는데, 구매 내역이 없는 사용자 행까지도 포함하여 조인

-- LEFT OUTER JOIN -왼쪽 테이블(usertbl)의 것은 모두 추력되어야 한다로 이해
-- 줄여서 LEFT JOIN으로 쓸 수 있음
SELECT U.userID, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS '연락처'
	FROM usertbl U
		LEFT OUTER JOIN buytbl B
			ON U.userID = B.userID
		ORDER BY U.userID;		

-- RIGHT OUTER JOIN -오른쪽 테이블(buytbl)의 것은 모두 출력되어야 한다로 이해
SELECT U.userID, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS '연락처'
	FROM buytbl B
		RIGHT OUTER JOIN usertbl U
			ON U.userID = B.userID
		ORDER BY U.userID;

-- 한 번도 구매한 적이 없는 회원 목록 출력
SELECT U.userID, U.name, B.prodName, U.addr, CONCAT(U.mobile1, U.mobile2) AS '연락처'
	FROM usertbl U
		LEFT OUTER JOIN buytbl B
			ON U.userID = B.userID
	WHERE B.prodName IS NULL
    ORDER BY U.userID;
	

-- FULL (OUTER) JOIN - 전체 (외부) 조인
-- 한쪽이 아니라 양쪽 모두 조건에 일치하지 않는 것을 모두 출력, 활용도 낮음

-- CROSS JOIN(상호 조인)
-- 한쪽 테이블의 모든 행들과 다른 쪽 테이블의 모든 행을 조인시키는 기능
-- CROSS JOIN 결과 개수 = 두 테이블 개수를 곱한 개수, 카티션곱 (Carteasian Product)
SELECT *
	FROM buytbl
		CROSS JOIN usertbl;
-- buytbl 12개 행 X usertbl 10개 행 = 120개 행

-- 테스트로 사용할 많은 용량의 데이터를 생성할 때 주로 사용
-- ON 구문을 사용할 수 없음
-- 대량의 데이터를 생성하면, 시스템이 다운되거나 디스크 용량이 모두 찰 수 있어 COUNT(*) 함수로 개수만 카운트
SELECT COUNT(*) AS '데이터개수'
	FROM employees
		CROSS JOIN titles;
		
-- SELF JOIN(자체 조인)
-- 별도의 구문이 있는 것이 아니라, 자기 자신과 자기 자신이 조인한다는 의미
-- 예) 이부장은 직원이름(emp)과 상관이름(manager) 열이 동시에 존재
-- 우대리 상관의 구내번호를 알고 싶으면 emp 열과 manager열을 조인하여 알 수도 있음

-- sqldb에 emptbl 생성 및 데이터 삽입
USE sqldb;
CREATE TABLE empTbl (emp CHAR(3), manager CHAR(3), empTel VARCHAR(8));

INSERT INTO empTbl VALUES('나사장',NULL,'0000');
INSERT INTO empTbl VALUES('김재무','나사장','2222');
INSERT INTO empTbl VALUES('김부장','김재무','2222-1');
INSERT INTO empTbl VALUES('이부장','김재무','2222-2');
INSERT INTO empTbl VALUES('우대리','이부장','2222-2-1');
INSERT INTO empTbl VALUES('지사원','이부장','2222-2-2');
INSERT INTO empTbl VALUES('이영업','나사장','1111');
INSERT INTO empTbl VALUES('한과장','이영업','1111-1');
INSERT INTO empTbl VALUES('최정보','나사장','3333');
INSERT INTO empTbl VALUES('윤차장','최정보','3333-1');
INSERT INTO empTbl VALUES('이주임','윤차장','3333-1-1');

SELECT * FROM emptbl;

-- 우대리 상관의 연락처 확인을 위한 자체 조인
SELECT A.emp AS '부하직원', B.emp AS '직속상관', B.empTel AS '직속상관연락처'
	FROM empTbl A
		INNER JOIN empTbl B
			ON A.manager = B.emp
	WHERE A.emp = '우대리';
	
SELECT A.emp AS '부하직원', B.emp AS '직속상관', B.empTel AS '직속상관연락처'
	FROM empTbl A
		INNER JOIN empTbl B
			ON A.manager = B.emp;


-- UNION / UNION ALL - 두 쿼리의 결과를 행으로 합치는 것
-- 열의 개수, 데이터 형식 등이 같아야 함
-- 문장1의 열 이름을 따름
-- UNION -중복은 제외하고 출력
-- UNION ALL -중복까지 모두 출력
SELECT stdName, addr FROM stdTbl
	UNION ALL
SELECT clubName, roomNo FROM clubTbl;


-- NOT IN / IN
-- NOT IN -첫 번째 쿼리 결과에서 두 번째 쿼리 결과 제외
-- 예) 사용자 중에 전화가 없는 사용자 제외
SELECT name, CONCAT(mobile1, mobile2) AS '전화번호' FROM usertbl
	WHERE name NOT IN (
		SELECT name FROM usertbl WHERE mobile1 IS NULL );
		
-- IN -첫 번째 쿼리 결과에서 두 번째 쿼리에 해당하는 것만 조회
-- 예) 사용자 중에 전화가 없는 사용자만 제외
SELECT name, CONCAT(mobile1, mobile2) AS '전화번호' FROM usertbl
	WHERE name IN (
		SELECT name FROM usertbl WHERE mobile1 IS NULL );

-- IF ... ELSE -조건에 따라 분기. 참 / 거짓 두 가지만 있기에 2중 분기
IF <부울 표현식> THEN
	SQL 문장들1
ELSE
	SQL 문장들2
END IF;

-- 부울 표현식 부분이 참이면 SQL 문장들1 수행 / 거짓이면 SQL 문장들2 수행
-- 수행할 SQL 문장이 한 문장 이사이라면 BEGIN / END로 묶어주기

-- 예) IF...ELSE
USE employees;
DROP PROCEDURE IF EXISTS ifProc2; -- 프로시저가 존재할 경우 삭제

DELIMITER $$
CREATE PROCEDURE ifProc2()
BEGIN
	DECLARE hireDATE DATE; -- 입사일 변수 선언
	DECLARE curDATE DATE; -- 오늘 변수 선언
	DECLARE days INT; -- 근무한 일수 변수 선언
    
	SELECT hire_date INTO hireDate -- hire_date 열의 결과를 hireDATE에 대입
		FROM employees.employees
		WHERE emp_no = 10001;
     
	SET curDATE = CURRENT_DATE(); -- 현재 날짜
	SET days = DATEDIFF(curDATE, hireDATE); -- 날짜의 차이, 일 단위
    
	IF (days/365) >= 5 THEN -- 5년이 지났다면
		SELECT CONCAT('입사한지 ', days, '일이나 지났습니다. 축하합니다!');
	ELSE
		SELECT '입사한지 ' + days + '일밖에 안되었네요. 열심히 일하세요.' ;
	END IF;
END $$

DELIMITER ;
CALL ifProc2();

-- 예) IF...ELSEIF...ELSE
DELIMITER $$
CREATE PROCEDURE ifProc3()
BEGIN
	DECLARE point INT ;
	DECLARE credit CHAR(1);
	SET point = 77 ;
    
    IF point >= 90 THEN
		SET credit = 'A';
	ELSEIF point >= 80 THEN
		SET credit = 'B';
	ELSEIF point >= 70 THEN
		SET credit = 'C';
	ELSEIF point >= 60 THEN
		SET credit = 'D';
	ELSE
		SET credit = 'F';
	END IF;
	SELECT CONCAT('취득점수==>', point), CONCAT('학점==>', credit);
END $$

DELIMITER ;
CALL ifProc3();

-- 예) CASE
DELIMITER $$
CREATE PROCEDURE caseProc()
BEGIN
	DECLARE point INT ;
    DECLARE credit CHAR(1);
    SET point = 77 ;
 
	CASE 
		WHEN point >= 90 THEN
			SET credit = 'A';
		WHEN point >= 80 THEN
			SET credit = 'B';
		WHEN point >= 70 THEN
			SET credit = 'C';
		WHEN point >= 60 THEN
			SET credit = 'D';
		ELSE
			SET credit = 'F';
END CASE;
    SELECT CONCAT('취득점수==>', point), CONCAT('학점==>', credit);
END $$

DELIMITER ;
CALL caseProc();

-- 예) SELECT 문에서 CASE 사용
-- 구매 테이블(buytbl)에 구매액(price*amount)이 1500원 이상인 고객은 ‘최우수 고객‘, 1000원 이상은 ‘우수고객’, 1원 이상은 ‘일반고객’으로 출력, 구매 실적이 없는 고객은 ‘유령고객’
USE sqldb;

SELECT U.userID, U.name, SUM(price*amount) AS '총구매액',
	CASE 
	WHEN (SUM(price*amount) >= 1500) THEN '최우수고객'
	WHEN (SUM(price*amount) >= 1000) THEN '우수고객'
	WHEN (SUM(price*amount) >= 1 ) THEN '일반고객'
	ELSE '유령고객'
	END AS '고객등급'
FROM buytbl B
	RIGHT OUTER JOIN usertbl U
		ON B.userID = U.userID
GROUP BY U.userID, U.name 
ORDER BY sum(price*amount) DESC ;

-- WHILE문과 ITERATE/LEAVE
-- WHILE문 -해당 부울식이 참인 동안에 계속 반복되는 반복문
-- 예)
DELIMITER $$
CREATE PROCEDURE whileProc()
BEGIN
	DECLARE i INT; -- 1에서 100까지 증가할 변수
	DECLARE hap INT; -- 더한 값을 누적할 변수
    
	SET i = 1;
	SET hap = 0;
    
	WHILE (i <= 100) DO
		SET hap = hap + i; -- hap의 원래의 값에 i를 더해서 다시 hap에 넣으라는 의미
		SET i = i + 1; -- i의 원래의 값에 1을 더해서 다시 i에 넣으라는 의미
	END WHILE;
    
	SELECT hap; 
END $$

DELIMITER ;
CALL whileProc();

-- 예) WHILE문과 ITERATE/LEAVE
-- ITERATE - continue
-- LEAVE - break
DELIMITER $$
CREATE PROCEDURE whileProc2()
BEGIN
	DECLARE i INT; -- 1에서 100까지 증가할 변수
	DECLARE hap INT; -- 더한 값을 누적할 변수
	SET i = 1;
	SET hap = 0;
    
	myWhile: WHILE (i <= 100) DO -- While문에 label을 지정
		IF (i%7 = 0) THEN
			SET i = i + 1; 
			ITERATE myWhile; -- 지정한 label문으로 가서 계속 진행
	END IF;
    
	SET hap = hap + i; 
    
	IF (hap > 1000) THEN 
		LEAVE myWhile; -- 지정한 label문을 떠남. 즉, While 종료.
	END IF;
    
	SET i = i + 1;
    
	END WHILE;
    
	SELECT hap; 
END $$

DELIMITER ;
CALL whileProc2();


-- -- 오류 처리
-- DECLARE 액션 HANDLER FOR 오류조건 처리할_문장;
-- 액션: 오류 발생 시에 행동 정의. CONTINUE와 EXIT 둘 중 하나 사용, CONTINUE가 나오면 제일 뒤의 '처리할_문장' 부분이 처리
-- 오류조건: 어떤 오류를 처리할 것인지를 지정. 오류 코드 숫자, SQLSTATE'상태코드', SQLEXCEPTION, SQLWARNING, NOT FOUND 등이 올 수 있음
-- 처리할_문장: 처리할 문장이 여러 개일 경우에는 BEGIN...END로 묶어줌

-- 테이블이 없을 경우에 오류를 직접 처리하는 코드. Declare 부분이 있어서 사용자가 지정한 메시지 출력
-- 1146, SQLSTATE'42S02' 가능 -> 둘 다 테이블이 없을 경우를 의미
DROP PROCEDURE IF EXISTS errorProc; 
DELIMITER $$
CREATE PROCEDURE errorProc()
BEGIN
	DECLARE CONTINUE HANDLER FOR 1146 SELECT '테이블이 없어요ㅠㅠ' AS '메시지';
    SELECT * FROM noTable; -- noTable은 없음. 
END $$
DELIMITER ;
CALL errorProc();

DROP PROCEDURE IF EXISTS errorProc; 
DELIMITER $$
CREATE PROCEDURE errorProc()
BEGIN
	DECLARE CONTINUE HANDLER FOR SQLSTATE'42S02' SELECT '테이블이 없어요ㅠㅠ' AS '메시지';
    SELECT * FROM noTable; -- noTable은 없음. 
END $$
DELIMITER ;
CALL errorProc();

-- 기본키인 userID 컬럼에서 이미 존재하는 LSG를 포함하는 데이터 삽입
DELIMITER $$
CREATE PROCEDURE errorProc2()
BEGIN
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		SHOW ERRORS; -- 오류 메시지를 보여 준다.
        SELECT '오류가 발생했네요. 작업은 취소시켰습니다.' AS '메시지'; 
        ROLLBACK; -- 오류 발생시 작업을 롤백(작업 취소)시킨다.
	END;
    INSERT INTO usertbl VALUES('LSG', '이상구', 1988, '서울', NULL, NULL, 170, CURRENT_DATE()); -- 중복되는 아이디이므로 오류 발생
END $$
DELIMITER ;
CALL errorProc2();

-- 동적 SQL: 프로그램 실행 중에 사용자의 입력이나 프로그램의 상황에 따라 실행되는 쿼리
-- 1) PREPARE문 : SQL문을 실행하지 않고 미리 준비만 해놓음
-- 2) EXECUTE문 : 준비한 쿼리문 실행, 실행 후에는 DEALLOCATE PREFARE로 문장 해제

-- 문장을 바로 실행하지 않고, myQuery에 입력시켜 놓고 Execute 문으로 실행
use sqldb;
PREPARE myQuery FROM 'SELECT * FROM usertbl WHERE userID = "EJW"';
EXECUTE myQuery;
DEALLOCATE PREPARE myQuery;

-- Prepare 문에서 ?으로 향후에 입력될 값을 비워놓고, Execute에서는 Using을 이용해서 값을 전달할 수 있음
-- 다음은 쿼리를 실행하는 순간의 날짜와 시간이 입력되는 기능
USE sqldb;
DROP TABLE IF EXISTS myTable;

CREATE TABLE myTable (id INT AUTO_INCREMENT PRIMARY KEY, mDate DATETIME);
SET @curDATE = CURRENT_TIMESTAMP(); -- 현재 날짜와 시간

PREPARE myQuery FROM 'INSERT INTO myTable VALUES(NULL, ?)';
EXECUTE myQuery USING @curDATE;
DEALLOCATE PREPARE myQuery;

SELECT * FROM myTable;


