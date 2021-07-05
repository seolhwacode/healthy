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
<%if(isSuccess){ %>
      <script>
         alert("수정 완료!");
         location.href="detail.jsp?num=<%=dto.getNum()%>";
      </script>
   <%}else{ %>
  	 <script>
         alert("수정 실패!");
         location.href="detail.jsp?num=<%=dto.getNum()%>";
      </script>
   <%} %>
</body>
</html>