<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//로그인 후, 이전에 요청한 페이지가 있다면 요청페이지로 넘어가는 기능 추가
	//1. GET 파라미터 url 이라는 이름으로 전달되는 값이 있는지 읽어본다.
	String url = request.getParameter("url");

	//2. url 이 없으면? -> index 페이지로 갈 수 있도록 설정
	if(url == null){
		//로그인 후에 index.jsp 페이지로 갈 수 있도록 절대 경로를 구성한다.
		String cPath = request.getContextPath();
		url = cPath + "/index.jsp";
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/users/login_form.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
<style>
	h1{
		text-align: center;
	}
	.form-container{
	    width: 400px;
	    margin-top: 160px;
	    margin-left: auto;
	    margin-right: auto;
	}
	#login_submit_btn{
		width: 50%;
    	margin: 40px 100px;
	}
	
	#logo {
		margin: auto 161px;
	}
</style>
</head>
<body>
	<jsp:include page="../include/navbar.jsp"></jsp:include>
	<div class="container">
		
		<div class="form-container">
			<img id="logo" src="../image/health.png" alt="" width="80px"/>
			<form class="mt-4" action="${pageContext.request.contextPath}/users/login.jsp" method="post">
			<%-- 로그인 후에 이동할 목적지 정보 hidden 으로 보내기 --%>
			<input type="hidden" name="url" value="<%=url %>" />
			<div>
				<label class="form-label" for="id"></label>
				<input class="form-control" type="text" id="id" name="id" placeholder="아이디"/>
			</div>
			<div>
				<label class="form-label" for="pwd"></label>
				<input class="form-control" type="password" id="pwd" name="pwd" placeholder="비밀번호"/>
			</div>
			<button type="submit" class="btn btn-outline-secondary" id="login_submit_btn">로그인</button>
		</form>
		</div>
	</div>
</body>
</html>