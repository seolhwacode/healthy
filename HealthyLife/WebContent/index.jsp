<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//로그인 상태 확인 : session 에 "id" 값 가져오기
	// id == null : 로그인 되지 않은 상태
	// id != null : 로그인 된 상태
	String id = (String)session.getAttribute("id");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/index.jsp</title>
<jsp:include page="/include/resource.jsp"></jsp:include>
<jsp:include page="/include/navbar.jsp"></jsp:include>
<style>
	.carousel {
		width : 800px;
		margin: auto;
	}
	
	h1 {
	    text-align: center;
	    margin: 30px;
	    font-style: italic;
	    font-weight: 600;
	    font-size: 35px;
	}
</style>
</head>
<body>
	<div class="container">
		
		<%if(id != null){ %>
			<p>
				<a href="${pageContext.request.contextPath}/users/private/info.jsp"><%=id %></a> 님 로그인 중...
				<a href="${pageContext.request.contextPath}/users/logout.jsp">로그아웃</a>
			</p>
		<%} %>
		
		<h1>I support your health!</h1>
		<div id="carouselExampleIndicators" class="carousel slide w-75" data-bs-ride="carousel">
		  <div class="carousel-indicators">
		    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
		    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="1" aria-label="Slide 2"></button>  
		    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="2" aria-label="Slide 3"></button>  
		    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="3" aria-label="Slide 4"></button>  
		    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="4" aria-label="Slide 5"></button>  
		  </div>
		  <div class="carousel-inner">
		  	<div class="carousel-item">
		      <img src="image/homeW.jpg" class="d-block w-100" alt="...">
		    </div>
		    <div class="carousel-item">
		      <img src="image/video.jpg" class="d-block w-100" alt="...">
		    </div>
		    <div class="carousel-item active">
		      <img src="image/oneday.jpg" class="d-block w-100" alt="...">
		    </div>
		    <div class="carousel-item">
		      <img src="image/tomato.jpg" class="d-block w-100" alt="...">
		    </div>
		    <div class="carousel-item">
		      <img src="image/music.jpg" class="d-block w-100" alt="...">
		    </div>
		  </div>
		  <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
		    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
		    <span class="visually-hidden">Previous</span>
		  </button>
		  <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
		    <span class="carousel-control-next-icon" aria-hidden="true"></span>
		    <span class="visually-hidden">Next</span>
		  </button>
		</div>
	</div>
</body>
</html>