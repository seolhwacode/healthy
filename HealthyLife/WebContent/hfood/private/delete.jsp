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
		<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
		<script>
		 swal({
			 title: "레시피가 삭제되었습니다.",
	    	 button: "넵",
		}).then(function() {
			location.href="${pageContext.request.contextPath }/hfood/list.jsp"
		});
		 </script>
	<%}else{ %>
		<script>
		 swal({
			 title: "삭제를 다시 시도해주세요",
	    	 button: "넵",
		}).then(function() {
			location.href="${pageContext.request.contextPath }/hfood/list.jsp"
		});
		 </script>
	<%} %>
</body>
</html>