<%@page import="java.net.URLEncoder"%>
<%@page import="test.users.dao.UsersDao"%>
<%@page import="test.users.dto.UsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//로그인 후에 이동해야할 목적지를 form 에서 읽어온다.
	String url = request.getParameter("url");
	//목적지 인코딩 -> 로그인 실패일 경우, 다시 뒤에 get 방식으로 넣어주여야 하기 때문
	String encodedUrl = URLEncoder.encode(url);

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
	if(isValid)
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
			<%-- 그냥 확인을 누르면 login_form.jsp 를 호출했던 page 로 이동한다. --%>
			<a href="<%=url %>">확인</a>
			<br />
			<a href="${pageContext.request.contextPath}/index.jsp">메인으로 돌아가기</a>
		</div>
	<%}else{ %>
		<div>
			아이디 혹은 비밀번호가 틀렸습니다.
			<br />
			<a href="${pageContext.request.contextPath}/index.jsp">메인으로 돌아가기</a>
			<a href="${pageContext.request.contextPath}/users/login_form.jsp?url=<%=encodedUrl %>">다시 시도</a>
		</div>
	<%} %>
</body>
</html>