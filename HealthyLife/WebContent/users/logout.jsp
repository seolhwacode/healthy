<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//session key 가 "id" 인  속성 삭제하기
	session.removeAttribute("id");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/users/logout.jsp</title>
</head>
<body>
	<script>
		alert("성공적으로 로그아웃 되었습니다.");
		//index.jsp 로 리다이렉트
		location.href = "${pageContext.request.contextPath}/index.jsp";
	</script>
</body>
</html>