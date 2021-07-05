<%@page import="oneday.booking.dto.BookingDto"%>
<%@page import="oneday.booking.dao.BookingDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%

int num = Integer.parseInt(request.getParameter("num"));

BookingDao.getInstance().addViewCount(num);
BookingDto tmp = new BookingDto();

tmp.setNum(num);

BookingDto dto = new BookingDto();
dto= BookingDao.getInstance().getData(tmp);

String writer = (String)session.getAttribute("id");
if(!writer.equals(dto.getWriter())){
	response.sendError(HttpServletResponse.SC_FORBIDDEN,"접근할 수 없습니다.");//error code를 전달해야한다.
	return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<jsp:include page="/include/resource.jsp"></jsp:include>
</head>
<body>
	<jsp:include page="/include/navbar.jsp"></jsp:include>
	<table>
		<tr>
			<th>글 번호</th>
			<td><%=dto.getNum() %></td>
		</tr>
		<tr>
			<th>조회수</th>
			<td><%=dto.getViewCount() %></td>
		</tr>
		<tr>
			<th>작성자</th>
			<td><%=dto.getWriter() %></td>
		</tr>
		<tr>
			<th>예약자</th>
			<td><%=dto.getName() %></td>
		</tr>
		<tr>
			<th>연락처</th>
			<td><%=dto.getPhone() %></td>
		</tr>
		<tr>
			<th>클래스명</th>
			<td><%=dto.getClassName() %></td>
		</tr>
		<tr>
			<th>클래스 날짜</th>
			<td><%=dto.getClassDate() %></td>
		</tr>
		<tr>
			<td colspan="2">
				<div class="content"><%=dto.getMention() %></div>
			</td>
		</tr>
	</table>
	<a href="bookingList.jsp">목록보기</a>
	<button type="button" class="btn btn-primary" data-bs-toggle="modal"
		data-bs-target="#exampleModal" data-bs-whatever="@mdo">수정</button>
	<button type="button" id="deleteBtn" class="btn btn-danger">삭제</button>
	<!-- 수정 modal -->
	<div class="modal fade" id="exampleModal" tabindex="-1"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">클래스 예약하기</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form action="update.jsp">
					<input type="hidden" class="form-control" name="num" id="num" value="<%= dto.getNum() %>">
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
							<button type="button" class="btn btn-secondary"
								data-bs-dismiss="modal">닫기</button>
							<button type="submit" class="btn btn-primary">수정하기</button>
						</div>
					</form>
				</div>

			</div>
		</div>
	</div>
	
	<script>
	const deleteBtn = document.querySelector("#deleteBtn")

	function goDelete(){
		let isConfirm = confirm("정말 삭제하시겠습니까?");
		if(isConfirm){
		location.href="delete.jsp?num=<%=dto.getNum()%>";
		}
	}
	
	deleteBtn.addEventListener("click", goDelete);
	</script>
</body>
</html>