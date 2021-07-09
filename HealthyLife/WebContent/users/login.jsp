<%@page import="java.net.URLEncoder"%>
<%@page import="test.users.dao.UsersDao"%>
<%@page import="test.users.dto.UsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//로그인 후에 이동해야할 목적지를 form 에서 읽어온다.
	String url = request.getParameter("url");

	if(url == null){
		String cpath = request.getContextPath();
		url = cpath + "/index.jsp";
	}

	//목적지 인코딩 -> 로그인 실패일 경우, 다시 뒤에 get 방식으로 넣어주여야 하기 때문
	String encodedUrl = URLEncoder.encode(url);

	//login_form.jsp 의 form 에서 전송되는 값 읽어오기
	String id = request.getParameter("id");
	String pwd = request.getParameter("pwd");
	
	//UsersDto 를 생성하여 읽어온 id, pw 담기
	UsersDto dto = new UsersDto();
	dto.setId(id);
	dto.setPwd(pwd);
	
	//UsersDao 의 isValid 메소드를 사용하여 db 에 id/pwd 매칭 되는지 확인
	boolean isValid = UsersDao.getInstance().isValid(dto);
	
	//isValid == true : 로그인 성공 -> session 에 "id" 라는 key 이름으로 id 값을 넣는다.
	if(isValid)
		session.setAttribute("id", id);
	//응답
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/users/login.jsp</title>
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


</style>
</head>
<body>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@500&display=swap" rel="stylesheet">
	<%if(isValid){ %>
		<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
			<script>
			swal({
		    	  title: "로그인 완료!",
		    	  icon: "success",
		    	  button: "oh~ yes!",
		    	  
		    	});

			</script>
		<div class="container">
			<p><strong><%=id %></strong>님 반갑습니다! </p>
			<br />
			<%-- 그냥 확인을 누르면 login_form.jsp 를 호출했던 page 로 이동한다. --%>
			<button type="button" class="btn btn-secondary btn-lg"> <a class="link-light" href="<%=url %>"> 원래 있던 페이지로 돌아가기 </a></button>
			
			<button type="button" class="btn btn-secondary btn-lg"><a class="link-light" href="${pageContext.request.contextPath}/index.jsp"> 메인화면으로 가기 </a></button>
		</div>
	<%}else{ %>
		<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
			
			<script>
			swal({
		    	  title: "로그인 실패..ㅠㅠ",
		    	  button: "oh~ No!",
		    	  
		    	});
			</script>
			
		<div class="container">
			<p id="reply">입력한 내용을 다시 확인해주세요.</p>
			<button type="button" class="btn btn-secondary btn-lg"><a class="link-light" href="${pageContext.request.contextPath}/index.jsp">메인으로 돌아가기</a></button>
			<button type="button" class="btn btn-secondary btn-lg"><a class="link-light" href="${pageContext.request.contextPath}/users/login_form.jsp?url=<%=encodedUrl %>">다시 시도</a></button>
		</div>
	<%} %>
</body>
</html>