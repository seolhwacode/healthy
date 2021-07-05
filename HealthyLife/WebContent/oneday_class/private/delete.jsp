<%@page import="oneday.booking.dao.BookingDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int num = Integer.parseInt(request.getParameter("num"));
	boolean isSuccess=BookingDao.getInstance().delete(num);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
  <%if(isSuccess){%>
      <script>
         alert("삭제 했습니다.");
         location.href="bookingList.jsp";
      </script>
   <%}else{%>
      <script>
         alert("삭제 실패!");
         location.href="detail.jsp?num=<%=num%>";
      </script>
   <%} %>
</body>
</html>