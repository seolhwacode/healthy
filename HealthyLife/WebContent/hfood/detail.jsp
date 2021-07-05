<%@page import="hfood.board.dao.HfoodDao"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="hfood.board.dto.HfoodDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int num=Integer.parseInt(request.getParameter("num"));

	HfoodDto dto=new HfoodDto();
	dto.setNum(num);
	
	dto=HfoodDao.getInstance().getData(num);
   	String id=(String)session.getAttribute("id");
   	//로그인 여부
   	boolean isLogin=false;
   	if(id != null){
      	isLogin=true;
   	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	.container{
		width:75%;
	}
	#content {
		border : 1px black solid;
	}
	
	#private {
		text-align : right;
	}
	
	#private>#user{
		float: left;
		margin-right:10px;
		text-align : right;
	}
	
	ul {
    	list-style:none;

	}
</style>
<jsp:include page="/include/resource.jsp"></jsp:include>
</head>
<body>
<jsp:include page="/include/navbar.jsp"></jsp:include>
	<div class="container"> 
		<ul class="list-group list-group-flush">
			  <li class="list-group-item">글 번호<%=dto.getNum() %></li>
			  <li class="list-group-item">작성자 <%=dto.getWriter() %></li>
			  <li class="list-group-item">제목 <%=dto.getTitle() %></li>
			  <li class="list-group-item">조회수 <%=dto.getViewCount() %></li>
			  <li class="list-group-item">등록일 <%=dto.getRegdate() %></li>
		</ul>
		<div id="content">
		<%=dto.getContent() %>
		</div>
		<ul id="private">
	      <%if(dto.getWriter().equals(id)){ %>
	         <li id="user"><a href="private/updateform.jsp?num=<%=dto.getNum()%>">수정</a></li>
	         <li id="user"><a href="private/delete.jsp?num=<%=dto.getNum()%>">삭제</a></li>
	      <%} %>
	       <li><a href="list.jsp">목록보기</a></li>
	   	</ul>
	   	
	</div>
	

</body>
</html>