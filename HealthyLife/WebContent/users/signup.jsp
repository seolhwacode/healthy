<%@page import="test.users.dao.UsersDao"%>
<%@page import="test.users.dto.UsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//form 의 id, pwd 읽어오기
	String id = request.getParameter("id");
	String pwd = request.getParameter("pwd");
	
	//UsersDto 객체에 회원 정보 담기
	UsersDto dto = new UsersDto();
	dto.setId(id);
	dto.setPwd(pwd);
	
	//UsersDao 객체를 이용해 DB 에 insert
	boolean isSuccess = UsersDao.getInstance().insert(dto);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/users/signup.jsp</title>
</head>
<body>
	<div class="container">
	<%if(isSuccess){ %>
		<p><strong><%=id %></strong> 회원님. 가입되었습니다.</p>
		<a href="${pageContext.request.contextPath}/users/login.jsp">로그인</a>
	<%}else{ %>
		<p>회원가입에 실패했습니다.</p>
		<a href="${pageContext.request.contextPath}/users/login_form.jsp">회원가입으로 돌아가기</a>
	<%} %>
	</div>
</body>
</html>