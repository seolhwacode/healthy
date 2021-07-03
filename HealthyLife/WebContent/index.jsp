<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//로그인 상태 확인 : session 에 "id" 값 가져오기
	// id == null : 로그인 되지 않은 상태
	// id != null : 로그인 된 상태
	String id = (String)session.getAttribute("id");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/index.jsp</title>
</head>
<body>
	<div class="container">
		<h1>인덱스 페이지입니다.</h1>
		<%if(id != null){ %>
			<p>
				<a href=""><%=id %></a> 님 로그인 중...
				<a href="${pageContext.request.contextPath}/users/logout.jsp">로그아웃</a>
			</p>
		<%} %>
		<ul>
			<!-- 해당 게시판으로 가는 link 추가해주세요. -->
			<li><a href="${pageContext.request.contextPath}/users/signup_form.jsp">회원가입</a></li>
			<li><a href="${pageContext.request.contextPath}/users/login_form.jsp">로그인</a></li>
		</ul>
	</div>
</body>
</html>