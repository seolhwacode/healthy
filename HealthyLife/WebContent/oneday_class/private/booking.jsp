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
		<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
			<script>
			swal({
		    	  title: "예약 성공",
		    	  icon: "success",
		    	  button: "예약 확인",
		    	}).then(function(){
		    		location.href="bookingList.jsp"
		    	});
			</script>
	<%}else if(!isSuccess){%>
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
		<script>
		swal({
    	 	 title: "예약 실패",
    	 	 icon: "warning",
    	 	 button: "다시 예약",
    		}).then(function(){
    			location.href="../class.jsp"
    		});
	</script>
	<%} %>
</body>
</html>