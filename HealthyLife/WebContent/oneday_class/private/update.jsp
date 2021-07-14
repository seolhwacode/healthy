<%@page import="oneday.booking.dto.BookingDto"%>
<%@page import="oneday.booking.dao.BookingDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

int num = Integer.parseInt(request.getParameter("num"));
String name = request.getParameter("name");
String phone = request.getParameter("phone");
String className = "Ashtanga";
String classDate = request.getParameter("date");
String mention = request.getParameter("mention");

BookingDto dto = new BookingDto();
dto.setNum(num);
dto.setName(name);
dto.setPhone(phone);
dto.setClassName(className);
dto.setClassDate(classDate);
dto.setMention(mention);

boolean isSuccess = BookingDao.getInstance().update(dto);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>update.jsp</title>
</head>
<body>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
  <%if(isSuccess){%>
      <script>
      swal({
		  	title: "수정 완료!",
		  	text: "예약 정보가 수정되었습니다.",
		  	icon: "success",
		  	buttons: true,
		})
		.then(function(willUpdate){
		  	if (willUpdate) {
		    	location.href = "${pageContext.request.contextPath}/oneday_class/private/detail.jsp?num=<%=num%>";
		  	}
		});
      </script>
   <%}else{%>
      <script>
      swal({
		  	title: "수정 실패!",
		  	text: "예약 정보 수정에 실패했습니다.",
		  	icon: "warning",
		  	buttons: true,
		})
		.then(function(willUpdate){
		  	if (willUpdate) {
		    	location.href = "${pageContext.request.contextPath}/oneday_class/private/detail.jsp?num=<%=num%>";
		  	}
		});
      </script>
   <%} %>
</body>
</html>