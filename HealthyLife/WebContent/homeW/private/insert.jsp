
<%@page import="test.homeW.dao.HomeWDao"%>
<%@page import="test.homeW.dto.HomeWDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   //로그인된 아이디를 session 영역에서 얻어내기
   String writer=(String)session.getAttribute("id");
   //1. 폼 전송되는 글제목과 내용을 읽어와서
   String title=request.getParameter("title");
   String content=request.getParameter("content");
   //2. DB 에 저장하고
   HomeWDto dto=new HomeWDto();
   dto.setWriter(writer);
   dto.setTitle(title);
   dto.setContent(content);
   boolean isSuccess=HomeWDao.getInstance().insert(dto);
   //3. 응답하기 
%>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/HomeW/private/insert.jsp</title>
</head>
<body>
   <%if(isSuccess){ %>
   <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
   <script>
	   swal({
	 	  title: "새글이 등록되었습니다!",
	 	  icon: "success",
	 	  button: "확인",
	 	  
	 	}).then(function() {
	 		location.href="../list.jsp";
	 	});
   </script>
   <%}else{ %>
   <script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
   <script>
	   swal({
	     	title: "작성 실패!",
	     	button: "다시 작성하기"     	  
	 	}).then(function() {
	 		location.href="insert_form.jsp";
	 	});
   </script>
   <%} %>
</body>
</html>




