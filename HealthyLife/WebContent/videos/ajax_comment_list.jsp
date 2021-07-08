<%@page import="videos.board.dao.VideosCommentDao"%>
<%@page import="java.util.List"%>
<%@page import="videos.board.dto.VideosCommentDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//현재 로그인 중인 id
	String id = (String)session.getAttribute("id");
	
//댓글 리스트 가져오기 - 댓글 pagination 처리(더보기 누르면 댓글 추가)	
	//ajax 요청 파라미터로 넘어오는 댓글의 페이지 번호를 읽어낸다.
	int pageNum = Integer.parseInt(request.getParameter("pageNum"));
	//ajax 요청 파라미터로 넘어오는 게시글의 번호를 가져온다.
	int num = Integer.parseInt(request.getParameter("num"));
	
	/*
	[댓글 페이징 처리에 관련된 로직]
	*/
	//여러 페이지에 나눠서 출력하기 - 여기서는 한 페이지에 10개!
	//한 페이지에 몇개씩 표시할 것인지
	final int PAGE_ROW_COUNT=10;
	
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
%>

<%for(VideosCommentDto tmp:commentList){ %>
	<%if(tmp.getDeleted().equals("yes")){ %>
	<li class="comment_item page-<%=pageNum %>" id="commet_item_<%=tmp.getNum() %>">삭제된 댓글입니다.</li>
	<%
		//continue : 아래의 코드를 수행하지 않고, for 문으로 실행순서를 다시 보내기
		continue;
	}%>

	<%-- li : class="comment_item", id="commet_item_댓글num" --%>
	<%if(tmp.getNum() == tmp.getComment_group()){ %>
	<%-- tmp.getNum() == tmp.getComment_group() : 게시글에 댓글 -> 들여쓰기 X --%>
	<li class="comment_item page-<%=pageNum %>" id="commet_item_<%=tmp.getNum() %>">
	<%}else{ %>
	<%-- tmp.getNum() != tmp.getComment_group() : 게시글에 댓글 -> 들여쓰기 O --%>
	<li class="comment_item page-<%=pageNum %>" id="commet_item_<%=tmp.getNum() %>" style="padding-left:50px;">
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
			<input type="hidden" name="ref_group" value="<%=num%>"/>
			<!-- '댓글'의 작성자가 대상자가 된다. -->
			<input type="hidden" name="target_id" value="<%=tmp.getWriter()%>"/>
               		<!-- '댓글' 의 comment_group 을 따라간다. -->
               		<input type="hidden" name="comment_group" value="<%=tmp.getComment_group()%>"/>
               		<textarea name="content"></textarea>
               		<button type="submit">등록</button>
		</form>
	</li>
<%} %>


