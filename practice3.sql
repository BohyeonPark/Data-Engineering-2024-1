-- -- 변수의 사용
USE sqldb;

SET @myVar1 = 5;
SET @myVar2 = 3;
SET @myVar3 = 4.25;
SET @myVar4 = '가수 이름 ==>';

SELECT @myVar1;
SELECT @myVar2 + @myVar3;
SELECT @myVar4, Name FROM usertbl WHERE height > 180;

-- 데이터 형식 변환 함수 - CAST(), CONVERT()
SELECT CAST(AVG(amount) AS SIGNED INTEGER) AS '평균 구매 개수' FROM buytbl;

SELECT CONVERT(AVG(amount), SIGNED INTEGER) AS '평균 구매 개수' FROM buytbl;

-- 암시적인 형 변환 (자동으로 타입 변환)
SELECT '100' + '200'; -- 문자와 문자를 더함 (정수로 변환되서 연산됨)
SELECT CONCAT('100','200'); -- 문자와 문자를 연결 (문자로 처리)
SELECT CONCAT(100,'200'); -- 숫자와 문자를 연결 (숫자가 문자로 변환되어 처리)
SELECT 1 > '2mega'; -- 정수인 2로 변환되어서 비교
SELECT 3 > '2mega'; -- 정수인 2로 변환되어서 비교
SELECT 0 = 'mega2'; -- 문자는 0으로 변환됨
SELECT 0 = 0; -- = 같으면 1, 다르면 0
SELECT 0 <> 0; -- 같으면 0, 다르면 1

-- -- 내장함수
-- 제어 흐름 함수
-- IF(수식,참,거짓) -수식이 참 또는 거짓인지 결과에 따라서 2중 분기
SELECT IF (100>200, '참이다', '거짓이다');

-- IFNULL(수식1,수식2) -수식1이 NULL이 아니면 수식1 반환, 수식1이 NULL이면 수식2 반환
SELECT IFNULL(NULL,'널이군요'), IFNULL(100,'널이군요');

-- NULLIF(수식1,수식2) -수식1과 수식2가 같으면 NULL 반환, 다르면 수식1 반환
SELECT NULLIF(100,100), NULLIF(200,100);

-- CASE ~ WHEN ~ ELSE ~ END -CASE는 연산자(operator), 다중분기
SELECT CASE 10
		WHEN 1 THEN '일'
		WHEN 5 THEN '오'
		WHEN 10 THEN '십'
		ELSE '모름'
	END AS 'CASE연습';


-- 문자열 함수
SELECT ASCII('A'), CHAR(65);

-- BIT_LENGTH(문자열) -할당된 BIT 크기 또는 문자 크기 반환
-- CHAR_LENGTH(문자열) -문자의 개수 반환
-- LENGTH(문자열) -할당된 Byte 수 반환
SELECT BIT_LENGTH('abc'), CHAR_LENGTH('abc'), LENGTH('abc');
SELECT BIT_LENGTH('가나다'), CHAR_LENGTH('가나다'), LENGTH('가나다'); -- 한글은 글자당 3바이트

-- CONCAT(문자열1, 문자열2 ..) -문자열 이어줌
-- CONCAT_WS(구분자, 문자열1, 문자열2 ..) -구분자와 함꼐 문자열 이어줌
SELECT CONCAT('가','나');
SELECT CONCAT_WS('/','2025','01','01');

-- ELT(위치, 문자열1, 문자열2 ..) -위치 번째에 해당하는 문자열 반환
-- FIELD(찾을 문자열, 문자열1, 문자열2 ..) -찾을 문자열의 위치를 찾아 반환, 없으면 0
-- FIND_IN_SET(찾을 문자열, 문자열 리스트) -찾을 문자열을 문자열 리스트에서 찾아 위치 반환, 문자열 리스트는 콤마로 구분되며 공백 없어야 함
-- INSRT(기준 문자열, 부분 문자열) -기준 문자열에서 부분 문자열 찾아 그 시작 위치 반환
-- LOCATE(부분 문자열, 기준 문자열) -INSRT()와 동일, 파라미터의 순서만 반대
SELECT ELT(2, '하나', '둘', '셋'), FIELD('둘','하나','둘','셋'), FIND_IN_SET('둘','하나,둘,셋');
SELECT INSTR('하나둘셋','둘'), LOCATE('둘','하나둘셋');

-- FORMAT(숫자, 소수점 자릿수) - 숫자를 소수점 아래 자릿수까지 표현, 1000단위마다 콤마 표시
SELECT FORMAT(123456.123456,4);

-- BIN(숫자), HEX(숫자), OCT(숫자) -2진수, 16진수, 8진수의 값을 반환
SELECT BIN(31), HEX(31), OCT(31);

-- INSERT(기준 문자열, 위치, 길이, 삽입할 문자열) -기준 문자열의 위치부터 길이만큼 지우고 삽입할 문자열 끼워 넣음
SELECT INSERT('abcdefghi',3,4,'@@@@'), INSERT('abcdefghi',3,2,'@@@@');

-- LEFT(문자열, 길이), RIGHT(문자열, 길이) -왼쪽 또는 오른쪽에서 문자열의 길이만큼 반환
SELECT LEFT('abcdefghi',3), RIGHT('abcdefghi',3);

-- UPPER(문자열), LOWER(문자열) -소문자를 대문자로, 대문자를 소문자로 변경
SELECT UPPER('abcd'), LOWER('ABCD');

-- LAPD(문자열, 길이, 채울 문자열), RPAD(문자열, 길이, 채울 문자열) -문자열을 길이만큼 필드폭을 잡은 후에 빈 곳(좌/우)에 지정한 문자열을 채움
SELECT LPAD('이것이',5,'-- -- '), RPAD('이것이',5,'-- -- ');

-- LTRIM(문자열), RTRIM(문자열) -문자열의 왼쪽/오른쪽 공백을 제거, 중간의 공백은 제거되지 않음
SELECT LTRIM('  이것이'), RTRIM('이것이   ');

-- TRIM(문자열) -문자열의 앞뒤 공백 모두 없앰
-- TRIM(방향 제거할 문자열 FROM 문자열) -방향은 LEADING(앞), BOTH(양쪽), TRAILING(뒤)으로 표시
SELECT TRIM('    이것이'), TRIM(BOTH 'ㅋ' FROM 'ㅋㅋㅋㅋㅋㅋ재밌어요.ㅋㅋㅋ');

-- REPEAT(문자열, 횟수) -문자열을 횟수만큼 반복
SELECT REPEAT('이것이',3);

-- REPLACE(문자열, 원래 문자열, 비꿀 문자열) -문자열에서 원래 문자열을 찾아서 바꿀 문자열로 바꿈
SELECT REPLACE('이것이 MySQL이다','이것이','This is');

-- REVERSE(문자열) -문자열의 순서를 거꾸로 바꿈
SELECT REVERSE('abc'), REVERSE('가나다');

-- SPACE(길이) -길이만큼 공백을 반환
SELECT CONCAT('이것이', SPACE(10),'MySQL이다');

-- SUBSTRING(문자열, 시작위치, 길이) 또는 SUBSTRING(문자열 FROM 시작위치 FOR 길이) -시작위치부터 길이만큼 문자를 반환, 길이가 생략되면 문자열의 끝까지 반환
SELECT SUBSTRING('대한민국만세',3,2);

-- SUBSTRING_INDEX(문자열, 구분자, 횟수) -문자열에서 구분자가 왼쪽부터 지정한 횟수 번째까지 나오면 그 이후의 오른쪽은 버리고 반환, 횟수가 음수이면 오른쪽부터 세고 왼쪽을 버림
SELECT SUBSTRING_INDEX('cafe.naver.com','.',2), SUBSTRING_INDEX('cafe.naver.com','.',-2);


-- 수학 함수
-- ABS(숫자) -숫자의 절댓값 계산
-- ACOS(숫자), ASIN(숫자), ATAN(숫자), ATAN2(숫자1, 숫자2), SIN(숫자), COS(숫자), TAN(숫자) -(역)삼각 함수와 관련된 함수 제공
-- CEILING(숫자), FLOOR(숫자), ROUND(숫자) -소수점 이하를 무조건 올림, 내림, 반올림하여 정수화
-- CONV(숫자, 원래 진수, 변환할 진수) -숫자를 원래 진수에서 변환할 진수로 계산
-- DEGREES(라디안값), RADIANDS(각도값), PI() -라디안 값을 각도값으로, 각도값을 라디안 값으로 변환, PI()는 3.141593 반환
-- EXP(X), LN(숫자), LOG(숫자), LOG(밑수, 숫자), LOG2(숫자), LOG10(숫자) -EXP는 지수함수로 e(2.718281)의 거듭제곱 값 반환, LN은 자연로그(밑이 e) 값 반환
-- MOD(숫자1, 숫자2) 또는 숫자1 % 숫자2 또는 숫자1 MOD 숫자2 -숫자1을 숫자2로 나눈 나머지 값을 구함
-- POW(숫자1, 숫자2), SQRT(숫자) -거듭제곱값 및 제곱근을 구함
-- RAND() -0 이상 1미만의 실수 구함, m<=임의의 정수<n을 구하고 싶다면, FLOOR(m + RAND()*(n-m)) 사용
-- SIGN(숫자) -부호 정보 반환, 숫자가 양수, 0, 음수인지 판별, 결과는 -1, 0, 1 셋 중에 하나 반환
-- TRUNCATE(숫자, 정수) -숫자를 소수점을 기준으로 정수 위까지 구하고 나머지는 버림

SELECT ABS(1.1), ABS(-1.1), ABS(5);
SELECT COS(10), SIN(10), TAN(10);
SELECT CEILING(1.1), FLOOR(1.1), ROUND(1.1), ROUND(1.6);
SELECT CONV('AA',16,2), CONV(100,10,8);
SELECT DEGREES(PI()), RADIANS(PI());
SELECT EXP(1), EXP(2), LOG(10), LOG(10,2), LOG2(10), LOG10(10);
SELECT MOD(157,10), 157 % 10, 157 MOD 10;
SELECT POW(2,3), SQRT(8);
SELECT FLOOR(1 + RAND()*(6-1));
SELECT SIGN(10), SIGN(0), SIGN(-9);
SELECT TRUNCATE(12345.12345,2), TRUNCATE(12345.12345,-2);


-- 날짜 및 시간 함수
-- ADDDATE(날짜, 차이), SUBDATE(날짜, 차이) -날짜를 기준으로 차이를 더하거나 뺀 날짜 구함
-- ADDTIME(날짜/시간, 시간), SUBTIME(날싸/시간, 시간) -날짜/시간을 기준으로 시간을 더하거나 뺀 결과를 구함
-- CURDATE(), CURTIME(), SYSDATE() -현재 연-월-일, 현재 시:분:초, 현재 '연-월-일 시:분:초'
-- YEAR(날짜), MONTH(날짜), DAY(날짜), HOUR(시간), MINUTE(시간), SECOND(시간), MICROSECOND(시간) -날짜 또는 시간에서 연, 월, 일, 시, 분, 초, 밀리초 구함
-- DATE(날짜), TIME(날짜) -DATETIME형식에서 연-월-일 또는 시:분:초 추출
-- DATEDIFF(날짜1, 날짜2), TIMEDIFF(날짜1 또는 시간1, 날짜2 또는 시간2) -날짜1-날짜2의 경과 일수(시간이면 경과된 시:분:초를 결과로 구함)
-- DAYOFWEEK(날짜), MONTHNAME(날짜), DAYOFYEAR(날짜) -요일 정보 반환(1:일, 2:월~7:토), 월 반환, 1년 중 몇 번째 날짜인지 반환
-- LAST_DAY(날짜) -주어진 날짜의 마지막 날짜 반환
-- MAKEDATE(연도, 정수) -연도에서 정수만큼 지난 날짜 반환
-- MAKETIME(시, 분, 초) -시, 분, 초를 이용해서 '시:분:초'의 TIME 형식 만듦
-- PERIOD_ADD(연월, 개월수)는 연월에서 개월만큼의 지난 연월 구함
-- PERIOD_DIFF(연월1, 연월2) -연월1-연월2의 개월수 구함
-- QUARTER(날짜) -날짜가 4분기 중에서 몇 분기인지를 구함
-- TIME_TO_SEC(시간) -시간을 초 단위로 구함

SELECT ADDDATE('2025-01-01', INTERVAL 31 DAY), ADDDATE('2025-01-01', INTERVAL 1 MONTH);
SELECT SUBDATE('2025-01-01', INTERVAL 31 DAY), SUBDATE('2025-01-01', INTERVAL 1 MONTH);
SELECT ADDTIME('2025-01-01 23:59:59','1:1:1'), ADDTIME('15:00:00','2:10:10');
SELECT SUBTIME('2025-01-01 23:59:59','1:1:1'), SUBTIME('15:00:00','2:10:10'); 
SELECT CURDATE(), CURTIME(), NOW(), SYSDATE();
SELECT YEAR(CURDATE()), MONTH(CURDATE()), DAY(CURDATE()), DAYOFMONTH(CURDATE());
SELECT HOUR(CURTIME()), MINUTE(CURTIME()), SECOND(CURTIME()), MICROSECOND(CURTIME());
SELECT DATE(NOW()), TIME(NOW());
SELECT DATEDIFF('2025-01-01',NOW()), TIMEDIFF('23:59:59','12:11:00');
SELECT DAYOFWEEK(CURDATE()), MONTHNAME(CURDATE()), DAYOFYEAR(CURDATE());
SELECT LAST_DAY('2025-02-01');
SELECT MAKEDATE(2025,32);
SELECT MAKETIME(12,11,10);
SELECT PERIOD_ADD(202501,11), PERIOD_DIFF(202501,202312);
SELECT QUARTER('2025-07-07'), QUARTER(NOW());
SELECT TIME_TO_SEC('12:11:10');

-- 그 외 함수
SELECT CURRENT_USER(), DATABASE();

USE sqldb;
SELECT * FROM usertbl;
SELECT FOUND_ROWS(); -- 바로 앞에서 조회된 행의 개수

UPDATE buytbl SET price=price*2;
SELECT ROW_COUNT(); -- 입력, 수정 및 삭제된 행의 개수
SELECT * FROM buytbl;

SELECT VERSION(); -- mysql 버전

SELECT SLEEP(5); -- 쿼리의 실행을 5초간 멈춤
SELECT '5초후에 이게 보여요';



-- -- LongText 텍스트 데이터 및 LongBlob 영상 데이터 형식 실습
-- 영화 대본 파일 3개(txt), 동영상 파일 3개(mp4)을 C:\SQL\Movies 에 준비
-- 1) txt 파일은 UTF-8 인코딩으로 변경하여 저장
-- 2) moviedb, movietbl 생성
CREATE DATABASE moviedb;

USE moviedb;
CREATE TABLE movietbl
	(movie_id INT, movie_title VARCHAR(30), movie_director VARCHAR(20), movie_star VARCHAR(20),
    movie_script LONGTEXT, movie_film LONGBLOB) DEFAULT CHARSET = utf8mb4;

-- 3) 최대 패킷(파일) 크기 형식, 파일 업로드/다운로드 폴더 경로 설정

-- 4) 데이터 입력
INSERT INtO movietbl VALUES(1,'쉰들러 리스트','스필버그','리암 니슨',
	LOAD_FILE('C:/SQL/Movies/Schindler.txt'), LOAD_FILE('C:/SQL/Movies/Schindler.mp4'));
SELECT * FROM movietbl;

-- 5) Into outfile문 이용하여 txt 파일 내려받기(다운로드)
SELECT movie_script FROM movietbl WHERE movie_id=1
	INTO OUTFILE 'C:/SQL/Movies/Schindler_out.txt'
	LINES TERMINATED BY '\\n';

-- 6) Into dumpfile문 이용하여 동영상을 바이너리 파일로 내려받기(다운로드)
SELECT movie_film FROM movietbl WHERE movie_id=1
	INTO DUMPFILE 'C:/SQL/Movies/Mochican_out.mp4';

-- -- 피벗의 구현
-- 피벗(pivot) -한 열에 포함된 여러 값을 출력하고 이를 여러 열로 변환하여 테이블을 회전, 필요하면 집계도 수행, group by을 이용하여 구현 가능
USE sqldb;
CREATE TABLE pivotTest
	(uName CHAR(3), season CHAR(2), amount INT);

INSERT INTO pivotTest VALUES
	('김범수' , '겨울', 10) , ('윤종신' , '여름', 15) , ('김범수' , '가을', 25) , ('김범수' , '봄', 3) ,
    ('김범수' , '봄', 37) , ('윤종신' , '겨울', 40) , ('김범수' , '여름', 14) ,('김범수' , '겨울', 22) , ('윤종신' , '여름', 64) ;
SELECT * FROM pivotTest;

-- sum(), if() 함수, group by 활용하여 피벗 테이블 생성
SELECT uName,
	SUM(IF(SEASON='봄',amount,0)) AS '봄',
    SUM(IF(SEASON='여름',amount,0)) AS '여름',
    SUM(IF(SEASON='가을',amount,0)) AS '가을',
    SUM(IF(SEASON='겨울',amount,0)) AS '겨울',
    SUM(amount) AS '합계' FROM pivotTest GROUP BY uName;
	
	
-- -- JSON 데이터
-- JSON(JavaScript Object Notation) -웹과 모바일 프로그래밍 등이 데이터를 교환하기 위한 개방형 표준 포맷. 속성(key)과 값(value) 쌍으로 구성
-- sqldb의 usertbl에서 키가 180이상인 사람의 이름과 키를 나타내는 테이블을 json 데이터로 변환
SELECT JSON_OBJECT('name',name,'height',height) AS 'JSON 값'
	FROM usertbl WHERE height >= 180;

-- 내장함수를 사용하여 운영
-- usertbl로 테이블 이름을 지정하여 json 변수에 json 데이터 대입
SET @json = '{
	"usertbl" : [
		{"name":"임재범","height":182},
        {"name":"이승기","height":182},
        {"name":"성시경","height":186}]
	}';
SELECT @json;

-- 다양한 내장함수
SELECT JSON_VALID(@json) AS JSON_VALID; -- json 형식 만족 여부 (1,0)
SELECT JSON_SEARCH(@json, 'one', '성시경') AS JSON_SEARCH; -- 매치되는 문자열 위치 한 개 반환
SELECT JSON_EXTRACT(@json, '$.usertbl[2].name') AS JSON_EXTRACT; -- 지정한 값 반환
SELECT JSON_INSERT(@json, '$.usertbl[0].mDate','2009-09-09') AS JSON_INSERT; -- 추가
SELECT JSON_REPLACE(@json, '$.usertbl[0].name','홍길동') AS JSON_REPLACE; -- 변경
SELECT JSON_REMOVE(@josn, '$.usertbl[0]') AS JSON_REMOVE; --삭제
SELECT @json;


