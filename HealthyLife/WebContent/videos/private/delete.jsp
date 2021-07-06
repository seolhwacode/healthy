<%@page import="kang.videos.dto.VideosDto"%>
<%@page import="kang.videos.dao.VideosDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//1. GET 방식 파라미터로 전달되는 삭제할 글 번호를 읽어오기
	int num = Integer.parseInt(request.getParameter("num"));
	
	VideosDto insertDto = new VideosDto();
	insertDto.setNum(num);

	//2. 삭제할 글의 작성자와 로그인 아이디가 같은지 비교
	String writer = VideosDao.getInstance().getData(insertDto).getWriter();
	String id = (String)session.getAttribute("id");
	
	//3. 만약 글 작성자와 로그인된 아이디가 다르다면
	if(!writer.equals(id)){
		//금지된 요청이라고 응답
		response.sendError(HttpServletResponse.SC_FORBIDDEN, "남의 글 지우면 안됨!");
		return;	//여기서 메소드 종료 -> 여기는 실제로  servlet 의 service 내부이다. -> service 가 종료되면 페이지 끝!
	}
	
	//4. 같으면 DB 에서 삭제
	boolean isSuccess = VideosDao.getInstance().delete(num);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/videos/private/delete.jsp</title>
</head>
<body>
<%if(isSuccess){ %>
	<script>
		alert("삭제되었습니다.");
		location.href="${pageContext.request.contextPath}/videos/list.jsp";
	</script>
<%}else{ %>
	<script>
		alert("삭제 실패!");
		location.href="${pageContext.request.contextPath}/videos/detail.jsp?num<%=num %>";
	</script>
<%} %>
</body>
</html>