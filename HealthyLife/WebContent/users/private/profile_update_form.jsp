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
      width: 100px;
      height: 100px;
      border: 1px solid #cecece;
      border-radius: 50%;
   }
   #newProfileImage{
      width: 100px;
      height: 100px;
      border: 1px solid #cecece;
      border-radius: 50%;
   }
   #imageForm{
   	  
   }
</style>
</head>
<body>
	<div class="container">
		<h1>프로필 사진 수정</h1>
		<div>
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
		=>
		<div id="newProfile">
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
		<%-- 프로필 이미지 선택 form --%>
		<form action="${pageContext.request.contextPath}/users/private/ajax_profile_upload.jsp" method="post" id="imageForm" enctype="multipart/form-data">
			<input type="file" id="image" name="image" 
					accept=".jpg, .jpeg, .png, .JPG, .JPEG, .gif" />
			<button type="reset" id="deleteImage">사진 삭제</button>
		</form>
		<br />
		
		<form action="${pageContext.request.contextPath}/users/private/profile_update.jsp" method="post">
			<%-- 수정한 프로필 이미지 경로를 form 전송으로 보낸다. --%>
			<%-- empty 면  db 에 반영 X, 원래 db 에 저장된 profile 사진이 있다면 그 파일 경로 그대로 넣기. => 수정한 파일은 파일이 변경될 때마다 value 값이 바뀐다. --%>
			<input type="hidden" name="profile" value="<%=resultDto.getProfile() == null ? "empty" : resultDto.getProfile() %>"/>
			<button type="submit">적용</button>
			<%-- 이전 info.jsp 페이지로 돌아간다. --%>
			<button id="cancelBtn">취소</button>
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
	</script>
</body>
</html>