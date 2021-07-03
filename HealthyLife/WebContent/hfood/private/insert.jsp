
<%@page import="hfood.board.dao.HfoodDao"%>
<%@page import="hfood.board.dto.HfoodDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//로그인된 아이디를 session 영역에서 얻어내기
	String writer=(String)session.getAttribute("id");
	//1. 폼 전송되는 글 제목과 내용을 읽어와서
	String title=request.getParameter("title");
	String content=request.getParameter("content");
	//2. DB에 저장하고 
	HfoodDto dto= new HfoodDto();
	dto.setWriter(writer);
	dto.setTitle(title);
	dto.setContent(content);
	boolean isSuccess=HfoodDao.getInstance().insert(dto);
	//3. 응답하기.
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/hfood/private/insert.jsp</title>
</head>
<body>
	<%if(isSuccess){ %>
	<script>
		alert("새글 추가 완료 !");
		location.href="${pageContext.request.contextPath}/hfood/list.jsp";
	</script> 
	<%}else{ %>
	<script>
		alert("글 저장 실패!");
		location.href="${pageContext.request.contextPath}/hfood/private/insertform.jsp";
	</script>
	<%} %>
</body>
</html>