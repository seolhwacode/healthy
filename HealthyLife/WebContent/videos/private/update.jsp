<%@page import="videos.board.dao.VideosDao"%>
<%@page import="videos.board.dto.VideosDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//1. 폼 전송되는 수정할 글의 번호, 제목, 동영상 주소, 내용을 읽어온다.
	int num = Integer.parseInt(request.getParameter("num"));
	String title = request.getParameter("title");
	String video = request.getParameter("video");
	String content = request.getParameter("content");

	// 2. VideosDto 객체를 생성해서 담는다.
	VideosDto dto = new VideosDto();
	dto.setNum(num);
	dto.setTitle(title);
	dto.setVideo(video);
	dto.setContent(content);
	
	// 3. DB 에 수정 반영하고
	boolean isSuccess = VideosDao.getInstance().update(dto);
	
	// 4. 응답
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/videos/private/update.jsp</title>
</head>
<body>
<%if(isSuccess){ %>
	<script>
		alert("수정했습니다.");
		location.href = "${pageContext.request.contextPath}/videos/detail.jsp?num=<%=num %>";
	</script>
<%}else{ %>
	<script>
		alert("수정 실패!");
		location.href = "${pageContext.request.contextPath}/videos/detail.jsp?num=<%=num %>";
	</script>
<%} %>
</body>
</html>