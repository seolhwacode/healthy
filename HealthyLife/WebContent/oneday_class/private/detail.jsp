<%@page import="java.util.List"%>
<%@page import="oneday.booking.dao.BookingCommentDao"%>
<%@page import="oneday.booking.dto.BookingCommentDto"%>
<%@page import="oneday.booking.dto.BookingDto"%>
<%@page import="oneday.booking.dao.BookingDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%

int num = Integer.parseInt(request.getParameter("num"));

BookingDao.getInstance().addViewCount(num);

BookingDto dto = new BookingDto();
dto.setNum(num);
dto= BookingDao.getInstance().getData(dto);

String writer = (String)session.getAttribute("id");
if(!writer.equals(dto.getWriter())){
	response.sendError(HttpServletResponse.SC_FORBIDDEN,"접근할 수 없습니다.");//error code를 전달해야한다.
	return;
}

//로그인된 아이디 
String id = (String)session.getAttribute("id");
//로그인 여부
boolean isLogin=false;
if(id != null){
	isLogin=true;
}

/* 
	[댓글 페이징 처리에 관련된 로직]
*/

	//한 페이지에 몇개씩 표시할 것인지
	final int PAGE_ROW_COUNT=10;
	
	//detail.jsp 페이지에서는 항상 1페이지의 댓글 내용만 출력한다.
	int pageNum=1;
	
	//보여줄 페이지 시작 ROWNUM
	int startRowNum=1+(pageNum-1)*PAGE_ROW_COUNT;
	//보여풀 페이지의 끝 ROWNUM
	int endRowNum=pageNum*PAGE_ROW_COUNT;
	
	//원글의 글 번호를 이용해서 해당글에 달린 댓글 목록을 얻어온다.
	BookingCommentDto commentDto = new BookingCommentDto();
	commentDto.setRef_group(num); //ref_group은 해당 글의 번호니까 num을 넣어준다.
	//startRowNum과 endRowNum을 dto에 담는다
	commentDto.setStartRowNum(startRowNum);
	commentDto.setEndRowNum(endRowNum);
	
	//1페이지에 해당하는 댓글 목록만 select 되도록 한다.
	List<BookingCommentDto> commentList =
		BookingCommentDao.getInstance().getList(commentDto);
	
	//원글의 글 번호를 이용해서 댓글 전체의 갯수를 얻어낸다.
	int totalRow = BookingCommentDao.getInstance().getCount(num);
	//댓글 전체 페이지의 개수
	int totalPageCount = (int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
@import url('https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@700&display=swap');
	
	.container{
		font-family: 'Nanum Gothic', sans-serif;
	}
	
	#back_list{
		position: relative;
		top: 10px;
		left: 20px;
	}
	
	.content{
		border: 3px solid #C6E2FF;
		margin: 0 auto;
		align: center;
		width: 800px;
		height: 600px;
	}
	
	/*댓글 프로필 이미지를 작은 원형으로 만든다.*/
	.profile-image{
		width: 50px;
		height: 50px;
		border: 1px solid #cecece;
		border-radius: 50%;
	}
	
	/*댓글 폼 크기 수정*/
	.comment-form textarea{
		width: 84%;
		height: 100px;
	}
	
	.comments {
		width: 850px;
		margin: 20px auto;
	}
	
	/*댓글에 댓글을 다는 폼과 수정폼은 일단 숨긴다.*/
	.comments .comment-form{
		display: none;
	}
	
	.comment-form{
		margin: 0 auto;
		width: 800px;
	}
	
	.loader{
		text-align: center;
	}
	
	li{
		list-style: none;
	}
	
	#className{
		text-align: center;
	}
	
	.profile > p{
		position: relative;
		left: 20px;
		margin-bottom: 5px;
	}
	
	.mention-block{
		align: center;
		text-align: center;
		background-color: #ffffff;
		border-radius: 10%;
		height: 300px;
		width: 400px;
		margin: 5px; 5px; 
	}
	.buttons{
		position: relative;
		top: -5px;
		left: 650px;
	}
	
	.table{
		margin-top: 20px;
	}

	#mention-block {
		position: relative;
		left: 20px;
	}
</style>
<jsp:include page="/include/resource.jsp"></jsp:include>
</head>
<body>
<div class="container">
	<jsp:include page="/include/navbar.jsp"></jsp:include>
	<div class="content">
	<a id="back_list" href="classList.jsp">예약 목록 ></a>
	<div class="buttons">
	<button type="button" class="btn btn-outline-info" data-bs-toggle="modal"
		data-bs-target="#exampleModal" data-bs-whatever="@mdo">수정</button>
	<button type="button" id="deleteBtn" class="btn btn-outline-danger">삭제</button>
	</div>
	<h1 id="className">🧘‍♂️예약 내역🏄‍♀️</h1>
	<div class="profile">
		<p id="num">글 번호 | <%=dto.getNum() %></p>
		<p id="id">작성자 | <%=dto.getWriter() %></p>
		<p id="viewCount">조회수 | <%=dto.getViewCount() %></p>
	</div>
	<table class="table table-light">
		<tbody>
			<tr>
				<th>📌</th>
				<td colspan="5"><%=dto.getClassName() %></td>
			</tr>
			<tr>
				<th>👨‍🦲</th>
				<td colspan="5"><%=dto.getName() %></td>
			</tr>
			<tr>
				<th>📞</th>
				<td><%=dto.getPhone() %></td>
				<th>📆</th>
				<td> <%=dto.getClassDate() %></td>
			</tr>
		</tbody>
	</table>
	<div class="metion-block">
		<h4 id="mention-block"><%=dto.getMention() %></h4>
	</div>
	</div>
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
	
	<!-- 댓글 목록 -->
	   <div class="comments">
      <ul>
         <%for(BookingCommentDto tmp: commentList){ %>
            <%if(tmp.getDeleted().equals("yes")){ %>
               <li>삭제된 댓글 입니다.</li>
            <% 
               // continue; 아래의 코드를 수행하지 않고 for 문으로 실행순서 다시 보내기 
               continue;
            }%>
         
            <%if(tmp.getNum() == tmp.getComment_group()){ %>
            <li id="reli<%=tmp.getNum()%>">
            <%}else{ %>
            <li id="reli<%=tmp.getNum()%>" style="padding-left:50px;">
               <svg class="reply-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-return-right" viewBox="0 0 16 16">
                    <path fill-rule="evenodd" d="M1.5 1.5A.5.5 0 0 0 1 2v4.8a2.5 2.5 0 0 0 2.5 2.5h9.793l-3.347 3.346a.5.5 0 0 0 .708.708l4.2-4.2a.5.5 0 0 0 0-.708l-4-4a.5.5 0 0 0-.708.708L13.293 8.3H3.5A1.5 1.5 0 0 1 2 6.8V2a.5.5 0 0 0-.5-.5z"/>
               </svg>
            <%} %>
               <dl>
                  <dt>
                  <%if(tmp.getProfile() == null){ %>
                     <svg class="profile-image" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
                          <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
                          <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
                     </svg>
                  <%}else{ %>
                     <img class="profile-image" src="${pageContext.request.contextPath}<%=tmp.getProfile()%>"/>
                  <%} %>
                     <span><%=tmp.getWriter() %></span>
                  <%if(tmp.getNum() != tmp.getComment_group()){ %>
                     @<i><%=tmp.getTarget_id() %></i>
                  <%} %>
                     <span><%=tmp.getRegdate() %></span>
                     <a data-num="<%=tmp.getNum() %>" href="javascript:" class="reply-link">
                     	<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-clipboard-plus" viewBox="0 0 16 16">
						  <path fill-rule="evenodd" d="M8 7a.5.5 0 0 1 .5.5V9H10a.5.5 0 0 1 0 1H8.5v1.5a.5.5 0 0 1-1 0V10H6a.5.5 0 0 1 0-1h1.5V7.5A.5.5 0 0 1 8 7z"/>
						  <path d="M4 1.5H3a2 2 0 0 0-2 2V14a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V3.5a2 2 0 0 0-2-2h-1v1h1a1 1 0 0 1 1 1V14a1 1 0 0 1-1 1H3a1 1 0 0 1-1-1V3.5a1 1 0 0 1 1-1h1v-1z"/>
						  <path d="M9.5 1a.5.5 0 0 1 .5.5v1a.5.5 0 0 1-.5.5h-3a.5.5 0 0 1-.5-.5v-1a.5.5 0 0 1 .5-.5h3zm-3-1A1.5 1.5 0 0 0 5 1.5v1A1.5 1.5 0 0 0 6.5 4h3A1.5 1.5 0 0 0 11 2.5v-1A1.5 1.5 0 0 0 9.5 0h-3z"/>
						</svg>
                     </a>
                  <%if(id != null && tmp.getWriter().equals(id)){ %>
                     <a data-num="<%=tmp.getNum() %>" class="update-link" href="javascript:">
                     <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-pencil-fill" viewBox="0 0 16 16">
					  	<path d="M12.854.146a.5.5 0 0 0-.707 0L10.5 1.793 14.207 5.5l1.647-1.646a.5.5 0 0 0 0-.708l-3-3zm.646 6.061L9.793 2.5 3.293 9H3.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.207l6.5-6.5zm-7.468 7.468A.5.5 0 0 1 6 13.5V13h-.5a.5.5 0 0 1-.5-.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.5-.5V10h-.5a.499.499 0 0 1-.175-.032l-.179.178a.5.5 0 0 0-.11.168l-2 5a.5.5 0 0 0 .65.65l5-2a.5.5 0 0 0 .168-.11l.178-.178z"/>
					 </svg>
                     </a>
                     <a data-num="<%=tmp.getNum() %>" class="delete-link" href="javascript:">
                     <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-trash-fill" viewBox="0 0 16 16">
					  <path d="M2.5 1a1 1 0 0 0-1 1v1a1 1 0 0 0 1 1H3v9a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V4h.5a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H10a1 1 0 0 0-1-1H7a1 1 0 0 0-1 1H2.5zm3 4a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 .5-.5zM8 5a.5.5 0 0 1 .5.5v7a.5.5 0 0 1-1 0v-7A.5.5 0 0 1 8 5zm3 .5v7a.5.5 0 0 1-1 0v-7a.5.5 0 0 1 1 0z"/>
					</svg>
                     </a>
                  <%} %>
                  </dt>
                  <dd>
                     <pre id="pre<%=tmp.getNum()%>"><%=tmp.getContent() %></pre>                  
                  </dd>
               </dl>   
               <!-- 대댓글 폼 -->
               <form id="reForm<%=tmp.getNum() %>" class="animate__animated comment-form re-insert-form" 
                  action="comment_insert.jsp" method="post">
                  <div class="input-group mb-3">
                  <input type="hidden" name="ref_group"
                     value="<%=dto.getNum()%>"/>
                  <input type="hidden" name="target_id"
                     value="<%=tmp.getWriter()%>"/>
                  <input type="hidden" name="comment_group"
                     value="<%=tmp.getComment_group()%>"/>
  				<textarea name="content" type="text" class="form-control" placeholder="댓글을 입력하세요..." aria-label="Recipient's username" aria-describedby="button-addon2"></textarea>
 				 <button class="btn btn-outline-secondary" type="submit" id="button-addon2">등록</button>	
				  </div>
               </form>   
               <!-- 수정 댓글 폼 -->
               <%if(tmp.getWriter().equals(id)){ %>   
               <form id="updateForm<%=tmp.getNum() %>" class="comment-form update-form" 
                  action="comment_update.jsp" method="post">
                  <div class="input-group mb-3">
                  <input type="hidden" name="num" value="<%=tmp.getNum() %>" />
                  <textarea name="content" type="text" class="form-control" placeholder="댓글을 입력하세요..." aria-label="Recipient's username" aria-describedby="button-addon2"><%=tmp.getContent() %></textarea>
                  <button class="btn btn-outline-secondary" type="submit" id="button-addon2">수정</button>
               </form>
               <%} %>                  
            </li>
         <%} %>
      </ul>
   </div>
   <!-- 로더 버튼 -->
   <div class="loader">
	<button type="button">댓글 더 보기</button>
	</div>
	 <!-- 원글에 댓글을 작성할 폼 -->
   <form class="comment-form insert-form" action="comment_insert.jsp" method="post">
      <!-- 원글의 글번호가 댓글의 ref_group 번호가 된다. -->
      <div class="input-group mb-3"> 
      <input type="hidden" name="ref_group" value="<%=num%>"/>
      <!-- 원글의 작성자가 댓글의 대상자가 된다. -->
      <input type="hidden" name="target_id" value="<%=dto.getWriter()%>"/>
      <textarea type="text" class="form-control" placeholder="댓글을 입력하세요..." aria-label="Recipient's username" aria-describedby="button-addon2" name="content"><%if(!isLogin){%>댓글 작성을 위해 로그인이 필요 합니다.<%}%></textarea>
      <button class="btn btn-outline-secondary"id="button-addon2" type="submit">등록</button>
  	</div>
   </form>
</div>
<script src="${pageContext.request.contextPath}/js/gura_util.js"></script>
<script>

	//클라이언트가 로그인 했는지 여부
	let isLogin=<%=isLogin%>;
	
	  document.querySelector(".insert-form")
      .addEventListener("submit", function(e){
         //만일 로그인 하지 않았으면 
         if(!isLogin){
            //폼 전송을 막고 
            e.preventDefault();
            //로그인 폼으로 이동 시킨다.
            location.href=
               "${pageContext.request.contextPath}/users/loginform.jsp?url=${pageContext.request.contextPath}/cafe/detail.jsp?num=<%=num%>";
         }
      });
   

	  addUpdateFormListener(".update-form");
	  addUpdateListener(".update-link");
	  addDeleteListener(".delete-link");
	  addReplyListener(".reply-link");
	  
	  //댓글의 현재 페이지 번호를 관리할 변수를 만들고 초기값 1 대입하기
	   let currentPage=1;
	   //마지막 페이지는 totalPageCount 이다.  
	   let lastPage=<%=totalPageCount%>;
	   
	  
	   //댓글의 수가 10개보다 적으면 버튼 감추기
	   if(<%=totalRow%> < 10){
		   document.querySelector(".loader").style.display="none";
	   } 
	   
	   document.querySelector(".loader").addEventListener("click", function(){
	     
	    
	      //현재 페이지가 마지막 페이지보다 같거나 작으면 페이지 로딩
	      if(currentPage <= lastPage){
	        
	         //현재 댓글 페이지를 1 증가 시키고 
	         currentPage++;
	         
	         /*
	            해당 페이지의 내용을 ajax 요청을 통해서 받아온다.
	            "pageNum=xxx&num=xxx" 형식으로 GET 방식 파라미터를 전달한다. 
	         */
	         ajaxPromise("ajax_comment_list.jsp","get",
	               "pageNum="+currentPage+"&num=<%=num%>")
	         .then(function(response){
	            //json 이 아닌 html 문자열을 응답받았기 때문에  return response.text() 해준다.
	            return response.text();
	         })
	         .then(function(data){
	            //data 는 html 형식의 문자열이다. 
	            console.log(data);
	            // beforebegin | afterbegin | beforeend | afterend
	            document.querySelector(".comments ul")
	               .insertAdjacentHTML("beforeend", data);
	            //로딩이 끝났다고 표시한다.
	            isLoading=false;
	            //새로 추가된 댓글 li 요소 안에 있는 a 요소를 찾아서 이벤트 리스너 등록 하기 
	            addUpdateListener(".page-"+currentPage+" .update-link");
	            addDeleteListener(".page-"+currentPage+" .delete-link");
	            addReplyListener(".page-"+currentPage+" .reply-link");
	            //새로 추가된 댓글 li 요소 안에 있는 댓글 수정폼에 이벤트 리스너 등록하기
	            addUpdateFormListener(".page-"+currentPage+" .update-form");

	         });
	       	//현재 페이지가 마지막 페이지면 로딩바 숨기기
			if(currentPage == lastPage){
			  	document.querySelector(".loader").style.display="none";
			//현재 페이지가 마지막 페이지가 아니면 로딩바 보이기
			}else{
				document.querySelector(".loader").style.display="block";
			}
	      }
	      
	   });
	   
	//게시글을 삭제하는 기능
	const deleteBtn = document.querySelector("#deleteBtn")

	function goDelete(){
		let isConfirm = confirm("정말 삭제하시겠습니까?");
		if(isConfirm){
		location.href="delete.jsp?num=<%=dto.getNum()%>";
		}
	}
	
	deleteBtn.addEventListener("click", goDelete);
	
	//대댓글 추가 리스너
	function addReplyListener(sel){
      //댓글 링크의 참조값을 배열에 담아오기 
      let replyLinks=document.querySelectorAll(sel);
      //반복문 돌면서 모든 링크에 이벤트 리스너 함수 등록하기
      for(let i=0; i<replyLinks.length; i++){
         replyLinks[i].addEventListener("click", function(){
            if(!isLogin){
               const isMove=confirm("로그인이 필요 합니다. 로그인 페이지로 이동 하시겠습니까?");
               if(isMove){
                  location.href=
                     "${pageContext.request.contextPath}/users/loginform.jsp?url=${pageContext.request.contextPath}/oneday_class/private/detail.jsp?num=<%=num%>";
               }
               return;
            }
            
            //click 이벤트가 일어난 바로 그 요소의 data-num 속성의 value 값을 읽어온다. 
            const num=this.getAttribute("data-num"); //댓글의 글번호
            
            const form=document.querySelector("#reForm"+num);
            
            //현재 문자열을 읽어온다 ( "답글" or "취소" )
            let current = this.innerText;
            
            if(current == "답글"){
               //번호를 이용해서 댓글의 댓글폼을 선택해서 보이게 한다. 
               form.style.display="block";
               this.innerText="취소";   
            }else if(current == "취소"){
               this.innerText="답글";
               form.style.display="none";
            }
         });
      }
   }
	// 댓글 수정 리스너
	  function addUpdateFormListener(sel){
      //댓글 수정 폼의 참조값을 배열에 담아오기
      let updateForms=document.querySelectorAll(sel);
      for(let i=0; i<updateForms.length; i++){
         //폼에 submit 이벤트가 일어 났을때 호출되는 함수 등록 
         updateForms[i].addEventListener("submit", function(e){
            //submit 이벤트가 일어난 form 의 참조값을 form 이라는 변수에 담기 
            const form=this;
            //폼 제출을 막은 다음 
            e.preventDefault();
            //이벤트가 일어난 폼을 ajax 전송하도록 한다.
            ajaxFormPromise(form)
            .then(function(response){
               return response.json();
            })
            .then(function(data){
               if(data.isSuccess){
                  /*
                     document.querySelector() 는 html 문서 전체에서 특정 요소의 
                    	 참조값을 찾는 기능
                     
                    	 특정문서의 참조값.querySelector() 는 해당 문서 객체의 자손 요소 중에서
                     	특정 요소의 참조값을 찾는 기능
                  */
                  const num=form.querySelector("input[name=num]").value;
                  const content=form.querySelector("textarea[name=content]").value;
                  //수정폼에 입력한 value 값을 pre 요소에도 출력하기 
                  document.querySelector("#pre"+num).innerText=content;
                  form.style.display="none";
               }
            });
         });
      }

   }
	
	//댓글 삭제 리스너
	 function addDeleteListener(sel){
      //댓글 삭제 링크의 참조값을 배열에 담아오기 
      let deleteLinks=document.querySelectorAll(sel);
      for(let i=0; i<deleteLinks.length; i++){
         deleteLinks[i].addEventListener("click", function(){
            //click 이벤트가 일어난 바로 그 요소의 data-num 속성의 value 값을 읽어온다. 
            const num=this.getAttribute("data-num"); //댓글의 글번호
            const isDelete=confirm("댓글을 삭제 하시겠습니까?");
            if(isDelete){
               // gura_util.js 에 있는 함수들 이용해서 ajax 요청
               ajaxPromise("comment_delete.jsp", "post", "num="+num)
               .then(function(response){
                  return response.json();
               })
               .then(function(data){
                  //만일 삭제 성공이면 
                  if(data.isSuccess){
                     //댓글이 있는 곳에 삭제된 댓글입니다를 출력해 준다. 
                     document.querySelector("#reli"+num).innerText="삭제된 댓글입니다.";
                  }
               });
            }
         });
      }
   }
	
	//인자로 전달되는 선택자를 이용해서 이벤트 리스너를 등록하는 함수 
	   function addUpdateListener(sel){
	      //댓글 수정 링크의 참조값을 배열에 담아오기 
	      // sel 은  ".page-xxx  .update-link" 형식의 내용이다 
	      let updateLinks=document.querySelectorAll(sel);
	      for(let i=0; i<updateLinks.length; i++){
	         updateLinks[i].addEventListener("click", function(){
	            //click 이벤트가 일어난 바로 그 요소의 data-num 속성의 value 값을 읽어온다. 
	            const num=this.getAttribute("data-num"); //댓글의 글번호
	            document.querySelector("#updateForm"+num).style.display="block";
	            
	         });
	      }
	   }
	

</script>
</body>
</html>