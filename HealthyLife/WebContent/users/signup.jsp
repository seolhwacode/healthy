<%@page import="test.users.dao.UsersDao"%>
<%@page import="test.users.dto.UsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//form 의 id, pwd 읽어오기
	String id = request.getParameter("id");
	String pwd = request.getParameter("pwd");
	
	//UsersDto 객체에 회원 정보 담기
	UsersDto dto = new UsersDto();
	dto.setId(id);
	dto.setPwd(pwd);
	
	//UsersDao 객체를 이용해 DB 에 insert
	boolean isSuccess = UsersDao.getInstance().insert(dto);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/users/signup.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
<style>
	body {
		background-image: url(../image/running.jpg);
		background-position: center ;
		background-attachment: fixed;
		background-repeat: no-repeat;
	}
	
	.container {
		margin: 200px 100px 0px 200px;
	}
	.btn {
	    display: block;
	    margin-bottom: 30px;
	    border: 3px solid white;
	    font-family: 'Noto Sans KR', sans-serif;
	    box-shadow: 3px 3px 7px grey;
	}
	
	a { text-decoration: none; }
	
	p{
		color: white;
	    font-family: 'Noto Sans KR', sans-serif;
	    text-shadow: 3px 3px 7px grey;
	    font-size: 40px;
	   
	}
	
	#reply { 
		color: white;
	  	font-family: 'Noto Sans KR', sans-serif;
	    text-shadow: 3px 3px 7px grey;
	    font-size: 20px;
	    margin:0px 0px 30px 0px;
	
	}
	
	.login_btn:hover{
		background-color:#9b9b9b;
	}
	.login_btn{
	    width: 230px;
	}
</style>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@500&display=swap" rel="stylesheet">
</head>
<body>
	<%if(isSuccess){ %>
		<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
		<script>
			swal({
	    	  	title: "회원가입 완료!",
	    	  	icon: "success",
	    	  	button: "oh~ yes!",
	    	});
		</script>
		<div class="container">
			<p><strong><%=id %></strong> 님. 가입되셨습니다!</p>
			<br />
			<%-- 그냥 확인을 누르면 login_form.jsp 를 호출했던 page 로 이동한다. --%>
			<a class="btn login_btn link-light" href="${pageContext.request.contextPath}/users/login_form.jsp"> 로그인하러 가기! </a>
			<a class="btn login_btn link-light" href="${pageContext.request.contextPath}/index.jsp"> 메인화면으로 가기 </a>
		</div>
	<%}else{ %>
		<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
		<script>
			swal({
	    	  	title: "회원가입 실패..ㅠㅠ",
	    	  	button: "oh~ No!",
	    	});
		</script>
		<div class="container">
			<p id="reply">회원가입에 실패했습니다.</p>
			<a class="btn login_btn link-light" href="${pageContext.request.contextPath}/users/signup_form.jsp">회원가입으로 돌아가기</a>
		</div>
	<%} %>
</body>
</html>