<%@page import="music.rmd.dao.MRDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="dto" class="music.rmd.dto.MRDto"></jsp:useBean>
<jsp:setProperty property="*" name="dto"/>
<%
	boolean isSuccess=MRDao.getInstance().update(dto);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/music_recommend/private/update.jsp</title> 
</head>
<body>
	<%if(isSuccess){ %>
      <script>
         alert("수정했습니다.");
         location.href="../detail.jsp?num=<%=dto.getNum()%>";
      </script>
   <%}else{ %>
      <h1>알림</h1>
      <p>
        	 글 수정 실패!
         <a href="updateform.jsp?num=<%=dto.getNum()%>">다시 시도</a>
      </p>
   <%} %>
</body>
</html>