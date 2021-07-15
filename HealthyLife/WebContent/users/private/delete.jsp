<%@page import="test.users.dao.UsersDao"%>
<%@page import="test.users.dto.UsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//1. session 영역에서 id 가져오기
	String id = (String)session.getAttribute("id");
	
	//2. id 를 dto 에 담는다.
	UsersDto dto = new UsersDto();
	dto.setId(id);
	
	//3. DB 에서 users 테이블에서 id 에 해당하는 row 를 삭제한다.
	boolean isSuccess = UsersDao.getInstance().delete(dto);
	
	//4. 응답
	if(isSuccess){
		//탈퇴 성공 -> 로그아웃
		session.removeAttribute("id");
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/users/private/delete.jsp</title>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
</head>
<body>
<%if(isSuccess){ %>
	<script>
		//alert("<%=id %> 님이 탈퇴처리 되었습니다.");
		swal({
    	  	title: "<%=id %> 님이 탈퇴처리 되었습니다.",
    	  	icon: "success"
    	})
    	.then(function(){
    		location.href = "${pageContext.request.contextPath}/index.jsp";
    	});
	</script>
<%}else{%>
	<script>
		//alert("탈퇴하지 못했습니다.");
		swal({
    	  	title: "탈퇴하지 못했습니다.",
    	  	icon: "error"
    	})
    	.then(function(){
    		location.href = "${pageContext.request.contextPath}/users/private/info.jsp";
    	});
	</script>
<%} %>
</body>
</html>