<%@page import="test.users.dao.UsersDao"%>
<%@page import="test.users.dto.UsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//session 에서 현재 로그인된 id 가져오기
	String id = (String)session.getAttribute("id");
	
	//로그인된 id 를 UsersDto 에 담기
	UsersDto dto = new UsersDto();
	dto.setId(id);
	
	//UsersDao 객체를 이용해서 가입된 정보를 가져오기
	UsersDto resultDto = UsersDao.getInstance().getData(dto);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/users/private/info.jsp</title>
<jsp:include page="../../include/resource.jsp"></jsp:include>
</head>
<body>
	<div class="container">
		<h1>가입 정보입니다.</h1>
		
		<!-- 가입 정보 출력 -->
		<table>
			<tr>
				<th>프로필 사진</th>
				<td><%=resultDto.getProfile() %></td>
			</tr>
			<tr>
				<th>id</th>
				<td><%=resultDto.getId() %></td>
			</tr>
		</table>
		
		<a href="">프로필 변경</a>
		<a href="${pageContext.request.contextPath}/users/private/pwd_update_form.jsp">비밀번호 변경</a>
		<a href="${pageContext.request.contextPath}/users/private/delete.jsp">탈퇴</a>
		
	</div>
</body>
</html>