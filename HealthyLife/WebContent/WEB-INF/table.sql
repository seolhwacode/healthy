-- db 에서 사용할 table, sequence 정의를 기록해주세요.

-- 사용자(회원) 정보를 저장할 테이블
CREATE TABLE users(
	id VARCHAR2(100) PRIMARY KEY,	-- 사용자 id
	pwd VARCHAR2(100) NOT NULL,	-- 사용자 password
	profile VARCHAR2(100),	-- 프로필 이미지 경로를 저장할 컬럼
	regdate DATE	-- 가입일
);

-- 비디오 자료실 테이블
CREATE TABLE video_board(
	num NUMBER PRIMARY KEY,	-- 글번호
	writer VARCHAR2(100) NOT NULL,	-- 작성자(users의 id)
	title VARCHAR2(100) NOT NULL,	-- 글 제목
	content CLOB,	-- 글 내용
	video VARCHAR2(200) NOT NULL,	-- 비디오 link
	view_count NUMBER DEFAULT 0,	-- 조회수
	regdate DATE,	-- 글 작성일
	good_count NUMBER DEFAULT 0,	-- 좋아요 수
	type VARCHAR2(100)	-- 게시판 종류(운동 분류)
);

-- 비디오 자료실의 게시글 번호를 얻어낼 시퀀스
CREATE SEQUENCE video_board_seq;

-- video_board - getData : 검색어 없을 때
SELECT *
FROM
	(SELECT num, writer, title, content, video, view_count, regdate, good_count, type,
	LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum,
	LEAD(num, 1, 0) OVER(ORDER BY num DESC) AS nextNum
	FROM video_board
	ORDER BY num DESC)
WHERE num = 21;

