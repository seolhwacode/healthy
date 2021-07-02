<%@page import="test.users.dao.UsersDao"%>
<%@page import="test.users.dto.UsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//login_form.jsp 의 form 에서 전송되는 값 읽어오기
	String id = request.getParameter("id");
	String pwd = request.getParameter("pwd");
	
	//UsersDto 를 생성하여 읽어온 id, pw 담기
	UsersDto dto = new UsersDto();
	dto.setId(id);
	dto.setPwd(pwd);
	
	//UsersDao 의 isValid 메소드를 사용하여 db 에 id/pwd 매칭 되는지 확인
	boolean isValid = UsersDao.getInstance().isValid(dto);
	
	//isValid == true : 로그인 성공 -> session 에 "id" 라는 key 이름으로 id 값을 넣는다.
	session.setAttribute("id", id);
	//응답
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/users/login.jsp</title>
</head>
<body>
	<%if(isValid){ %>
		<div>
			<strong><%=id %></strong> 님이 로그인되었습니다.
			<br />
			<a href="${pageContext.request.contextPath}/index.jsp">홈으로 돌아가기</a>
		</div>
	<%}else{ %>
		<div>
			아이디 혹은 비밀번호가 틀렸습니다.
			<br />
			<a href="${pageContext.request.contextPath}/index.jsp">홈으로 돌아가기</a>
			<a href="${pageContext.request.contextPath}/users/login_form.jsp">다시 시도</a>
		</div>
	<%} %>
</body>
</html>