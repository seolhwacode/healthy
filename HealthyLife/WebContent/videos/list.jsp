<%@page import="java.util.List"%>
<%@page import="kang.videos.dao.VideosDao"%>
<%@page import="kang.videos.dto.VideosDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//여러 페이지에 나눠서 출력하기 - 여기서는 한 페이지에 10개!
	//한 페이지에 몇개씩 표시할 것인지
	final int PAGE_ROW_COUNT=5;
	//하단 페이지를 몇개씩 표시할 것인지
	final int PAGE_DISPLAY_COUNT=5;
	
	//보여줄 페이지의 번호를 일단 1이라고 초기값 지정
	int pageNum=1;
	
	//페이지 번호가 파라미터로 전달 되었는지 확인
	String strPageNum = request.getParameter("pageNum");
	//만일 페이지 번호가 파라미터로 넘어오면
	if(strPageNum != null){
		//숫자로 바꿔, 보여줄 페이지 번호로 지정
		pageNum = Integer.parseInt(strPageNum);
	}
	
	//보여줄 페이지의 시작 ROWNUM
	int startRowNum = 1 + (pageNum - 1) * PAGE_ROW_COUNT;
	//보여줄 페이지의 끝 ROWNUM
	int endRowNum = pageNum * PAGE_ROW_COUNT;
	
	/*
		[검색 키워드에 관련된 처리]
		- 검색 키워드가 파라미터로 넘어올 수도 있고 안넘어올 수도 있다.
	*/
	//아직 안할 것 -> 좀 이따가 하기
	
	
	//1. 게시판 목록을 읽어오기 위한 startRowNum, endRowNum 지정
	VideosDto dto = new VideosDto(startRowNum, endRowNum);
	
	//2. VideosDao 를 사용해서 list 읽어오기
	List<VideosDto> list = VideosDao.getInstance().getList(dto);

	//하단 시작 페이지 번호
	int startPageNum = 1 + ((pageNum - 1) / PAGE_DISPLAY_COUNT) * PAGE_DISPLAY_COUNT;
	//하단 끝 페이지 번호
	int endPageNum = startPageNum + PAGE_DISPLAY_COUNT - 1;
	
	//전체 row 의 개수
	int totalPageCount = VideosDao.getInstance().getCount();
	
	//끝 페이지 번호가 전체 페이지 개수보다 크다면, 잘못된 값이다.
	if(endPageNum > totalPageCount){
		//보정해준다.
		endPageNum = totalPageCount;
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/videos/list.jsp</title>
</head>
<body>
	<div class="container">
		<a href="">새 글 작성</a>
		<h1>글 목록입니다.</h1>
		<table>
			<thead>
				<tr>
					<th>글 번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>등록일</th>
					<th>조회수</th>
					<th>좋아요</th>
				</tr>
			</thead>
			<tbody>
			<%for(VideosDto tmp:list){ %>
				<tr>
					<td><%=tmp.getNum() %></td>
					<td><a href=""><%=tmp.getTitle() %></a></td>
					<td><%=tmp.getWriter() %></td>
					<td><%=tmp.getRegdate() %></td>
					<td><%=tmp.getView_count() %></td>
					<td><%=tmp.getGood_count() %></td>
				</tr>
			<%} %>
			</tbody>
		</table>
		
		<!-- 페이지 표기 -->
		
	</div>
</body>
</html>