-- db 에서 사용할 table, sequence 정의를 기록해주세요.

-- 사용자(회원) 정보를 저장할 테이블
CREATE TABLE users(
	id VARCHAR2(100) PRIMARY KEY,	-- 사용자 id
	pwd VARCHAR2(100) NOT NULL,	-- 사용자 password
	profile VARCHAR2(100),	-- 프로필 이미지 경로를 저장할 컬럼
	regdate DATE	-- 가입일
);


