<%@page import="test.users.dao.UsersDao"%>
<%@page import="test.users.dto.UsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//session 에서 현재 로그인된 id 가져오기
	String id = (String)session.getAttribute("id");
	
	//로그인된 id 를 UsersDto 에 담기
	UsersDto dto = new UsersDto();
	dto.setId(id);
	
	//UsersDao 객체를 이용해서 가입된 정보를 가져오기
	UsersDto resultDto = UsersDao.getInstance().getData(dto);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/users/private/info.jsp</title>
<jsp:include page="../../include/resource.jsp"></jsp:include>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Encode+Sans+SC&family=Jua&display=swap" rel="stylesheet">


<style>
	/* 프로필 이미지를 작은 원형으로 만든다 */
   #profileImage{
      width: 150px;
      height: 150px;
      border: 1px solid #cecece;
      border-radius: 50%;
   }
   .container{
   		width: 500px;
   		margin-top: 150px;
   }
   .data{
   		margin:0px;
   		padding: 50px 0px 0px 40px;
   }
   
   .ps-4 {
	   	font-family: 'Jua', sans-serif;
    	font-size: 45px;
   }
   
   	#profile_update{
		border: thick double #2252e3;
    	padding: 30px;
		text-align: center;
   	}
</style>
</head>
<body>
<jsp:include page="../../include/navbar.jsp"></jsp:include>
	<div id="profile_update" class="container">
		<h1 class="ps-4">가입 정보</h1>

		<!-- 가입 정보 출력 -->
		<div class="row mt-6">
			<div class="col-4 text-center">
			<%-- null 이면 기본 이미지 보여주기 --%>
			<%if(resultDto.getProfile() == null){ %>
				<%-- 프로필 사진이 null 일  때 : 기본 사진 --%>
				<svg id="profileImage" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
							<path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
							<path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
				</svg>
			<%}else{%>
				<%-- 저장된 이미지 출력 --%>
				<img id="profileImage" src="<%=request.getContextPath() %><%=resultDto.getProfile() %>" alt="프로필 사진" />
			<%} %>
			</div>
			<div class="data col-8">
				<table>
					<tr>
						<th>아이디</th>
						<td><%=resultDto.getId() %></td>
					</tr>
					<tr>
						<th>가입일</th>
						<td><%=resultDto.getRegdate() %></td>
					</tr>
				</table>
			</div>
		</div>

		<div class="mt-5">
			<a class="btn btn-light" href="${pageContext.request.contextPath}/users/private/profile_update_form.jsp">프로필 변경</a>
			<a class="btn btn-light" href="${pageContext.request.contextPath}/users/private/pwd_update_form.jsp">비밀번호 변경</a>
			<a class="btn btn-outline-danger" href="javascript:deleteConfirm()">탈퇴</a>
		</div>
	</div>
	
	<script>
	function deleteConfirm(){
		//let isDelete = confirm("<%=id %> 님 정말로 탈퇴하시겠습니까?");
		swal({
		  	title: "정말로 탈퇴하시겠습니까?",
		  	text: "복구할 수 없습니다.",
		  	icon: "warning",
		  	buttons: true,
		  	dangerMode: true
		})
		.then(function(isDelete){
			if(isDelete){
				//탈퇴
				location.href = "${pageContext.request.contextPath}/users/private/delete.jsp";
			}
		});
		//no 면 탈퇴 안함 : 아무 일도 없다.
	}
	</script>

</body>
</html>