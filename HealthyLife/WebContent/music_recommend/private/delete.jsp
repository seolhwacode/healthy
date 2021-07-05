<%@page import="music.rmd.dao.MRDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//1. GET 방식 파라미터로 전달되는 삭제할 글번호를 읽어와서 
   int num=Integer.parseInt(request.getParameter("num"));

   //2. 삭제할 글의 작성자와 로그인 아이디가 같은지 비교를 해서 
   String writer=MRDao.getInstance().getData(num).getWriter(); 
   String id=(String)session.getAttribute("id");
   //만일 글 작성자와 로그인된 아이디가 다르면
   if(!writer.equals(id)){
      //금지된 요청이라고 응답하고 
      response.sendError(HttpServletResponse.SC_FORBIDDEN, "취소 되었습니다.");
      return; // 여기서 메소드 종료 
   }
   //3. 같으면 DB 에서 삭제하고 응답 
   boolean isSuccess=MRDao.getInstance().delete(num);
   //4. 다르면 금지된요청 혹은 잘못된 요청이라고 응답해준다.
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/music_recommend/private/delete.jsp</title>
</head>
<body>
   <%if(isSuccess){%>
      <script>
         alert("삭제 했습니다.");
         location.href="${pageContext.request.contextPath }/music_recommend/list.jsp";
      </script>
   <%}else{%>
      <script>
         alert("삭제 실패!");
         location.href="input_form.jsp?num=<%=num%>";
      </script>
   <%} %>
</body>
</html>