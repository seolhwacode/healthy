<%@page import="oneday.booking.dao.BookingDao"%>
<%@page import="oneday.booking.dto.BookingDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String name = request.getParameter("name");
	String writer = (String)session.getAttribute("id");
	String phone = request.getParameter("phone");
	String className = request.getParameter("className");
	String date = request.getParameter("date");
	String mention = request.getParameter("mention");
		
	BookingDto dto = new BookingDto();
	dto.setName(name);
	dto.setWriter(writer);
	dto.setPhone(phone);
	dto.setClassName(className);
	dto.setClassDate(date);
	dto.setMention(mention);
	
	boolean isSuccess = BookingDao.getInstance().insert(dto);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/oneday_class/booking.jsp</title>
</head>
<body>
	<%if(isSuccess){ %>
	<script>
      alert("예약이 완료되었습니다.");
      location.href="bookingList.jsp";
   </script>
	<%}else{ %>
	<script>
      alert("예약이 실패하였습니다.");
      location.href="class.jsp";
   </script>
	<%} %>
</body>
</html>