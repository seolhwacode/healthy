<%@page import="videos.board.dao.VideosCommentDao"%>
<%@page import="java.util.List"%>
<%@page import="videos.board.dto.VideosCommentDto"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="test.users.dao.UsersDao"%>
<%@page import="test.users.dto.UsersDto"%>
<%@page import="videos.board.dao.VideosDao"%>
<%@page import="videos.board.dto.VideosDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//글의 번호(pk)를 읽어온다.
	int num = Integer.parseInt(request.getParameter("num"));

	//detail.jsp 가 호출되면, viewCount 가 +1 
	VideosDao.getInstance().addViewCount(num);
	
/*
   [ 검색 키워드에 관련된 처리 ]
   -검색 키워드가 파라미터로 넘어올수도 있고 안넘어 올수도 있다.      
*/	
	String keyword = request.getParameter("keyword");
	String condition = request.getParameter("condition");
	String type = request.getParameter("type");
	//만일 키워드가 넘어오지 않는다면?
	if(keyword == null){
		//키워드 검색 조건에 빈 문자열을 넣어준다.
		//클라이언트 웹브라우저에 출력할 때 "null" 을 출력되지 않게 하기 위해서
		keyword = "";
		condition = "";
	}
	//type 없을 때 or "not-selected" 일 때 => ""
	if("not-selected".equals(type) || type == null){
		type = "";
	}
	
	//특수기호를 인코딩한 키워드를 미리 준비한다.
	String encodeK = URLEncoder.encode(keyword);
	
	//getData 에 넘길 VideosDto 만듬
	VideosDto dto = new VideosDto();
	dto.setNum(num);
	
	//가져올 data 를 담을 dto 를 미리 만든다.
	VideosDto resultDto = null;
	
	//만약 컴색 키워드가 넘어온다면
	if(!keyword.equals("")){
		//검색 조건이 무엇이냐에 따라 분기 하기
		if(condition.equals("title_content")){//제목 + 내용 검색인 경우
			//검색 키워드를 CafeDto 에 담아서 전달한다.
	      	dto.setTitle(keyword);
	      	dto.setContent(keyword);
	      	//제목+내용 검색일때 호출하는 메소드를 이용해서 데이터
	      	resultDto = VideosDao.getInstance().getDataTC(dto);
		}else if(condition.equals("title")){ //제목 검색인 경우
			dto.setTitle(keyword);
			resultDto = VideosDao.getInstance().getDataT(dto);
		}else if(condition.equals("writer")){ //작성자 검색인 경우
			dto.setWriter(keyword);
			resultDto = VideosDao.getInstance().getDataW(dto);
		}
	}else if(!type.equals("")){//카테고리 검색인 경우 -> type 이 날아온다.
		dto.setType(type);
		resultDto = VideosDao.getInstance().getDataTy(dto);
	}else{//검색 키워드가 넘어오지 않는다면
		//키워드가 없을때 호출하는 메소드를 이용해서 파일 목록을 얻어온다.
		resultDto = VideosDao.getInstance().getData(dto);
	}
	
	
//profile 사진 읽어오기
	//읽어온 	resultDto 의 writer 와 id 가 같은 profile 을 읽어온다.
	UsersDto usersDto = new UsersDto();
	usersDto.setId(resultDto.getWriter());
	UsersDto resultUsersDto = UsersDao.getInstance().getData(usersDto);
	
//현재 로그인 중인 id
	String id = (String)session.getAttribute("id");
	//로그인 여부
	boolean isLogin = false;
	if(id != null)
		isLogin = true;
//video url 을 유튜브 출력하기위한 url 형태로 바꾸기
	//영상의 url 을 파싱
	String[] splitResults;
	//? 가 들은 경우 : youtube 창에서 맨 위의 주소창의 url 을 복사해온 경우
	if(resultDto.getVideo().contains("?")){
		splitResults = resultDto.getVideo().split("=");
	}else{
		splitResults = resultDto.getVideo().split("/");
	}
	//마지막 단어를 사용해서 유튜브 영상 출력을 위한 url 만들기
	String video = "https://www.youtube.com/embed/" + splitResults[splitResults.length - 1];	
	
	
//댓글 리스트 가져오기
	//원글의 글번호를 이용해서 해당 글에 달린 댓글 목록을 얻어온다.
	VideosCommentDto commentDto = new VideosCommentDto();
	commentDto.setRef_group(num);
	//VideosCommentDao 의 getList() 메소드를 사용하여 게시글의 댓글 읽어오기
	List<VideosCommentDto> commentList = VideosCommentDao.getInstance().getList(commentDto);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/videos/detail.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
<style>
	.ArticleContentBox{
		border: 1px solid #ebecef;
		border-radius: 6px;
		margin-top: 50px;
	}
	.comment_form textarea{
		width: 500px;
		height: 100px;
	}
	/*댓글의 프로필 사진 크기*/
	.commet_profile-image{
		width: 30px;
		height: 30px;
	}
	/*댓글에 댓글을 다는 form 은 처음에는 숨겨져있다.*/
	.re_insert_form{
		display: none;
	}
	    
</style>
</head>
<body>
	<div class="container">
		<div class="ArticleContentBox">
			<%if(resultDto.getPrevNum() != 0){ %>
			<a href="detail.jsp?num=<%=resultDto.getPrevNum() %>&condition=<%=condition%>&keyword=<%=encodeK%>&type=<%=type %>">이전글</a>
			<%} %>
			<%if(resultDto.getNextNum()!=0){ %>
			<a href="detail.jsp?num=<%=resultDto.getNextNum() %>&condition=<%=condition%>&keyword=<%=encodeK%>&type=<%=type %>">다음글</a>
			<%} %>
			
			<!-- 목록보기 / 삭제 버튼 -->
			<ul>
				<li><a href="list.jsp">목록보기</a></li>
				<%if(resultDto.getWriter().equals(id)){ %>
					<li><a href="${pageContext.request.contextPath}/videos/private/update_form.jsp?num=<%=num %>">수정</a></li>
					<li><a href="javascript:deleteConfirm()">삭제</a></li>
				<%} %>
			</ul>
			
			<table>
				<tr>
					<th>글번호</th>
					<td><%=num %></td>
				</tr>
				<tr>
					<th>제목</th>
					<td>
						<span>[<%=resultDto.getType() %>]</span>
						<%=resultDto.getTitle() %>
					</td>
				</tr>
				<tr>
					<th>좋아요</th>
					<td><%=resultDto.getGood_count() %></td>
				</tr>
				<tr>
					<th>프로필</th>
					<td>
					<%if(resultUsersDto.getProfile() == null){ %>
						<%-- 프로필 사진이 null 일  때 : 기본 사진 --%>
						<svg id="profileImage" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
							<path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
							<path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
						</svg>
					<%}else{ %>
						<img src="${pageContext.request.contextPath}<%=resultUsersDto.getProfile() %>" alt="프로필 사진" />
					<%} %>
					</td>
				</tr>
				<tr>
					<th>글쓴이</th>
					<td><%=resultDto.getWriter() %></td>
				</tr>
				<tr>
					<th>조회수</th>
					<td><%=resultDto.getView_count() %></td>
				</tr>
				<tr>
					<th>등록일</th>
					<td><%=resultDto.getRegdate()%></td>
				</tr>
				<tr>
					<th>동영상</th>
					<td>
						<%-- https://youtu.be/R6ti4FCLom4 에서 => /R6ti4FCLom4 부분만 잘라서 새로 db 에 input 해야한다. 이거 고치지--%>
						<iframe width="560" height="315" src="<%=video %>" title="YouTube video player" frameborder="0" 
						allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen>
						</iframe>
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<%-- textarea 에서는 html 을 해석하지 않고 그냥 출력하기 때문에, div 에 넣어준다. --%>
					<td>
						<div style="border:1px solid gray;">
							<%=resultDto.getContent() %>
						</div>
					</td>
				</tr>
			</table>
		</div>
		
<%-- 댓글 리스트 출력 --%>
		<div class="commet_box">
			<ul class="comment_list">
			<%for(VideosCommentDto tmp:commentList){ %>
							
				<%-- li : class="comment_item", id="commet_item_댓글num" --%>
				<%if(tmp.getNum() == tmp.getComment_group()){ %>
				<%-- tmp.getNum() == tmp.getComment_group() : 게시글에 댓글 -> 들여쓰기 X --%>
				<li class="comment_item" id="commet_item_<%=tmp.getNum() %>">
				<%}else{ %>
				<%-- tmp.getNum() != tmp.getComment_group() : 게시글에 댓글 -> 들여쓰기 O --%>
				<li class="comment_item" id="commet_item_<%=tmp.getNum() %>" style="padding-left:50px;">
				<%} %>				
					<dl>
						<!-- <dt>프로필 이미지, 작성자 아아디, 수정, 삭제 표시할 예정</dt> -->
						<dt>
							<span class="comment_profile_wrapper">
							<!-- 프로필 이미지 -->
							<%if(tmp.getProfile() == null){ %>
								<%-- 프로필 이미지 없음 -> 기본 이미지 출력 --%>
								<svg class="commet_profile-image" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
			  						<path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
			  						<path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
								</svg>
							<%}else{ %>
								<%-- 해당 이미지 출력 --%>
								<img class="commet_profile-image" src="${pageContext.request.contextPath}<%=tmp.getProfile() %>" alt="프로필 사진" />
							<%} %>
							</span>
							<!-- 작성자 id -->
							<span><%=tmp.getWriter() %></span>
						<%-- num != comment_group : 댓글에 단 댓글이다. --%>
						<%if(tmp.getNum() != tmp.getComment_group()){ %>
							<!-- 댓글의 댓글을 달 때, 어느 댓글인지 id 사용자 출력 -->
							@<i><%=tmp.getTarget_id() %></i>
						<%} %>
							<!-- 댓글 작성 일자 -->
							<span><%=tmp.getRegdate() %></span>
							<!-- 답글 다는 링크 -->
							<a data-num="<%=tmp.getNum() %>" href="javascript:" class="reply_link">댓글</a>
						<%if(id != null && tmp.getWriter().equals(id)){ %>
							<!-- 수정, 삭제 링크 : 댓글 num(pk) 데이터로 넘기기 -->
							<a data-num="<%=tmp.getNum() %>" href="javascript:" class="update_link">수정</a>
							<a data-num="<%=tmp.getNum() %>" href="javascript:" class="delete_link">삭제</a>
						<%} %>
						</dt>
						<dd>
							<pre><%=tmp.getContent() %></pre>
						</dd>
					</dl>
					<form id="reply_form_<%=tmp.getNum() %>" class="comment_form re_insert_form" 
							action="${pageContext.request.contextPath}/videos/private/comment_insert.jsp" 
							method="post">
						<!-- 원글의 글번호가 댓글의 ref_group 번호가 된다. -->
						<input type="hidden" name="ref_group" value="<%=resultDto.getNum()%>"/>
						<!-- '댓글'의 작성자가 대상자가 된다. -->
						<input type="hidden" name="target_id" value="<%=tmp.getWriter()%>"/>
                  		<!-- '댓글' 의 comment_group 을 따라간다. -->
                  		<input type="hidden" name="comment_group" value="<%=tmp.getComment_group()%>"/>
                  		<textarea name="content"></textarea>
                  		<button type="submit">등록</button>
					</form>
				</li>
			<%} %>
			</ul>
		</div>

<%-- 원글에 댓글을 작성할 폼 --%>
		<div class="insert_form_wrapper">
			<form class="comment_form insert_form" action="${pageContext.request.contextPath}/videos/private/comment_insert.jsp" method="post">
				<!-- 원글의 작성자가 대상자가 된다. -->
				<input type="hidden" name="target_id" value="<%=resultDto.getWriter() %>" />
				<!-- 원글의 글번호가 댓글의 ref_group 번호가 된다. -->
				<input type="hidden" name="ref_group" value="<%=num %>" />
				<textarea name="content"><%= isLogin ? "" : "댓글 작성을 위해 로그인이 필요합니다." %></textarea>
				<button type="submit">등록</button>
			</form>
		</div>		
	</div>
	
	
	<script>
		function deleteConfirm(){
			//삭제할지 물어봄
			let isDelete = confirm("삭제하시겠습니까?");
			//삭제 할 것 - ok = true
			if(isDelete){
				location.href = "${pageContext.request.contextPath}/videos/private/delete.jsp?num=<%=num %>";
			}
			//no : false -> 아무 일도 없음
		}
		
		
		//로그인 상태 - 댓글을 달려면 로그인을 꼭 해야한다!
		let isLogin = <%=isLogin %>;
		
		//페이지 로딩시에 출력되는 댓글들에 이벤트 리스너들 추가
		addReplyListener(".reply_link");
		
		
		
		//인자로 전달되는 선택자를 이용해서 이벤트 리스너를 등록하는 함수
		//sel = ".reply_link" : 처음 페이지에 출력할 때는 .page-N 클래스가 없다 -> 댓글 페이지
		//sel = ".page-N .reply_link" (N : currentPage) 형식의 내용이다.
		function addReplyListener(sel){
			//댓글 링크의 참조값을 배열에 담아오기
			let replyLinks = document.querySelectorAll(sel);
			//반복문 돌면서 모든 링크에 이벤트 리스터 함수 등록하기
			for(let i = 0; i < replyLinks.length; i++){
				replyLinks[i].addEventListener("click", function(){
					
					//댓글을 달려면 로그인을 꼭 해야한다! -> 로그인 페이지로 이동
					if(!isLogin){
						const isMove = confirm("로그인이 필요합니다. 로그인 페이지로 이동하시겠습니까?");
						if(isMove){
							location.href = "${pageContext.request.contextPath}/videos/login_form.jsp?url=${pageContext.request.contextPath}/videos/detail.jsp?num=<%=num%>";
						}
					}
					
					
					//click 이벤트가 일어난 바로 그 요소의 data-num 속성의 value 값을 읽어온다.
					//data-num : 댓글의 num(pk) 을 가지고 있다.
					const num = this.getAttribute("data-num");
					//열고 닫을 reForm 객체를 가져온다. - 번호를 이용해서 댓글의 댓글 폼을 선택
					const replyForm = document.querySelector("#reply_form_"+num);
					
					//링크의 텍스트를 읽어옴
					let current = this.innerText;
					
					if(current === "댓글"){
						//텍스트가 "답글" -> "취소" 로 바꾸고, reForm 의 display = "block" 으로 변경	
						this.innerText = "취소";
						//replyForm.classList.remove("animate__fadeOutDown");
						//replyForm.classList.add("animate__fadeInDown");
						replyForm.style.display = "block";
					}else if(current === "취소"){
						//텍스트가 "취소" -> "답글" 로 바꾸고, reForm 의 display = "none" 으로 변경
						this.innerText = "댓글";
						//replyForm.classList.remove("animate__fadeInDown");
						//replyForm.classList.add("animate__fadeOutDown");
						/* replyForm.addEventListener("animationend", function(){
							replyForm.style.display = "none";
						}, {once:true}); */
						replyForm.style.display = "none";
					}
				});
			}
		}
	</script>
</body>
</html>