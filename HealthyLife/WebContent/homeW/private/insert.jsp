<%@page import="test.homeW.dto.HomeWDto"%>
<%@page import="test.homeW.dao.HomeWDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//로그인된 아이디 session 영역에서 얻어내기
	String writer=(String)session.getAttribute("id");
	//폼에 전송되는 title, content 내용 읽어오기
	String title=request.getParameter("title");
	String content=request.getParameter("content");
	//위의 내용을 DB에 저장하기 
	HomeWDto dto=new HomeWDto();
	dto.setWriter(writer);
	dto.setTitle(title);
	dto.setContent(content);
	boolean isSuccess=HomeWDao.getInstance().insert(dto);
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/homeW/private/insert.jsp</title>
</head>
<body>
	<%if(isSuccess) {%>
		<script>
			alert("성공적으로 글이 작성 되었습니다");
			location href="${pageContext.request.contextPath}/homeW/list.jsp"
		</script>
	<%}else{ %>
		<script>
			alert("글 작성이 실패 되었습니다");
			loaction href="${pageContext.request.contextPath}/homeW/private/insert_form.jsp"
		</script>	
	<%} %>
</body>
</html>