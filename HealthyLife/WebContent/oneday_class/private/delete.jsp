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
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
  <%if(isSuccess){%>
      <script>
      swal({
		  	title: "삭제 완료!",
		  	text: "예약이 취소 되었습니다.",
		  	icon: "success",
		  	buttons: true,
		})
		.then(function(willDelete){
		  	if (willDelete) {
		    	location.href = "${pageContext.request.contextPath}/oneday_class/private/bookingList.jsp";
		  	}
		});
      </script>
   <%}else{%>
      <script>
      swal({
		  	title: "삭제 실패!",
		  	text: "글 삭제를 실패했습니다.",
		  	icon: "warning",
		  	buttons: true,
		})
		.then(function(willDelete){
		  	if (willDelete) {
		    	location.href = "${pageContext.request.contextPath}/oneday_class/private/detail.jsp?num=<%=num%>";
		  	}
		});
      </script>
   <%} %>
</body>
</html>