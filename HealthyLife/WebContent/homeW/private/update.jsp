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
	<%if(isSuccess){ %>
      <script>
         alert("수정 되었습니다");
         location.href="../detail.jsp?num=<%=dto.getNum()%>";
      </script>
   <%}else{ %>
      <h1>알림</h1>
      <p>
         글 수정을 실패했습니다
         <a href="updateform.jsp?num=<%=dto.getNum()%>">다시 시도</a>
      </p>
   <%} %>
</body>
</html>