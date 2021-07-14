<%@page import="test.users.dto.UsersDto"%>
<%@page import="test.users.dao.UsersDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//1. session 영역에서 로그인된 아이디 얻어내기
	String id = (String)session.getAttribute("id");

	//2. 폼 전송되는 이전 비밀번호, 새 비밀번호 읽어오기
	String pwd = request.getParameter("pwd");
	String newPwd = request.getParameter("newPwd");
	
	//3. 이전 비밀번호가 유효한 정보인지 확인하기
	UsersDto dto = new UsersDto();
	dto.setId(id);
	
	UsersDto resultDto = UsersDao.getInstance().getData(dto);
	//이전 비밀번호와 일치해야한다.
	boolean isValid = pwd.equals(resultDto.getPwd());
	
	//4. 이전 비밀번호가 맞다면, 비밀번호를 새 비밀번호로 수정한다.
	if(isValid){
		//dto 에 비밀번호를 담아서
		dto.setPwd(newPwd);
		//dao 에 넘겨주고, 수정 & DB 에 반영
		UsersDao.getInstance().updatePwd(dto);
		//비밀번호 수정 후 -> 로그아웃 처리 & 새로 로그인하게 한다.
		session.removeAttribute("id");
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/users/private/pwd_update.jsp</title>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
</head>
<body>
	<%if(isValid){ %>
		<%-- <p>
			<strong><%=id %></strong> 님, 성공적으로 비밀번호를 변경하였습니다.
			<a href="${pageContext.request.contextPath}/users/login_form.jsp">로그인 하러 가기</a>
		</p> --%>
		<script>
			swal({
	    	  	title: "성공적으로 비밀번호를 변경하였습니다.",
	    	  	text: "로그인 페이지로 이동하시겠습니까?",
	    	  	icon: "success",
	    	  	buttons: true
	    	})
	    	.then(function(goLogin){
	    		if(goLogin){
	    			//ok -> 로그인 페이지로
		    		location.href = "${pageContext.request.contextPath}/users/login_form.jsp";
	    		}else{
	    			//취소 -> index 페이지로 이동
	    			location.href = "${pageContext.request.contextPath}/index.jsp";
	    		}
	    	});
		</script>
	<%}else{ %>
		<%-- <p>
			가용하지 않은 비밀번호 입니다.
			<a href="${pageContext.request.contextPath}/users/private/pwd_update_form.jsp">다시 시도</a>
		</p> --%>
		<script>
			swal({
	    	  	title: "가용하지 않은 비밀번호 입니다.",
	    	  	icon: "warning"
	    	})
	    	.then(function(){
	    		location.href = "${pageContext.request.contextPath}/users/private/pwd_update_form.jsp";
	    	});
		</script>
	<%} %>
</body>
</html>