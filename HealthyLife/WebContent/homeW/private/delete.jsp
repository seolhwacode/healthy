<%@page import="test.homeW.dao.HomeWDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//해당 글 읽어오기
	int num=Integer.parseInt(request.getParameter("num"));
	//삭제할 글 작성자와 로그인된 아이디 같은지 비교하기
	String writer=HomeWDao.getInstance().getData(num).getWriter();
	String id=(String)session.getAttribute("id");
	
	//아이디와 작성자가 다를때
	if(!writer.equals(id)){
		response.sendError(HttpServletResponse.SC_FORBIDDEN, "아이디가 일치 하지 않습니다");
		return;
	}
	//아이디와 작성자가 같을 때
	boolean isSuccess=HomeWDao.getInstance().delete(num);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/homeW/private/delet.jsp</title>
</head>
<body>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
	<%if(isSuccess) {%>
		<script>
			swal({
			 	  title: "삭제 되었습니다",
			 	  icon: "success",
			 	  button: "확인",
			 	  
			 	}).then(function() {
			 		location.href="../list.jsp";
			 	});
		</script>
	<%}else{ %>	
		<script>
			swal({
			 	  title: "삭제 실패",
			 	  icon: "success",
			 	  button: "확인",
			 	  
			 	}).then(function() {
			 		location.href="detail.jsp?num=<%=num%>";
			 	});
		</script>
	<%} %>
</body>
</html>