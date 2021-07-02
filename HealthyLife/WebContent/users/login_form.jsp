<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/users/login_form.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
</head>
<body>
	<div class="container">
		<h1>로그인</h1>
		<form action="${pageContext.request.contextPath}/users/login.jsp" method="post">
			<div>
				<label class="form-label" for="id">아이디</label>
				<input class="form-control" type="text" id="id" name="id" placeholder="아이디를 입력하세요..."/>
			</div>
			<div>
				<label class="form-label" for="pwd">비밀번호</label>
				<input class="form-control" type="password" id="pwd" name="pwd" placeholder="비밀번호를 입력하세요..."/>
			</div>
			<button class="btn btn-primary mt-3" type="submit">로그인</button>
		</form>
	</div>
</body>
</html>