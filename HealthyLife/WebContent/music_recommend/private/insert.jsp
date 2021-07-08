<%@page import="music.rmd.dao.MRDao"%>
<%@page import="music.rmd.dto.MRDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//로그인된 아이디를 session 영역에서 얻어내기
   String writer=(String)session.getAttribute("id");
   //1. 폼 전송되는 글제목과 내용을 읽어와서
   String title=request.getParameter("title");
   String content=request.getParameter("content");
   String music=request.getParameter("music");
   
   //2. DB 에 저장하고
   MRDto dto=new MRDto();
   dto.setWriter(writer);
   dto.setTitle(title);
   dto.setContent(content);
   dto.setMusic(music);

   boolean isSuccess=MRDao.getInstance().insert(dto);

   //3. 응답하기
%> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/music_recommend/private/insert.jsp</title>
</head>
<body>
   <%if(isSuccess){ %>
   <script>
      alert("새글이 추가 되었습니다.");
      location.href="${pageContext.request.contextPath}/music_recommend/list.jsp";
   </script>
   <%}else{ %>
   <script>
      alert("글 저장 실패!");
      location.href="insertform.jsp";
   </script>
   <%} %>
</body>
</html>