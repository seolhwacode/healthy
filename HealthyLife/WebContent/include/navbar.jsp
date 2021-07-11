<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//세션 영역에 id라는 키값으로 저장된 문자열 읽어와보기 (null이 아니면 로그인 된 것이다 )
	String id=(String)request.getSession().getAttribute("id");
	
	//thisPage 라는 파라미터명으로 전달되는 문자열을 얻어와 본다. 
	// null / homeW(홈트) / videos(영상자료) / oneday_class(원데이클래스) / hfood(건강레시피) / music_recommend(추천음악)
	String thisPage=request.getParameter("thisPage");
	// thisPage 가 null 이면 index.jsp 페이지에 포함된 것이다. 
	//만일 null 이면 
	if(thisPage==null){
	   //빈 문자열을 대입한다. (NullPointerException 방지용)
	   thisPage="";
	}
%>
<style>
 /* 링크 밑줄 제거*/
a { text-decoration:none !important } 

/* 로그인 상태입니다 - 흰색 */
#login {
	color:white;
}

#navbar_name {
	font-family: 'Encode Sans SC', sans-serif;
}

.navbar-nav {
	
	
}

/* 네비게이션 바가 body 의 요소를 먹어버리는 현상을 고치기 위해 추가 */
body{
	margin-top: 70px;
}
/*로그아웃 버튼의 css 수정*/
#logout_button{
	/*글씨색 통일*/
	color: #0d6efd;
	margin-left: 10px;
}

</style>


<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Encode+Sans+SC&family=Jua&display=swap" rel="stylesheet">
<nav class="navbar navbar-expand-lg navbar-dark fixed-top" style="background-color: #2252e3;">
  <div class="container-fluid">
    <a id="navbar_name" class="navbar-brand" href="${pageContext.request.contextPath}/index.jsp">
    	<svg  xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-emoji-wink" viewBox="0 0 16 16">
	  		<path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
	  		<path d="M4.285 9.567a.5.5 0 0 1 .683.183A3.498 3.498 0 0 0 8 11.5a3.498 3.498 0 0 0 3.032-1.75.5.5 0 1 1 .866.5A4.498 4.498 0 0 1 8 12.5a4.498 4.498 0 0 1-3.898-2.25.5.5 0 0 1 .183-.683zM7 6.5C7 7.328 6.552 8 6 8s-1-.672-1-1.5S5.448 5 6 5s1 .672 1 1.5zm1.757-.437a.5.5 0 0 1 .68.194.934.934 0 0 0 .813.493c.339 0 .645-.19.813-.493a.5.5 0 1 1 .874.486A1.934 1.934 0 0 1 10.25 7.75c-.73 0-1.356-.412-1.687-1.007a.5.5 0 0 1 .194-.68z"/>
		</svg> Healthy life
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavAltMarkup" aria-controls="navbarNavAltMarkup" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNavAltMarkup">
      	<div class="navbar-nav me-auto">
      		<%-- homeW(홈트) / videos(영상자료) / oneday_class(원데이클래스) / hfood(건강레시피) / music_recommend(추천음악) 중 선택 --%>
	        <a class="nav-link <%=thisPage.equals("")?"active":"" %>" aria-current="page" href="#">소개</a>
	        <a class="nav-link <%=thisPage.equals("homeW")?"active":"" %>" href="${pageContext.request.contextPath}/homeW/list.jsp">홈트</a>
	        <a class="nav-link <%=thisPage.equals("videos")?"active":"" %>" href="${pageContext.request.contextPath}/videos/list.jsp">영상자료</a>
	        <a class="nav-link <%=thisPage.equals("oneday_class")?"active":"" %>" href="${pageContext.request.contextPath}/oneday_class/class.jsp">원데이클래스</a>
	        <a class="nav-link <%=thisPage.equals("hfood")?"active":"" %>" href="${pageContext.request.contextPath}/hfood/list.jsp">건강레시피</a>
	        <a class="nav-link <%=thisPage.equals("music_recommend")?"active":"" %>" href="${pageContext.request.contextPath}/music_recommend/list.jsp">추천음악</a>
      	</div>
      	<div  id="user">
		<%if(id != null){ %>
			<div id="login">
				<a href="${pageContext.request.contextPath}/users/private/info.jsp" class="link-light"><%=id %></a>님 로그인 상태입니다.
				<a id="logout_button" class="btn btn-primary me-md-2" style="background:white;" href="${pageContext.request.contextPath}/users/logout.jsp">logout</a>
			</div>
		<%} else {%>
			<div id="navbar-right-menu">
				<div class="d-grid gap-2 d-md-flex justify-content-md-end" id="user2">
			  		<button class="btn btn-primary me-md-2" style="background:white;" type="button" ><a href="${pageContext.request.contextPath}/users/signup_form.jsp">sign up</a></button>
			  		<button class="btn btn-primary me-md-2" style="background:white;" type="button"><a href="${pageContext.request.contextPath}/users/login_form.jsp">login</a></button>
				</div>
		   	</div>	
		<%} %>
    </div>
	</div>
  </div>
</nav>