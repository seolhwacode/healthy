<%@page import="test.users.dao.UsersDao"%>
<%@page import="test.users.dto.UsersDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//1. session 영역에서 로그인된 아이디 얻어내기
	String id = (String)session.getAttribute("id");

	//id 를 통해서 -> 현재 pwd 가져올 것
	UsersDto dto = new UsersDto();
	dto.setId(id);
	
	//현재 pwd 를 가지고 있다.
	UsersDto resultDto = UsersDao.getInstance().getData(dto);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/users/private/pwd_update_form.jsp</title>
<jsp:include page="../../include/resource.jsp"></jsp:include>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
<style>
	h1{
		text-align: center;
	}
	.form-container{
		border: thick double #2252e3;
		padding: 50px;
		width: 450px;
		margin: 100px auto;
	}
</style>
</head>
<body>
<jsp:include page="../../include/navbar.jsp"></jsp:include>
	<div class="container">
		
		<div class="form-container">
			<h1>비밀번호 변경</h1>
			<form class="mt-4" id="pwdForm" action="${pageContext.request.contextPath}/users/private/pwd_update.jsp" method="post">
				<div>
					<label class="form-label" for="pwd">기존 비밀번호</label>
					<input class="form-control" type="password" id="pwd" name="pwd" />
				</div>
				<div>
					<label class="form-label" for="newPwd">새 비밀번호</label>
					<small class="form-text text-muted"> : 5 ~ 15 글자 이내로 입력하세요.</small>
					<input class="form-control" type="password" id="newPwd" name="newPwd" />
					
					<%-- 가용하지 않을 때 feedback--%>
					<div class="invalid-feedback" id="pwd-invalid-feedback">비밀번호 형식에 맞지 않습니다.</div>
					<%-- 가용할 때 띄우는 feedback --%>
					<div class="valid-feedback" id="pwd-valid-feedback">사용할 수 있는 비밀번호 입니다.</div>
				</div>
				<div>
					<label class="form-label" for="newPwd2">새 비밀번호</label>
					<input class="form-control" type="password" id="newPwd2" name="newPwd2" />
					
					<%-- 가용하지 않을 때 feedback--%>
					<div class="invalid-feedback" id="pwd2-invalid-feedback">일치하지 않습니다.</div>
					<%-- 가용할 때 띄우는 feedback --%>
					<div class="valid-feedback" id="pwd2-valid-feedback">ok</div>
				</div>
				<div class="mt-3 text-center">
					<button class="btn btn-light" type="submit">변경</button>
					<button class="btn btn-outline-danger" type="reset">리셋</button>
				</div>
			</form>
		</div>
	</div>
	
	<script>
		//새로 입력하는 비밀번호의 가용성 & 비빌번호 재확인의 가용성 체크
		let isPwdInputValid = false;
		let isPwd2InputValid = false;
	
		//비밀번호 & 비밀번호 확인이 일치하는지 check 함수 -> newPwd2 의 input 이벤트 콜백함수로도 사용할 것
		function checkPwd(){
			//input#newPwd 입력값 가져오기
			const newPwd = document.querySelector("#newPwd").value;
			//input#newPwd2 요소 객체 가져오기
			const pwdInputCheck = document.querySelector("#newPwd2");
			//input#pwd2 의 입력값 읽어오기
			const newPwd2 = pwdInputCheck.value;
			
			//is-invalid 와 is-valid class 를 제거한다.
			pwdInputCheck.classList.remove("is-invalid");
			pwdInputCheck.classList.remove("is-valid");
			
			//비밀번호 확인(newPwd2) 입력 없으면 -> 확인할 필요 X
			if(newPwd2 === ""){
				//비밀번호가 매칭되지 않는다
				isPwd2InputValid = false;
				return;	//함수 끝
			}
			
			//pwd2 가 가용하지 않는 경우
			//1. 비밀번호 입력(newPwd)와 확인란(newPwd2) 값이 일치하는지 확인한다.
			//2. isPwd2InputValid : false 일 때 -> pwd 에 입력한 값이 가용하지 않음
			if(newPwd != newPwd2 || !isPwdInputValid){
				//newPwd2 는 가용하지 않음
				isPwd2InputValid = false;
				pwdInputCheck.classList.add("is-invalid");
			}else{
				//비밀번호(pwd)가 가용하고, 비밀번호(newPwd)와 비밀번호 확인란(newPwd2)의 value 가 같다. -> ok
				isPwd2InputValid = true;
				pwdInputCheck.classList.add("is-valid");
			}
		}
		
		//비밀번호 입력에서 형식에 맞게 입력했는지 확인
		document.querySelector("#newPwd").addEventListener("input", function(){
			//입력한 비밀번호 읽어오기
			const inputPwd = this.value;
			
			//is-invalid 와 is-valid class 를 제거한다.
			this.classList.remove("is-invalid");
			this.classList.remove("is-valid");
			
			//input 값이 공백이라면? -> 체크할 필요 없음(return)
			if(inputPwd === ""){
				isPwdInputValid = false;
				return;
			}
			
			//비밀번호 검증할 정규식 : 5 ~ 15 글자 이내로 입력
			//정규식 내부에 공백이 들어가면 안된다!!
			const reg_pwd = /^.{5,15}$/;
			
			//현재 사용 중인 비밀번호와 같으면 -> 사용 불가능한 비밀번호임
			let isSame = inputPwd === "<%=resultDto.getPwd() %>";
			
			//만일 입력한 비밀번호(pwd)가 정규표현식과 매칭되지 않는다면 -> 올바른 형식이 아님
			//만일, 입력한 비밀번호가 기존에 사용하던 비밀번호일 경우? -> 사용할 수 없음
			if(!reg_pwd.test(inputPwd) || isSame){
				//정규 표현식에 매칭되지 않음 or 현재 사용중인 비밀번호와 같음 -> 가용하지 않은 비밀번호
				isPwdInputValid = false;
				//pwd input 에 가용하지 않음 표시 -> "is-invalid" class 추가
				this.classList.add("is-invalid");
			}else{
				//사용 가능한 비밃번호
				isPwdInputValid = true;
				this.classList.add("is-valid");
			}

			//비밀번호 확인
			//가용하지 않음 비밀번호 -> 비밀번호 확인란(pwd2) 에 어떤 값이 있어도 가용하지 않음
			//가용한 비밀번호 -> 비밀번호 확인란(pwd2)의 값이 pwd 의 값과 같은지 확인
			checkPwd();
		});
		
		
		//비밀번호 확인란에 input 이벤트가 일어 났을때 실행할 함수 등록
		document.querySelector("#newPwd2").addEventListener("input", checkPwd);
	
		//form 의 submit 이벤트가 일어났을 때의 콜백함수 등록
		document.querySelector("#pwdForm").addEventListener("submit", function(e){
			//비밀번호 & 비밀번호 확인 둘 다 가용하면 form 전송 가능
			let isFormValid = isPwdInputValid && isPwd2InputValid;
			
			//폼이 유효하지 않음 -> 폼 전송 막기
			if(!isFormValid){
				//폼 전송 막기
				e.preventDefault();
				//다시 입력해달라는 alert 띄우기
				//alert("다시 입력해주세요.");
				swal({
		    	  	title: "다시 입력해주세요.",
		    	  	icon: "warning"
		    	});
			}
		});
		
		//form 에서 "reset" 이벤트가 일어났을 때 콜백함수 등록 -> "is-invalid", "is-valid" 다 삭제
		document.querySelector("#pwdForm").addEventListener("reset", function(){
			//새로운 비밀번호 입력 & 새로운 비밀번호 확인 문서객체 가져오기
			let newPwd = document.querySelector("#newPwd");
			let newPwd2 = document.querySelector("#newPwd2");
			
			//새로운 비밀번호 입력 & 새로운 비밀번호 확인에 "is-invalid", "is-valid" class 다 삭제			
			newPwd.classList.remove("is-valid");
			newPwd.classList.remove("is-invalid");
			newPwd2.classList.remove("is-valid");
			newPwd2.classList.remove("is-invalid");
		});
	</script>
	
</body>
</html>