<%@page import="test.homeW.dao.HomeWDao"%>
<%@page import="test.homeW.dto.HomeWDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int num=Integer.parseInt(request.getParameter("num"));
	String title=request.getParameter("title");
	String content=request.getParameter("content");
	
	HomeWDto dto=new HomeWDto();
	dto.setNum(num);
	dto.setTitle(title);
	dto.setContent(content);
	
	boolean isSuccess=HomeWDao.getInstance().update(dto);
	
	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/homeW/private/update.jsp</title>
</head>
<body>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<%if(isSuccess){ %>
      <script>
	      swal({
		 	  title: "수정 되었습니다",
		 	  icon: "success",
		 	  button: "확인",
		 	  
		 	}).then(function() {
		 		location.href="../detail.jsp?num=<%=dto.getNum()%>";
		 	});   
      </script>
   <%}else{ %>
   	<script>
	   	swal({
		 	  title: "수정 실패",
		 	  icon: "warning",
		 	  button: "다시 시도",
		 	  
		 	}).then(function() {
		 		location.href="update_form.jsp?num=<%=dto.getNum()%>";
		 	});
   	</script>
   <%} %>
</body>
</html>