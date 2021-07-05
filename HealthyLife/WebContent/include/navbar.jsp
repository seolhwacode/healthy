<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	//세션 영역에 id라는 키값으로 저장된 문자열 읽어와보기 (null이 아니면 로그인 된 것이다 )
	String id=(String)request.getSession().getAttribute("id");

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/include/resource.jsp"></jsp:include>
<style>
.navbar-text {
    padding-top: .5rem;
    padding-bottom: .5rem;
    padding-left:130px;
    }
    
#user {
	text-align : -webkit-right;
	color: white;

}

a>#user2{
	color:white;
}

.navbar-brand {
   
   font-size: 30px !important;
    }
    
#navbar-right-menu {
	 font-size: 20px !important;
	 width:170px;
 }
 
 .nav-link {
    font-size: 20px !important;
    }
    
a { text-decoration:none !important }

.navbar-expand-lg .navbar-nav .nav-link {
    padding-right: .7rem;
    padding-left: 0.7rem;
}
</style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark" style="background-color: #2252e3;">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">
    <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-emoji-wink" viewBox="0 0 16 16">
	  <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
	  <path d="M4.285 9.567a.5.5 0 0 1 .683.183A3.498 3.498 0 0 0 8 11.5a3.498 3.498 0 0 0 3.032-1.75.5.5 0 1 1 .866.5A4.498 4.498 0 0 1 8 12.5a4.498 4.498 0 0 1-3.898-2.25.5.5 0 0 1 .183-.683zM7 6.5C7 7.328 6.552 8 6 8s-1-.672-1-1.5S5.448 5 6 5s1 .672 1 1.5zm1.757-.437a.5.5 0 0 1 .68.194.934.934 0 0 0 .813.493c.339 0 .645-.19.813-.493a.5.5 0 1 1 .874.486A1.934 1.934 0 0 1 10.25 7.75c-.73 0-1.356-.412-1.687-1.007a.5.5 0 0 1 .194-.68z"/>
	</svg> Healthy life</a>
	
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNavDropdown">
      <ul class="navbar-nav">
        <li class="nav-item">
        <a class="nav-link" href="#"> introduction </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/homeW/list.jsp">home_workout </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#">videos</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#">oneday_class</a>
        </li>
       	<li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/hfood/list.jsp">healthy_food</a>
        </li>
       	<li class="nav-item">
          <a class="nav-link" href="#">music_recommend</a>
        </li>     
       
      </ul>
       <div class="container-fluid" >
		    <span class="navbar-text" id="comment">
		      I support your health
		    </span>
	   </div>
	   <div class="container" id="user">
	<%if(id != null){ %>
		<a>
			<a href="../users/private/info.jsp" class="link-light"><%=id %></a>님 로그인 상태입니다.
			
		</a>
	<%} else {%>
		<div id="navbar-right-menu">
			<div class="d-grid gap-2 d-md-flex justify-content-md-end" id="user2">
		  		<button class="btn btn-primary me-md-2" style="background:white;" type="button" ><a href="${pageContext.request.contextPath}/users/signup_form.jsp">signup</a></button>
		  		<button class="btn btn-primary me-md-3" style="background:white;" type="button"><<a href="${pageContext.request.contextPath}/users/login_form.jsp"></button>
			</div>
	   	</div>	
	<%} %>
	</div>
    </div>
  </div>
</nav>

</body>
</html>