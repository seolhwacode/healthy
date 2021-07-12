<%@page import="users.good.dao.UsersGoodDao"%>
<%@page import="users.good.dto.UsersGoodDto"%>
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
	
	
//댓글 리스트 가져오기 - 댓글 pagination 처리(더보기 누르면 댓글 추가)
	//한 페이지에 몇개씩 표시할 것인지
	final int PAGE_ROW_COUNT=10;

	//deatil.jsp 페이지에서는 항상 1페이지의 댓글 내용만 출력한다. -> 더보기로 ajax 요청할 것
	int pageNum = 1;
	
	//보여줄 페이지의 시작 ROWNUM
	int startRowNum = 1 + (pageNum - 1) * PAGE_ROW_COUNT;
	//보여줄 페이지의 끝 ROWNUM
	int endRowNum = pageNum * PAGE_ROW_COUNT;	

	//원글의 글번호를 이용해서 해당 글에 달린 댓글 목록을 얻어온다.
	VideosCommentDto commentDto = new VideosCommentDto();
	commentDto.setRef_group(num);
	//1페이지에 해당하는 startRowNum 과 endRowNum 을 dto 에 담아서 불러온다.
	commentDto.setStartRowNum(startRowNum);
	commentDto.setEndRowNum(endRowNum);
	
	//VideosCommentDao 의 getList() 메소드를 사용하여 게시글의 댓글 읽어오기
	List<VideosCommentDto> commentList = VideosCommentDao.getInstance().getList(commentDto);
	
	//게시글에 달린 댓글의 개수를 읽어옴
	int totalRow = VideosCommentDao.getInstance().getCommentCount(num);
	//전체 페이지의 개수 : (전체 row 의 개수 / 보여지는 리스트 개수) 올림
	int totalPageCount = (int)Math.ceil(totalRow / (double)PAGE_ROW_COUNT);
	
	
//좋아요 기능 추가
	//좋아요 유무 
	boolean isGood = false;
	//-> 로그인 했을 때만 db 에서 가져옴
	if(isLogin){
		//검색할 UsersGoodDto 만듬 - id : 로그인된 id / num : 글 번호
		UsersGoodDto goodDto = new UsersGoodDto(id, num);
		isGood = UsersGoodDao.getInstance().isExist(goodDto);
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/videos/detail.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
<style>
	/* 전체 content 크기 조절 */
	.container{
   		padding-bottom: 80px;
   		transition: all 1s ease-out;
    }

	@media(max-width: 576px){
		.container{
		    width: 500px;
		}
		/*동영상 크기*/
		/* 원래 크기 : width="560" height="315"*/
		.article_video iframe{
			width: 100%;
			height: 234px;
		}
	}
	@media(min-width: 576px){
		.container{
		    width: 600px;
		}
		/*동영상 크기*/
		/* 원래 크기 : width="560" height="315"*/
		.article_video iframe{
			width: 100%;
			height: 255px;
		}
	}
	@media(min-width: 768px){
		.container{
		    width: 700px;
		}
		/*동영상 크기*/
		/* 원래 크기 : width="560" height="315"*/
		.article_video iframe{
			width: 100%;
			height: 345px;
		}
	}
	
	@media (min-width: 992px){
    	.container{
		    width: 800px;
		}
		/*동영상 크기*/
		/* 원래 크기 : width="560" height="315"*/
		.article_video iframe{
			width: 100%;
			height: 403px;
		}
    }

	/* 게시글 전체 감싸는 div */
	.ArticleContentBox{
		border: 2px solid #ebecef;
		border-radius: 6px;
		margin-top: 20px;
		padding: 30px;
	}
	.comment_form textarea{
		width: 500px;
		height: 100px;
	}
	/*댓글의 프로필 사진 크기*/
	.commet_profile-image{
		width: 35px;
		height: 35px;
	}
	/*댓글에 댓글을 다는 form 은 처음에는 숨겨져있다.*/
	.re_insert_form{
		display: none;
	}
	/*댓글 수정하는 form 은 처음에는 숨겨져있다.*/
 	.update_form{
		display: none;
	}
	
	
	/*좋아요, 댓글개수 박스 -> link 는 색 변화 X*/
	.reply_box{
		display: flex;
	}
	.reply_box a{
		color: inherit;
	}
	/*좋아요, 댓글 개수 박스 -> 글씨, 아이콘 라인 맞추기*/
	.reply_box em, strong, .good_icon, .reply_icon{
		vertical-align: text-bottom;
	}
	/*inline-block 으로 해야 배경이 나온다.*/
	.good_button, .good_icon{
		display: inline-block;
	}
	
	/*좋아요 버튼 - 안눌렸을 때 - 빈 하트 배경의 그림*/
	.good_button.btn_off .good_icon{
		width: 20px;
		height: 20px;
		background-image: url('https://ca-fe.pstatic.net/web-pc/static/img/ico-post-like-f-53535.svg?a37a11006a542ce9949c0dd6779345b8=');
		background-repeat: no-repeat;
	}
	/*좋아요 버튼 - 눌렸을 때*/
	.good_button.btn_on .good_icon{
		width: 20px;
		height: 20px;
		background-image: url('https://ca-fe.pstatic.net/web-pc/static/img/ico-post-like-on-f-53535.svg?7eb6be9a4989d32af686acf09a07747d=');
		background-repeat: no-repeat;
	}
	/* 좋아요 버튼 & 댓글 개수  -> 사이 띄우기 */
	.good_wrapper, .reply_count_wrapper{
		margin-right: 20px;
	}
	
	
	/* 게시글 가장 위의 헤더 */
	.article_header{
	    border-bottom: 2px solid #e8e8e8;
	    margin-bottom: 20px;
	    padding-bottom: 15px;
	}
	
	/* 상위 이전글, 다음글, 목록, 수정, 삭제 버튼 감싸는 div */
	.menu_button_wrapper{
		display: flex;
		align-items: center;
		justify-content: space-between;
	}
	/* 상위 이전글, 다음글, 목록, 수정, 삭제 버튼 설정*/
	.menu_button_wrapper .btn{
		color: black;
	    background-color: #e8e8e8;
	}
	
	
	/*글 번호 css*/
	.post_num{
		color: #9595a5;
	}
	/*제목 - 카테고리 명*/
	.post_title span{
		margin-right: 8px;
	}
	.article_writer{
	    display: flex;
	}
	.post_writer_text{
		display: flex;
		padding: 5px 0;
	    margin-left: 5px;
	}
	/* 글씨 위치 맞추기 */
	.post_writer_text div{
	    margin: 0 5px;
	}
	/*프로필 사진 크기*/
	.profileImage{
		width: 35px;
		height: 35px;
	    border-radius: 50%;
	}
	
	
	/* 게시글 내용 표기하는 container : 동영상 & 글 */
	.article_container{
		border-bottom: 2px solid #e8e8e8;
		margin: 20px 0;
	}
	/* 비디오 div */
	.article_video{
		border-bottom: 2px solid #e8e8e8;
		margin: 20px 0;
		padding-bottom: 15px;
	}
	/* 글 내용 div */
	.article_viewer{
		padding: 20px 0;
	}
	
	
	/* 댓글 css*/
	/* ul 디스크 없애기 */
	.comment_list{
		list-style:none;
		padding-left: 0;
	}
	/* 댓글 하나 아래 boder 넣기 */
	/* 댓글 아래에 패딩 추가 */
	.comment_item{
		border-bottom: 1px solid #e8e8e8;
		padding: 10px 0;
	}
	
	/* 댓글에 댓글을 달 때 나오는 id - 밑줄 추가 */
	.comment_for_id{
		text-decoration: underline;
	}
	/* 댓글 프로필 / 내용 포함하는 div : flex 로 정렬 */
	.comment_flex{
		display: flex;
	}
	/* 오른쪽 margin 추가*/
	.comment_profile_wrapper{
		margin-right: 6px;
	}
	/* 댓글의 날짜, 댓글 달기 -> 작고 회색 글씨로 만들기 */
	.commet_function{
		font-size: 14px;
		color: #858b9c;
	}
	/* 날짜 오른쪽에 margin 추가 */
	.commet_function span{
		margin-right: 5px;
	}
	/* 댓글 출력 부분만 크기 늘리기 */
	.comment_box{
		flex-grow: 8;
	}
</style>
</head>
<body>
	<jsp:include page="../include/navbar.jsp">
		<jsp:param value="videos" name="thisPage"/>
	</jsp:include>
	<div class="container">
		<div class="menu_button_wrapper">
			<div class="left_buttons">
			<%if(resultDto.getPrevNum() != 0){ %>
				<a class="btn" href="detail.jsp?num=<%=resultDto.getPrevNum() %>&condition=<%=condition%>&keyword=<%=encodeK%>&type=<%=type %>">이전글</a>
			<%} %>
			<%if(resultDto.getNextNum()!=0){ %>
				<a class="btn" href="detail.jsp?num=<%=resultDto.getNextNum() %>&condition=<%=condition%>&keyword=<%=encodeK%>&type=<%=type %>">다음글</a>
			<%} %>
				<a class="btn" href="list.jsp">목록보기</a>
			</div>
			<div class="right_buttons">
			<%if(resultDto.getWriter().equals(id)){ %>
				<a class="btn" href="${pageContext.request.contextPath}/videos/private/update_form.jsp?num=<%=num %>">수정</a>
				<a class="btn" href="javascript:deleteConfirm()">삭제</a>
			<%} %>
			</div>
		</div>
	
		<div class="ArticleContentBox">
			<!-- 게시글 헤더 -->
			<div class="article_header">
				<!-- 게시글 제목 & 기본 정보 -->
				<div class="article_title">
					<!-- 게시글 번호 -->
					<div class="post_num">
						<span>글번호 : <%=num %></span>
					</div>
					<!-- 게시글 제목 -->
					<div class="post_title">
						<h2><span>[<%=resultDto.getType() %>]</span><%=resultDto.getTitle() %></h2>
					</div>
				</div>
				<!-- 게시글 작성자 -->
				<div class="article_writer">
					<!-- 게시글 작성자 프로필 사진 -->
					<div class="post_writer_profile">
					<%if(resultUsersDto.getProfile() == null){ %>
						<%-- 프로필 사진이 null 일  때 : 기본 사진 --%>
						<svg class="profileImage" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
							<path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
							<path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
						</svg>
					<%}else{ %>
						<img class="profileImage" src="${pageContext.request.contextPath}<%=resultUsersDto.getProfile() %>" alt="프로필 사진" />
					<%} %>
					</div>
					<div class="post_writer_text">
						<!-- 게시글 작성자 id -->
						<div class="post_writer_id">
							<strong>
								<%=resultDto.getWriter() %>
							</strong>
						</div>
						/
						<!-- 게시글 조회수 -->
						<div class="post_view_count">
							조회수 : <%=resultDto.getView_count() %>
						</div>
						/
						<!-- 게시글 작성일 -->
						<div class="post_regdate">
							<%=resultDto.getRegdate()%>
						</div>
					</div>
				</div>
			</div>
			
			<!-- 위의 div 에 border-bottm 으로 선긋기 -->
			
			<!-- 게시글 출력 -->
			<div class="article_container">
				<!-- 영상 출력 -->
				<div class="article_video">
					<iframe src="<%=video %>" title="YouTube video player" frameborder="0" 
					allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen>
					</iframe>
				</div>
				<!-- 게시글 내용 출력 -->
				<div class="article_viewer">
					<%-- textarea 에서는 html 을 해석하지 않고 그냥 출력하기 때문에, div 에 넣어준다. --%>
					<div class="content_main">
						<%=resultDto.getContent() %>
					</div>
				</div>
				<!-- 좋아요 개수 & 좋아요 버튼 / 댓글의 개수 출력 -->
				<div class="reply_box">
					<div class="good_wrapper">
						<a href="javascript:" class="good_button">
							<span class="good_icon"></span>
						</a>
						<em class="good_text">좋아요</em>
						<strong class="good_count"><%=resultDto.getGood_count() %></strong>
					</div>
					<div class="reply_count_wrapper">
						<span class="reply_icon">
							<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="currentColor" class="bi bi-chat-square-dots" viewBox="0 0 16 16">
		  						<path d="M14 1a1 1 0 0 1 1 1v8a1 1 0 0 1-1 1h-2.5a2 2 0 0 0-1.6.8L8 14.333 6.1 11.8a2 2 0 0 0-1.6-.8H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v8a2 2 0 0 0 2 2h2.5a1 1 0 0 1 .8.4l1.9 2.533a1 1 0 0 0 1.6 0l1.9-2.533a1 1 0 0 1 .8-.4H14a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/>
		  						<path d="M5 6a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0zm4 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0z"/>
							</svg>
						</span>
						<em class="reply_text">댓글</em>
						<strong class="reply_count"><%=totalRow %></strong>
					</div>
				</div>
			</div>		
			
			<!-- 위의 div 에 border-bottm 으로 선긋기 -->
			
			<!-- 댓글 리스트 출력 -->
			<div class="commet_box">
				<ul class="comment_list">
				<%for(VideosCommentDto tmp:commentList){ %>
					<%-- 삭제 o / 게시글에 댓글 : 들여쓰기 X --%>
					<%if(tmp.getDeleted().equals("yes")){ 
						if(tmp.getNum() == tmp.getComment_group()){
					%>
					<li class="comment_item" id="commet_item_<%=tmp.getNum() %>">삭제된 댓글입니다.</li>
						<%}else{%>
					<li class="comment_item" id="commet_item_<%=tmp.getNum() %>" style="padding-left:50px;">삭제된 댓글입니다.</li>
						<%}
						//continue : 아래의 코드를 수행하지 않고, for 문으로 실행순서를 다시 보내기
						continue;
					}%>
	
					<%-- li : class="comment_item", id="commet_item_댓글num" --%>
					<%if(tmp.getNum() == tmp.getComment_group()){ %>
					<%-- tmp.getNum() == tmp.getComment_group() : 게시글에 댓글 -> 들여쓰기 X --%>
					<li class="comment_item" id="commet_item_<%=tmp.getNum() %>">
					<%}else{ %>
					<%-- tmp.getNum() != tmp.getComment_group() : 게시글에 댓글 -> 들여쓰기 O --%>
					<li class="comment_item" id="commet_item_<%=tmp.getNum() %>" style="padding-left:50px;">
					<%} %>				
						<div class="comment_flex">
							<!-- <dt>프로필 이미지, 작성자 아아디, 수정, 삭제 </dt> -->
							<div class="comment_profile_wrapper">
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
							</div>
							<div class="comment_box">
								<!-- 작성자 id -->
								<span class="comment_writer_id"><strong><%=tmp.getWriter() %></strong></span>
								<%-- num != comment_group : 댓글에 단 댓글이다. --%>
							<%if(tmp.getNum() != tmp.getComment_group()){ %>
								<!-- 댓글의 댓글을 달 때, 어느 댓글인지 id 사용자 출력 -->
								<span class="comment_for_id">@<i><%=tmp.getTarget_id() %></i></span>
							<%} %>
								<div class="comment_main_text">
									<pre><%=tmp.getContent() %></pre>
								</div>
								<div class="commet_function">
									<!-- 댓글 작성 일자 -->
									<span><%=tmp.getRegdate() %></span>
									<!-- 답글 다는 링크 -->
									<a data-num="<%=tmp.getNum() %>" href="javascript:" class="reply_link">댓글</a>
								</div>
							</div>
						<%if(id != null && tmp.getWriter().equals(id)){ %>
							<div class="dropdown">
								<button class="btn" type="button" data-bs-toggle="dropdown">
									<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-three-dots-vertical" viewBox="0 0 16 16">
									  	<path d="M9.5 13a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0zm0-5a1.5 1.5 0 1 1-3 0 1.5 1.5 0 0 1 3 0z"/>
									</svg>
								</button>
								<ul class="dropdown-menu">
									<!-- 수정, 삭제 링크 : 댓글 num(pk) 데이터로 넘기기 -->
									<li><a data-num="<%=tmp.getNum() %>" href="javascript:" class="update_link dropdown-item">수정</a></li>
									<li><a data-num="<%=tmp.getNum() %>" href="javascript:" class="delete_link dropdown-item">삭제</a></li>
								</ul>
							</div>
						<%} %>
						</div>
						<%-- 댓글에 댓글을 다는 from --%>
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
						
						<%-- 댓글 수정 form --%>
						<%if(tmp.getWriter().equals(id)){ %>
						<form id="update_form_<%=tmp.getNum() %>" class="comment_form update_form" action="${pageContext.request.contextPath}/videos/private/comment_update.jsp" method="post">
							<input type="hidden" name="num" value="<%=tmp.getNum() %>" />
							<textarea name="content" cols="30" rows="10"><%=tmp.getContent() %></textarea>
							<button type="submit">수정</button>
						</form>
						<%} %>
					</li>
				<%} %>
				</ul>
				
				<div id="view_more" >
					<%-- ajax 로 전송할 것 --%>
					<a href="javascript:">[더보기]</a>
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
			
		</div>
		

		
		

		


	</div>
	
	
	<%-- grua_util.js 를 통해서 ajax 전송 --%>
	<script src="${pageContext.request.contextPath}/js/gura_util.js"></script>
	<script>
		//로그인 상태 - 댓글을 달려면 로그인을 꼭 해야한다!
		let isLogin = <%=isLogin %>;
		
		//페이지 로딩시에 출력되는 댓글들에 이벤트 리스너들 추가
		addReplyListener(".reply_link");
		addDeleteListener(".delete_link");
		addUpdateFormListener(".update_form");
		addUpdateListener(".update_link");
	
		//게시글 삭제 confirm 함수
		function deleteConfirm(){
			//삭제할지 물어봄
			let isDelete = confirm("삭제하시겠습니까?");
			//삭제 할 것 - ok = true
			if(isDelete){
				location.href = "${pageContext.request.contextPath}/videos/private/delete.jsp?num=<%=num %>";
			}
			//no : false -> 아무 일도 없음
		}
		
		//게시글에 댓글 달기 -> login 검사하기
		document.querySelector(".insert_form").addEventListener("submit", function(e){
			//로그인 하지 않았으면 -> 폼 전송 막음 -> 로그인 폼으로 이동한다.
			if(!isLogin){
				//폼 전송 막기
				e.preventDefault();
				//로그인 폼으로 이동
				const isMove = confirm("로그인이 필요합니다. 로그인 페이지로 이동하시겠습니까?");
				if(isMove){
					location.href = "${pageContext.request.contextPath}/users/login_form.jsp?url=${pageContext.request.contextPath}/videos/detail.jsp?num=<%=num%>";
				}
			}
		});
		
//댓글의 페이지네이션
		//댓글의 현재 페이지 번호를 관리할 변수를 만들고, 초기값 1 대입하기
		let currentPage = 1;
		
		//마지막 페이지는 totalPageCount 이다.
		let lastPage = <%=totalPageCount %>;
		
		if(<%=totalRow %> <= 10){
			document.querySelector("#view_more").style.display = "none";
		}
		
		document.querySelector("#view_more").addEventListener("click", function(){
			//현재 댓글 페이지를 1 증가시키고
			currentPage++;			
			
			//현재 페이지가 마지막 페이지보다 작거나 같을 때 -> 댓글 페이지 출력하기
			if(currentPage <= lastPage){				
				/*
					해당 페이지의 내용을 ajax 요청을 통해서 받아온다.
					"pageNum=xxx&num=xxx" 형식으로 GET 방식 파라미터를 전달한다.
				*/
				ajaxPromise("${pageContext.request.contextPath}/videos/ajax_comment_list.jsp", "post", "pageNum="+currentPage+"&num="+<%=num %>)
				.then(function(response){
					return response.text();
				})
				.then(function(data){
					//data 에는 html text 가 들어있다.
					document.querySelector(".comment_list").insertAdjacentHTML("beforeend", data);
					
					//새로 추가된 댓글 li 요소 안에 있는 a 요소를 찾아서 이벤트 리스너 등록하기
					addDeleteListener(".page-" + currentPage + " .delete_link");
					addReplyListener(".page-" + currentPage + " .reply_link");
					addUpdateFormListener(".page-" + currentPage + " .update_form");
					addUpdateListener(".page-" + currentPage + " .update_link");
				});
			}
			
			if(currentPage == lastPage){
				document.querySelector("#view_more").style.display = "none";
			}else{
				document.querySelector("#view_more").steyl.display = "block";
			}
		});
		
		

		
		//댓글에 댓글 달기 : 인자로 전달되는 선택자를 이용해서 이벤트 리스너를 등록하는 함수
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
							location.href = "${pageContext.request.contextPath}/users/login_form.jsp?url=${pageContext.request.contextPath}/videos/detail.jsp?num=<%=num%>";
						}
						return;
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
		
		//댓글 삭제 : 인자로 전달되는 선택자를 이용해서 이벤트 리스너를 등록하는 함수
		//sel = ".reply_link" : 처음 페이지에 출력할 때는 .page-N 클래스가 없다 -> 댓글 페이지
		//sel = ".page-N .reply_link" (N : currentPage) 형식의 내용이다.
		function addDeleteListener(sel){
			//댓글 삭제 링크의 참조값을 배열에 담아오기
			let deleteLinks = document.querySelectorAll(sel);
			//모든 댓글 삭제 링크에 이벤트 리스너 추가
			for(let i = 0; i < deleteLinks.length; i++){
				deleteLinks[i].addEventListener("click", function(){
					//클릭 이벤트가 일어난 버튼의 "data-num" 속성의 value 값을 읽어온다.
					//data-num : 댓글의 num(pk) 을 가지고 있다.
					const num = this.getAttribute("data-num");
					//사용자에게 댓글 삭제 확인 메시지
					const isDelete = confirm("댓글을 삭제하시겠습니까?");
					if(isDelete){
						//gura_util.js 에 있는 함수를 이용해서 ajax 요청
						ajaxPromise("${pageContext.request.contextPath}/videos/private/comment_delete.jsp", "post", "num="+num)
						.then(function(response){
							return response.json();
						})
						.then(function(data){
							//data : { isSuccess : true/false }
							//댓글 삭제가 성공
							if(data.isSuccess){
								//댓글이 있는 곳에 삭제된 댓글입니다를 출력해준다.
								document.querySelector("#commet_item_" + num).innerText = "삭제된 댓글입니다.";
							}
						});
					}
					
				});
			}
		}
		
		//댓글 수정 : 인자로 전달되는 선택자를 이용해서 이벤트 리스너를 등록하는 함수
		//sel = ".reply_link" : 처음 페이지에 출력할 때는 .page-N 클래스가 없다 -> 댓글 페이지
		//sel = ".page-N .reply_link" (N : currentPage) 형식의 내용이다.
		function addUpdateFormListener(sel){
			//댓글 수정 폼의 참조값을 배열에 담아오기
	 		let updateForms = document.querySelectorAll(sel);
			for(let i = 0; i < updateForms.length; i++){
				//폼에 submit 이벤트가 일어났을 때 호출되는 함수 등록
				updateForms[i].addEventListener("submit", function(e){
					//submit 이벤트가 일어난 form 의 참조값을 form 이라는 변수에 담기
					const form = this;
					
					//폼 제출 막기
					e.preventDefault();
					
					//이벤트가 일어난 form 을 ajax 전송하도록 한다.
					ajaxFormPromise(form)
					.then(function(response){
						return response.json();
					})
					.then(function(data){
						//data = { isSuccess:true/false }
						if(data.isSuccess){
							//수정 성공 : 내용 수정 
							//num : form 에 num 으로 들어있음
							//수정폼에 입력하나 value 값을 pre 요소에도 출력하기
							 
							//	document.querySelector() : html 문서 전체에서의 특정 요소의 참조값을 찾는 기능
								
							//	특정 문서객체의 참조값.querySelector() : 해당 문서 객체의 자손 요소 중에서 특정 요소의 참조값을 찾는 기능
							
							const num = form.querySelector("input[name=num]").value;
							const content = form.querySelector("textarea[name=content]").value;
							document.querySelector("#commet_item_"+num+" .comment_main_text pre").innerText = content;
							form.style.display="none";
						}else{
							//수정 실패
							alert("댓글 수정 실패");
						}
					});
				});
				
			}
		}
		
		//댓글 수정 form on/off : 인자로 전달되는 선택자를 이용해서 이벤트 리스너를 등록하는 함수
		//sel = ".reply_link" : 처음 페이지에 출력할 때는 .page-N 클래스가 없다 -> 댓글 페이지
		//sel = ".page-N .reply_link" (N : currentPage) 형식의 내용이다.
		function addUpdateListener(sel){
			//댓글 수정 링크의 참조값을 배열에 담아오기 
		   	let updateLinks = document.querySelectorAll(sel);
		   	for(let i = 0; i < updateLinks.length; i++){
		   		updateLinks[i].addEventListener("click", function(){
		   			//click 이벤트가 일어난 바로 그 요소의 data-num 속성의 value 값을 읽어온다. 
		   			const num = this.getAttribute("data-num");
		   			document.querySelector("#update_form_"+num).style.display="block";
		   		});
		   	}
		}
		
//좋아요 버튼 기능 추가
		//good 했는지 알아오기
		let isGood = <%=isGood %>;
		
		//좋아요 버튼 페이지 로딩시에 초기화
		if(isLogin && isGood){
			//사용자가 좋아요를 누름 and 로그인 함 -> on
			const goodBtn = document.querySelector(".good_button")
			//off 빼기
			goodBtn.classList.remove("btn_off");
			//on 넣기
			goodBtn.classList.add("btn_on");
		}else{
			//사용자가 좋아요를 안누름 or 로그인 안함 -> off
			const goodBtn = document.querySelector(".good_button")
			//on 빼기
			goodBtn.classList.remove("btn_on");
			//off 넣기
			goodBtn.classList.add("btn_off");
		}
		
		//좋아요 링크 누르면 -> ajax 로 좋아요 db 에 추가 후, 배경사진 변경(class 변경)
		document.querySelector(".good_button").addEventListener("click", function(){			
			//로그인 안된 상태 -> 로그인 하시겠습니까?
			if(!isLogin){
				//로그인 폼으로 이동
				const isMove = confirm("로그인이 필요합니다. 로그인 페이지로 이동하시겠습니까?");
				if(isMove){
					location.href = "${pageContext.request.contextPath}/users/login_form.jsp?url=${pageContext.request.contextPath}/videos/detail.jsp?num=<%=num%>";
				}else{
					//종료
					return;
				}
			}
			
			//로그인 ok
			//현재 a 링크
			const good_button = this;
			
			//ajax 로 db 에 변경사항 저장 후, icon 출력 변경(class on/off 변경)
			//num : 게시글 번호
			ajaxPromise("${pageContext.request.contextPath}/videos/private/ajax_good_update.jsp", "post", "num=<%=num%>")
			.then(function(response){
				return response.json();
			})
			.then(function(data){
				//data : { isGood : true/false, goodCount : n }
				//-> true:좋아요 on / false : 좋아요 off
				//-> goodCount : 좋아요 개수
				if(data.isGood){
					//좋아요 on
					isGood = true;
					//off 빼기
					good_button.classList.remove("btn_off");
					//on 넣기
					good_button.classList.add("btn_on");
				}else{
					//좋아요 off
					isGood = false;
					//on 빼기
					good_button.classList.remove("btn_on");
					//off 넣기
					good_button.classList.add("btn_off");
				}
				//data 에서  goodCount 읽어서 class="good_count" 에 숫자 변경
				document.querySelector(".good_count").innerText = data.goodCount;
			});
			
			
		});
		
		
	</script>
</body>
</html>