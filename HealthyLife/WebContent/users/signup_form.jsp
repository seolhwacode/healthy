<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/users/signup_form.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
</head>
<body>
	<div class="container">
		<h1>회원가입</h1>
		<form action="${pageContext.request.contextPath}/users/signup.jsp" method="post" id="loginForm">
			<div>
				<%-- 아이디 입력 --%>
				<label class="form-label" for="id">아이디</label>
				<small class="form-text text-muted"> : 영문자 소문자로 시작하고, 5 ~ 10글자 이내로 입력하세요.</small>
				<input class="form-control" type="text" id="id" name="id" />
				
				<%-- 가용하지 않을 때의 feedback --%>
				<div class="invalid-feedback" id="id-invalid-feedback"></div>
				<%-- 가용할 때의 feedback --%>
				<div class="valid-feedback" id="id-valid-feedback">사용할 수 있는 아이디입니다.</div>
			</div>
			<div>
				<%-- 비밀번호 입력 --%>
				<label class="form-label" for="pwd">비밀번호</label>
				<small class="form-text text-muted"> : 5 ~ 15 글자 이내로 입력하세요.</small>
				<input class="form-control" type="password" id="pwd" name="pwd" />
				
				<%-- 가용하지 않을 때 feedback--%>
				<div class="invalid-feedback" id="pwd-invalid-feedback">비밀번호 형식에 맞지 않습니다.</div>
				<%-- 가용할 때 띄우는 feedback --%>
				<div class="valid-feedback" id="pwd-valid-feedback">사용할 수 있는 비밀번호 입니다.</div>
			</div>
			<div>
				<%-- 비밀번호 확인 : 위의 비밀번호와 동일하게 입력하였는지 확인하기 --%>
				<label class="form-label" for="pwd2">비민번호 확인</label>
				<input class="form-control" type="password" id="pwd2" name="pwd2" />
				
				<%-- 가용하지 않을 때 feedback--%>
				<div class="invalid-feedback" id="pwd2-invalid-feedback">일치하지 않습니다.</div>
				<%-- 가용할 때 띄우는 feedback --%>
				<div class="valid-feedback" id="pwd2-valid-feedback">ok</div>
			</div>
			<button class="btn btn-primary" type="submit">회원가입</button>
		</form>
	</div>
	
	<script>

		//아이디, 비밀번호의 유효성 여부, 비밀번호 확인 유효성을 관리 -> 셋 중 하나라도 유효하지 않으면, form 전송 X
		//id 가용성 체크
		let isIdValid = false;
		//pwd 비밀번호 입력 가용성 체크
		let isPwdInputValid = false;
		//pwd2 비밀번호 확인 : pwd 입력과 pwd2 입력이 일치하는지 확인한다.
		let isPwd2InputValid = false;
	
		//id 체크 
		//1. 아이디를 검증할 정규식 : 영문자 소문자로 시작하고, 5 ~ 10글자 이내로 입력
		//2. db 에서 해당 id 가 있는지 check
		document.querySelector("#id").addEventListener("input", function(){
			//input 에 입력한 값 가져오기
			const inputId = this.value;
			//id 를 넣는 input 문서 객체 가져오기
			const input = this;
			// id-invalid-feedback : 사용 불가능 메시지가 띄워질 div
			// id 형식이 맞지 않을 때/id가 존재할 때 내용을 바꾸기 위해서 가져왔음
			const idInvalidFeedback = document.querySelector("#id-invalid-feedback");
			
			//id 입력값이 바뀔 때, 일단 모든 가용성 체크 class 제거
			input.classList.remove("is-invalid");
			input.classList.remove("is-valid");
			
			//input 값이 공백이라면? -> 체크할 필요 없음(return)
			if(inputId === ""){
				//id 는 가용하지 않음
				isIdValid = false;
				return
			}
					
			//아이디를 검증할 정규식 : 영문자 소문자로 시작하고, 5 ~ 10글자 이내로 입력
			const reg_id = /^[a-z].{4,9}$/;
			
			//입력한 아이디가 정규식과 매칭되지 않는다 -> 올바른 형식이 아님 -> 올바른 형식이 아님을 표기 -> return(끝)
			if(!reg_id.test(inputId)){
				//id 는 가용하지 않음 : 올바른 형식이 아님
				isIdValid = false;
				//글씨 색 변경 - 추후 디자인메 맞춰 변경하기
				idInvalidFeedback.style.color = "#ffd400";
				idInvalidFeedback.innerText = "아이디 형식에 맞지 않습니다.";
				
				//input 에 is-invalid 추가
				input.classList.add("is-invalid");
				
				//함수를 끝낸다
				return;
			}
			
			//입력한 아이디가 정규식과 매칭되어 아래로 진행
			//ajax 로 db 에서 해당 id 가 있는지 check : id 는 pk 이므로, 동일한 값이 있으면 X
			fetch("${pageContext.request.contextPath}/users/id_check.jsp?inputId="+inputId)
			.then(function(response){
				return response.json();
			})
			.then(function(data){
				//data : {"isExist" : true/false} 형태의 object
				if(data.isExist){
					//같은 id 가 존재하면 -> 사용할 수 없는 id 임을 표시
					
					//id 는 가용하지 않음 : 이미 존재하는 id
					isIdValid = false;
					
					// id 가 이미 존재한다. -> 사용 불가능 메시지 띄움(붉은색)
					idInvalidFeedback.innerText = "사용할 수 없는 아이디입니다.";
					idInvalidFeedback.style.color = "red";
					
					//input 에 is-invalid 추가
					input.classList.add("is-invalid");
				}else{
					//같은 id 없으면 -> 사용 가능 메시지 띄움(초록색)
					
					//사용할 수 있는 id
					isIdValid = true;
					
					//input is-valid 추가
					input.classList.add("is-valid");
				}
			});
		});
		
		//비밀번호 입력에서 형식에 맞게 입력했는지 확인
		document.querySelector("#pwd").addEventListener("input", function(){
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
			//만일 입력한 비밀번호(pwd)가 정규표현식과 매칭되지 않는다면 -> 올바른 형식이 아님
			if(!reg_pwd.test(inputPwd)){
				//정규 표현식에 매칭되지 않음 -> 가용하지 않은 비밀번호
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
		
		//비밀번호 확인 함수 -> pwd2 의 input 이벤트 콜백함수로도 사용할 것
		function checkPwd(){
			//input#pwd 입력값 가져오기
			const pwd = document.querySelector("#pwd").value;
			//input#pwd2 요소 객체 가져오기
			const pwdInputCheck = document.querySelector("#pwd2");
			//input#pwd2 의 입력값 읽어오기
			const pwd2 = pwdInputCheck.value;
			
			//is-invalid 와 is-valid class 를 제거한다.
			pwdInputCheck.classList.remove("is-invalid");
			pwdInputCheck.classList.remove("is-valid");
			
			//비밀번호 확인(pwd2) 입력 없으면 -> 확인할 필요 X
			if(pwd2 === ""){
				//비밀번호가 매칭되지 않는다
				isPwd2InputValid = false;
				return;	//함수 끝
			}
			
			//pwd2 가 가용하지 않는 경우
			//1. 비밀번호 입력(pwd)와 확인란(pwd2) 값이 일치하는지 확인한다.
			//2. isPwd2InputValid : false 일 때 -> pwd 에 입력한 값이 가용하지 않음
			if(pwd != pwd2 || !isPwdInputValid){
				//pwd2 는 가용하지 않음
				isPwd2InputValid = false;
				pwdInputCheck.classList.add("is-invalid");
			}else{
				//비밀번호(pwd)가 가용하고, 비밀번호(pwd)와 비밀번호 확인란(pwd2)의 value 가 같다. -> ok
				isPwd2InputValid = true;
				pwdInputCheck.classList.add("is-valid");
			}
		}
		
		//비밀번호 확인란에 input 이벤트가 일어 났을때 실행할 함수 등록
		document.querySelector("#pwd2").addEventListener("input", checkPwd);
		
		//form 의 submit 이벤트가 일어났을 때의 콜백함수 등록
		document.querySelector("#loginForm").addEventListener("submit", function(e){
			//입력한 아이디, 비밀번호의 유효성 여부를 확인해서, 하나라도 유효하지 않으면 폼의 제출을 막아야한다.
			//폼 전체의 유효성 알아내기
			let isFormValid = isIdValid && isPwdInputValid && isPwd2InputValid;
			
			//폼이 유효하지 않으면 -> 폼 전송 막기
			if(!isFormValid){
				//폼 전송 막기
				e.preventDefault();
				//다시 입력해달라는 alert 띄우기
				alert("다시 입력해주세요.");
			}
		});
		
		
	</script>
</body>
</html>