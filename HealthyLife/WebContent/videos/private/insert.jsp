<%@page import="videos.board.dao.VideosDao"%>
<%@page import="videos.board.dto.VideosDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//로그인된 아이디를 session 영역에서 가져오기
	String writer = (String)session.getAttribute("id");
	
	//폼에서 전송되는 title, video, content, type 읽어오기
	String title = request.getParameter("title");
	String video = request.getParameter("video");
	String content = request.getParameter("content");
	String type = request.getParameter("type");
	
	//VideosDto 생성
	VideosDto dto = new VideosDto();
	dto.setWriter(writer);
	dto.setTitle(title);
	dto.setVideo(video);
	dto.setContent(content);
	dto.setType(type);
	
	//VideosDao 사용하여 db 에 저장
	boolean isSuccess = VideosDao.getInstance().insert(dto);
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/videos/private/insert.jsp</title>
</head>
<body>
<%if(isSuccess){ %>
	<script>
		alert("새 글이 추가되었습니다.");
		location.href = "${pageContext.request.contextPath}/videos/list.jsp";
	</script>
<%}else{ %>
	<script>
		alert("새 글이 추가되었습니다.");
		location.href = "${pageContext.request.contextPath}/videos/private/insert_form.jsp";
	</script>
<%} %>
</body>
</html>