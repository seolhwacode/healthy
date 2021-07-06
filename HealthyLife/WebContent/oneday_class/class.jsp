<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/oneday_class/class.jsp</title>
<jsp:include page="/include/resource.jsp"></jsp:include>
<style>
</style>
</head>
<body>
<jsp:include page="/include/navbar.jsp"></jsp:include>
<div class="container-fluid">
<div class="row" id="classes">
  <div class="col col-sm-6">
    <div class="card text-center h-100 w-50">
      <img src="https://images.unsplash.com/photo-1588286840104-8957b019727f?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80" class="card-img-top" alt="...">
      <div class="card-body">
        <h5 class="card-title">구라요가와 함께하는 아쉬탕가</h5>
        <p class="card-text">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Iusto provident repellat cum a tempora incidunt vitae architecto possimus accusamus eveniet amet debitis natus repellendus! Veritatis recusandae praesentium aliquid quam eos.</p>
		<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal" data-class="구라요가와 함께하는 아쉬탕가">예약하기</button>
      </div>
    </div>
  </div>
  <div class="col col-sm-6">
    <div class="card text-center h-100 w-50" >
      <img src="https://images.unsplash.com/photo-1517931524326-bdd55a541177?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80" class="card-img-top" alt="...">
      <div class="card-body">
        <h5 class="card-title">땅구 부부의 버닝 유산소</h5>
        <p class="card-text">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quasi voluptatum facilis a dolore tenetur culpa nemo magnam exercitationem dolores repudiandae modi eius mollitia doloribus maiores quas cupiditate dolor error sequi.</p>
		<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal" data-class="땅구 부부의 버닝 유산소">예약하기</button>
      </div>
    </div>
  </div>
  <div class="col col-sm-6">
    <div class="card text-center h-100 w-50">
      <img src="https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=750&q=80" class="card-img-top" alt="...">
      <div class="card-body">
        <h5 class="card-title">비타민구라의 열정 PT</h5>
        <p class="card-text">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Vel sint inventore at quaerat ullam odit animi est odio dicta labore totam quas quis deserunt beatae blanditiis in minima pariatur eveniet.</p>
      	<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal" data-class="비타민구라의 열정 PT">예약하기</button>
      </div>
    </div>
  </div>
  <div class="col col-sm-6">
    <div class="card text-center">
      <img src="https://images.unsplash.com/photo-1588196749597-9ff075ee6b5b?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=967&q=80" class="card-img-top" alt="...">
      <div class="card-body">
        <h5 class="card-title">직장인을 위한 온라인 필라테스</h5>
        <p class="card-text">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Porro nemo impedit nulla nam magni illum assumenda ducimus maxime molestias adipisci asperiores aliquam exercitationem in voluptas voluptatibus commodi pariatur doloremque veniam!</p>
      	<button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#exampleModal" data-class="직장인을 위한 온라인 필라테스">예약하기</button>
      </div>
    </div>
  </div>
</div>
</div>

<!-- modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">클래스 예약하기</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
				<div class="modal-body">
					<form action="${pageContext.request.contextPath}/oneday_class/private/booking.jsp" method="get" id="submitForm">
						<div class="mb-3">
							<label for="className" class="col-form-label">클래스명</label> 
							<input type="text" class="form-control" name="className" id="className" />
						</div>
						<div class="mb-3">
							<label for="name" class="col-form-label">이름</label> 
							<input type="text" class="form-control" name="name" id="name">
						</div>
						<div class="mb-3">
							<label for="phone" class="col-form-label">번호</label>
							 <input type="text" class="form-control" name="phone" id="phone" placeholder="010-1234-5678">
						</div>
						<div class="mb-3">
							<label for="date" class="col-form-label">신청 날짜</label> 
							<input type="date" class="form-control" name="date" id="date" />
						</div>
						<div class="mb-3">
							<label for="mention" class="col-form-label">기타</label> 
							<input type="text" class="form-control" name="mention" id="mention" />
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
							<button type="submit" class="btn btn-primary">예약하기</button>
						</div>
					</form>
				</div>

			</div>
  </div>
</div>
<script>
	classNameSend("#classes .btn");
	function classNameSend(sel) {
		//댓글 수정 링크의 참조값을 배열에 담아오기 
		// sel 은  ".page-xxx  .update-link" 형식의 내용이다 
		let classNames = document.querySelectorAll(sel);
		for (let i = 0; i < classNames.length; i++) {
			
			classNames[i].addEventListener("click", function() {
				//click 이벤트가 일어난 바로 그 요소의 data-num 속성의 value 값을 읽어온다. 
				const className = this.getAttribute("data-class");
				document.querySelector("#className").value = className;
			});
			
		}
	}
	
</script>
</body>
</html>