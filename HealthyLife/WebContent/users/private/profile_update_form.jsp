<%@page import="test.users.dao.UsersDao"%>
<%@page import="test.users.dto.UsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//1. session 영역에 저장된 아이디를 가져온다.
	String id = (String)session.getAttribute("id");
	
	//2. id 를 dto 에 담는다.
	UsersDto dto = new UsersDto();
	dto.setId(id);
	
	//3. dao 를 사용하여 개인정보를 불러온다.
	UsersDto resultDto = UsersDao.getInstance().getData(dto);
	
	//4. 출력
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/users/private/profile_update_form.jsp</title>
<jsp:include page="../../include/resource.jsp"></jsp:include>
<style>
   	/* 프로필 이미지를 작은 원형으로 만든다 */
   	#profileImage{
      	width: 150px;
      	height: 150px;
     	border: 1px solid #cecece;
    	border-radius: 50%;
   	}
   	#newProfileImage{
      	width: 150px;
      	height: 150px;
      	border: 1px solid #cecece;
      	border-radius: 50%;
   	}
	.container{
   		width: 500px;
		margin-top: 100px;
   	}
   	#image{
   		display: none;
   	}
   	.arrow > svg{
   		width: 50px;
   		height: 50px;
   	}
   	.arrow{
   		margin: auto 0px;
   	}
   	#imageForm{
   		text-align: center;
		margin-top: 35px;
		margin-right: 15px;
   	}
   	#update_form{
   		text-align: right;
   		margin-top: 20px;
   		width : 430px;
   	}
   	
   	#profile_update{
		border : thick double lightgray;
		padding: 30px;

   	}
   	.row{
   		padding: 0 12px;
   	}
   	
   	h1 {
   		text-align:center;
   	}
   	
   
</style>
</head>
<body>
	<div class="container">
		<div id="profile_update" class="rounded">
		<h1 class="ps-4" >프로필 사진 수정</h1>
		<div class="row text-center mt-5">
			<div class="col-5">
			<%if(resultDto.getProfile() == null){ %>
				<%-- 프로필 사진이 null 일  때 : 기본 사진 --%>
				<svg id="profileImage" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
					<path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
					<path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
				</svg>
			<%} else{%>
				<%-- 프로필 사진 경로가 있다면 -> 해당 사진 출력 --%>
				<img id="profileImage" src="${pageContext.request.contextPath}<%=resultDto.getProfile() %>" alt="프로필 사진" />
			<%} %>
			</div>
			
			<div class="arrow col-2">
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-right" viewBox="0 0 16 16">
				  	<path fill-rule="evenodd" d="M1 8a.5.5 0 0 1 .5-.5h11.793l-3.147-3.146a.5.5 0 0 1 .708-.708l4 4a.5.5 0 0 1 0 .708l-4 4a.5.5 0 0 1-.708-.708L13.293 8.5H1.5A.5.5 0 0 1 1 8z"/>
				</svg>
			</div>
			
			<div class="col-5" id="newProfile">
			<%if(resultDto.getProfile() == null){ %>
				<%-- 프로필 사진이 null 일  때 : 기본 사진 --%>
				<svg id="newProfileImage" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
					<path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
					<path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
				</svg>
			<%} else{%>
				<%-- 프로필 사진 경로가 있다면 -> 해당 사진 출력 --%>
				<img id="newProfileImage" src="${pageContext.request.contextPath}<%=resultDto.getProfile() %>" alt="프로필 사진" />
			<%} %>
			</div>
		</div>
		
		<%-- 프로필 이미지 선택 form --%>
		<form action="${pageContext.request.contextPath}/users/private/ajax_profile_upload.jsp" method="post" id="imageForm" enctype="multipart/form-data">
			<input type="file" id="image" name="image" 
					accept=".jpg, .jpeg, .png, .JPG, .JPEG, .gif" />
			<button class="btn btn-light" id="imageSelect">이미지 선택</button>
			<button class="btn btn-light" type="reset" id="deleteImage">사진 삭제</button>
		</form>
		</div>
		<br />
		
		<form action="${pageContext.request.contextPath}/users/private/profile_update.jsp" method="post" id="update_form">
			<%-- 수정한 프로필 이미지 경로를 form 전송으로 보낸다. --%>
			<%-- empty 면  db 에 반영 X, 원래 db 에 저장된 profile 사진이 있다면 그 파일 경로 그대로 넣기. => 수정한 파일은 파일이 변경될 때마다 value 값이 바뀐다. --%>
			<input type="hidden" name="profile" value="<%=resultDto.getProfile() == null ? "empty" : resultDto.getProfile() %>"/>
			<button class="btn btn btn-outline-primary" type="submit">적용</button>
			<%-- 이전 info.jsp 페이지로 돌아간다. --%>
			<button class="btn btn btn-outline-secondary" id="cancelBtn">취소</button>
		</form>
		
	</div>
	
	
	<%-- gura_util.js 파일 사용해서 하기 --%>
	<script src="<%=request.getContextPath() %>/js/gura_util.js"></script>
	<script>
		//이미지를 선택했을때 실행할 함수 등록 
		document.querySelector("#image").addEventListener("change", function(){
			//file 선택이 없을 시에 예외
			if(this.files.length === 0) return;
			
			let form = document.querySelector("#imageForm");
			
			// gura_util.js 에 정의된 함수를 호출하면서, ajax 전송할 폼의 참조값을 전달하면 된다.
			ajaxFormPromise(form)
			.then(function(response){
				return response.json();
			})
			.then(function(data){
				//data 는 { imagePath:"/upload/xxx.jpg" } 형식의 object
				
				//오른쪽의 변경할 프로필 사진에 img 변경
				let img = `<img class="profileImage" id="newProfileImage" src="${pageContext.request.contextPath}\${data.imagePath}" alt="프로필 사진" />`;
				document.querySelector("#newProfile").innerHTML = img;
				
				// input name="profile" 요소의 value 값으로 이미지 경로 넣어주기
		        document.querySelector("input[name=profile]").value = data.imagePath;
			});
		});
		
		//취소 버튼 -> info.jsp 페이지로 돌아간다.
		document.querySelector("#cancelBtn").addEventListener("click", function(e){
			//form 전송 막음
			e.preventDefault();
			//info.jsp 페이지로 돌아간다.
			location.href = "${pageContext.request.contextPath}/users/private/info.jsp";
		});
		
		//사진 삭제 버튼 : 누르면 -> 기본 사진으로 돌아간다.
		document.querySelector("#deleteImage").addEventListener("click", function(){
			//기본 사진으로 바꾸기
			let svg = 
				`<svg id="newProfileImage" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
					<path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
					<path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
				</svg>`;
			document.querySelector("#newProfile").innerHTML = svg;
			
			//form 에 보낼 value = "empty"
			document.querySelector("input[name=profile]").value = "empty";
		});
		
		//버튼이 클릭되면
		document.querySelector("#imageSelect").addEventListener("click", function(e){
			//submit 은 막는다.
			e.preventDefault();
			
			//input 이 클릭되게 한다.
			document.querySelector("#image").click();
		});
	</script>
</body>
</html>