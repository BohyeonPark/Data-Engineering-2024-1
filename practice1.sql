-- -- 인터넷 쇼핑몰 구축을 위한 '쇼핑몰' DB 생성 실습
-- 1)스키마(Schema) 생성 - Schemas 빈 부분 우클릭 Create Schema
CREATE TABLE 'shopdb'
create table `my Testtbl (id INT)`; -- 테이블 이름에 space가 들어간 경우 테이블 이름에 백틱(backtick ``) 키 활용

-- 2) 테이블 생성 - shopdb > Table > 우클릭 Create Table > 테이블 생성(membertbl, producttbl)
-- 3) 데이터 입력 - 테이블 우클릭 Select Row - Limits 1000 > 데이터 입력
-- 4) 데이터 활용 - 데이터베이스 shopdb 더블클릭
select * from membertbl; -- 회원 테이블 모두 조회
-- 명령어 실행의 경우, 번개 아이콘 or ctrl + shift + enter

select memberid from membertbl; -- 열 선택해 데이터 출력
select * from membertbl where membername='지운이' ; -- 특정 데이터를 만족하는 데이터 출력 where 조건

-- 5) 테이블 삭제
DROP TABLE shopdb

-- -- 인덱스(Index) 개체 실습
-- 대용량 데이터인 employees 복사 및 indextbl 테이블 생성
CREATE TABLE indexTBL (first_name varchar(14), last_name varchar(16), hire_date date) ; -- indexTBL 테이블 생성
INSERT INTO indexTBL -- query employees 데이터 input
	SELECT first_name, last_name, hire_date
    FROM employees.employees
    LIMIT 500; -- 500개 data만 불러오기

SELECT * FROM indexTBL ; -- indexTBL 데이터 확인

-- 인덱스가 없는 상태에서 쿼리 검색 -> Execution plan; Full Table Scan
SELECT * from indexTBL WHERE first_name='Mary' ;

-- 인덱스 생성
CREATE INDEX idx_indexTBL_firstname ON indexTBL(first_name) ; -- first_name 열에 인덱스 생성하는 쿼리

-- 인덱스 생성한 상태에서 쿼리 검색 -> Execution plan; Non-Unique Key Lookup
SELECT * from indexTBL WHERE first_name='Mary' ;


-- -- 뷰(View) 실습
-- 가상의 테이블로, 실제 행 데이터를 가지고 있지 않음, 실체는 없으며 진짜 테이블에 링크된 개념
-- 회원 이름과 주소만 존재하는 v_membertbl 뷰 생성
create view v_membertbl as select membername, memberaddress from membertbl ;
select * from v_membertbl ;

-- -- 스토어드 프로시저(Stored Procedure) 실습
-- SQL문을 하나로 묶어 편리하게 사용하는 기능 (like 함수), 스토어드 프로시저로 만들어 놓은 후, 스토어드 프로시저 호출
-- 회원 테이블에서 당탕이의 정보와 제품 테이블에서 냉장고 정보 조회 기능을 수행하는 스토어드 프로시저 생성
DELIMITER //
CREATE PROCEDURE myProc()
	BEGIN
		SELECT * FROM membertbl WHERE membername = '당탕이' ;
        SELECT * FROM producttbl WHERE productname = '냉장고' ;
	END//
DELIMITER ;

-- myProc() 실행
CALL myProc() ;

-- 프로시저 삭제
DROP PROCEDURE myProc ;

-- -- 트리거(Trigger) 실습
-- 테이블에 부착되어 테이블에 INSERT나 UPDATE 또는 DELETE 작업이 발생하면 자동 실행되는 코드
-- 회원 테이블에서 레코드를 삭제할 경우에 다른 테이블에서 지워진 레코드와 지워진 날짜 기록 확인 가능함
-- 먼저, 지워진 데이터를 보관할 테이블 생성하는
CREATE TABLE deletedMemberTBL(
	memberID char(8),
	memberName char(5),
    memberAddress char(20),
    deletedDate date
) ;

-- 데이터 삭제 발생시, 다른 테이블에 기록하는 트리거 생성
DELIMITER //
CREATE TRIGGER trg_deletedMemberTBL -- 트리거 이름
	AFTER DELETE -- 삭제 후에 작동하게 지정
	ON membertbl -- 트리거를 부착할 테이블
    FOR EACH ROW -- 각 행마다 적용시킴
BEGIN
	INSERT INTO deletedMemberTBL -- OLD 테이블의 내용을 백업테이블에 삽입
		VALUES (OLD.memberID, OLD.memberName, OLD.memberAddress, CURDATE() );
END //
DELIMITER ;
		
-- 데이터 삭제 발생시, 다른 테이블에 기록되는지 확인
DELETE FROM membertbl WHERE membername = '당탕이' ;

SELECT * FROM deletedMemberTBL ;

--  트리거 삭제
DROP TRIGGER trg_deletedMemberTBL ;



