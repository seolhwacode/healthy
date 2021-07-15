<%@page import="test.users.dao.UsersDao"%>
<%@page import="test.users.dto.UsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//1. session 영역에서 id 가져오기
	String id = (String)session.getAttribute("id");

	//2. form 에서 파라미터 가져오기
	String profile = request.getParameter("profile");
	//만일 프로필 이미지를 한 번도 바꾸지 않았따면, "empty" 가 넘어온다.
	if(profile.equals("empty")){
		profile = null;	//rpfile 컬럼을 비워놓기 위해 null 을 대입한다.
	}

	//3. UsersDto 에 update 할 내용 담기
	UsersDto dto = new UsersDto();
	dto.setId(id);
	dto.setProfile(profile);
	
	//4. UsersDao 를 사용하여 profile 경로 update
	boolean isSuccess = UsersDao.getInstance().update(dto);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/users/private/profile_update.jsp</title>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
</head>
<body>
	<%if(isSuccess){ %>
		<script>
			//alert("<%=id %> 님의 정보가 수정되었습니다.");
			swal({
	    	  	title: "정보가 수정되었습니다.",
	    	  	icon: "success"
	    	})
	    	.then(function(){
	    		location.href = "${pageContext.request.contextPath}/users/private/info.jsp";
	    	});
		</script>
	<%}else{ %>
		<script>
			//alert("수정에 실패했습니다.");
			swal({
	    	  	title: "수정에 실패했습니다.",
	    	  	icon: "error"
	    	})
	    	.then(function(){
	    		location.href = "${pageContext.request.contextPath}/users/private/profile_update_form.jsp";
	    	});
		</script>
	<%} %>
</body>
</html>