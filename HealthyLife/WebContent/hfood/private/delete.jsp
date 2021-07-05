<%@page import="hfood.board.dao.HfoodDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int num=Integer.parseInt(request.getParameter("num"));
	boolean isSuccess=HfoodDao.getInstance().delete(num);
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/hfood/private/delete.jsp</title>
</head>
<body>
	<%if(isSuccess){ %>
		<script>
			alert("삭제 완료!");
			location.href="${pageContext.request.contextPath }/hfood/list.jsp"
		</script>
	<%}else{ %>
		<script>
			alert("삭제 실패!");
			location.href="detail.jsp?num=<%=num%>";
		</script>
	<%} %>
</body>
</html>