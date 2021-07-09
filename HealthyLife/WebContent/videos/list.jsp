<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="videos.board.dao.VideosDao"%>
<%@page import="videos.board.dto.VideosDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//여러 페이지에 나눠서 출력하기 - 여기서는 한 페이지에 10개!
	//한 페이지에 몇개씩 표시할 것인지
	final int PAGE_ROW_COUNT=3;
	//하단 페이지를 몇개씩 표시할 것인지
	final int PAGE_DISPLAY_COUNT=5;
	
	//보여줄 페이지의 번호를 일단 1이라고 초기값 지정
	int pageNum=1;
	
	//페이지 번호가 파라미터로 전달 되었는지 확인
	String strPageNum = request.getParameter("pageNum");
	//만일 페이지 번호가 파라미터로 넘어오면
	if(strPageNum != null){
		//숫자로 바꿔, 보여줄 페이지 번호로 지정
		pageNum = Integer.parseInt(strPageNum);
	}
	
	//보여줄 페이지의 시작 ROWNUM
	int startRowNum = 1 + (pageNum - 1) * PAGE_ROW_COUNT;
	//보여줄 페이지의 끝 ROWNUM
	int endRowNum = pageNum * PAGE_ROW_COUNT;
	
	/*
		[검색 키워드에 관련된 처리]
		- 검색 키워드가 파라미터로 넘어올 수도 있고 안넘어올 수도 있다.
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
	//type 이 있으면 -> display:block / 없으면 -> display:none, keyword:block
	boolean isTypeExist = false;
	
	//type 없을 때 or "not-selected" 일 때 => ""
	if("not-selected".equals(type) || type == null || "".equals(type)){
		type = "";
	}else{
		//type 이 있으면 -> display:block
		isTypeExist = true;
	}
	
	//특수기호를 인코딩한 키워드를 미리 준비한다.
	String encodeK = URLEncoder.encode(keyword);
	
	//1. 게시판 목록을 읽어오기 위한 startRowNum, endRowNum 지정
	VideosDto dto = new VideosDto(startRowNum, endRowNum);
	
	
	//ArrayList 객체의 참조값을 담을 지역변수를 미리 만든다.
	List<VideosDto> list=null;
	//전체 row 의 갯수를 담을 지역변수를 미리 만든다.
	int totalRow=0;
	
	//만일 검색 키워드가 넘어온다면
	if(!keyword.equals("")){
		//검색 조건이 무엇이냐에 따라 분기 하기
		if(condition.equals("title_content")){//제목 + 내용 검색인 경우
			//검색 키워드를 CafeDto 에 담아서 전달한다.
	      	dto.setTitle(keyword);
	      	dto.setContent(keyword);
	      	//제목+내용 검색일때 호출하는 메소드를 이용해서 목록 얻어오기 
	      	list = VideosDao.getInstance().getListTC(dto);
	      	//제목+내용 검색일때 호출하는 메소드를 이용해서 row  의 갯수 얻어오기
	      	totalRow = VideosDao.getInstance().getCountTC(dto);
		}else if(condition.equals("title")){ //제목 검색인 경우
			dto.setTitle(keyword);
	      	list = VideosDao.getInstance().getListT(dto);
	      	totalRow = VideosDao.getInstance().getCountT(dto);
		}else if(condition.equals("writer")){ //작성자 검색인 경우
			dto.setWriter(keyword);
	      	list = VideosDao.getInstance().getListW(dto);
	      	totalRow = VideosDao.getInstance().getCountW(dto);
		}
	}else if(!type.equals("")){//카테고리 검색인 경우 -> type 이 날아온다.
		dto.setType(type);
      	list = VideosDao.getInstance().getListTy(dto);
      	totalRow = VideosDao.getInstance().getCountTy(dto);
	}else{//검색 키워드가 넘어오지 않는다면
		//키워드가 없을때 호출하는 메소드를 이용해서 파일 목록을 얻어온다.
		list = VideosDao.getInstance().getList(dto);
		//키워드가 없을때 호출하는 메소드를 이용해서 전제 row 의 갯수를 얻어온다.
		totalRow = VideosDao.getInstance().getCount();
	}
	
	

	//하단 시작 페이지 번호
	int startPageNum = 1 + ((pageNum - 1) / PAGE_DISPLAY_COUNT) * PAGE_DISPLAY_COUNT;
	//하단 끝 페이지 번호
	int endPageNum = startPageNum + PAGE_DISPLAY_COUNT - 1;
	
	//전체 페이지의 개수 : (전체 row 의 개수 / 보여지는 리스트 개수) 올림
	int totalPageCount = (int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
	//끝 페이지 번호가 전체 페이지 개수보다 크다면, 잘못된 값이다.
	if(endPageNum > totalPageCount){
		//보정해준다.
		endPageNum = totalPageCount;
	}
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/videos/list.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
<style>
	/*가운데 정렬*/
	.container {
		text-align: center;
		margin-top: 40px;
		padding-bottom: 80px;
	}
	
	#insert{
		text-align: right;
		margin-top: 10px;
	}
	
	#table{
		margin-top: 10px;
	}
	thead{
		background:white;
		color : #2252e3;
		font-size :20px;
	}
	
	
	.pagination {
	  display: inline-block;
	  margin-top: 10px;
	  margin-bottm: 10px;
	}
	
	.pagination a {
	  color: black;
	  float: left;
	  padding: 5px 13px;
	  text-decoration: none;
	  margin: 5px;
	  vertical-align:middle;
	  font-size:16px;
	}
	
	.pagination>#pageNum {
		border : 2px solid #2252e3;
	  	border-radius: 50%;
	}
	
	.pagination a.active {
	  background-color: #2252e3;
	  color: white;
	  border-radius: 50%;
	  font-weight:bold;
	}
	
	.pagination #pageNum:hover:not(.active) {
	  background-color: lightgray;
	  border-radius:  50%;
	}
	
	/* 검색창 */
	.seartch_wrapper{
		margin-top: 15px;
	}
	input:focus { 
		outline: none !important;
    	border-color: #2252e3;
    	box-shadow: 0 0 3px #2252e3;
	}
	.seartch_wrapper{
		display: flex;
	    align-items: center;
	    padding: .375rem .75rem;
	    justify-content: center;
	}
	.input-group-text{
		border: none;
		background-color: white;
	}
	.search_submit{
	    background-color: #2252e3;
	    color: white;
	    border-radius: .25rem;
	    border: none;
        padding: 1px 12px;
	}
   	#type{
   		display: none;
   	}
</style>
</head>
<body>
	<jsp:include page="../include/navbar.jsp"></jsp:include>
	<div class="container">
		<h1>영상 자료실</h1>
		<div id="insert">
			<a class="btn btn-secondary" href="${pageContext.request.contextPath}/videos/private/insert_form.jsp">새 글 작성</a>
		</div>
		<table class="table">
			<thead>
				<tr>
					<th scope="col">번호</th>
					<th scope="col">제목</th>
					<th scope="col">작성자</th>
					<th scope="col">등록일</th>
					<th scope="col">조회수</th>
					<th scope="col">좋아요</th>
				</tr>
			</thead>
			<tbody>
			<%for(VideosDto tmp:list){ %>
				<tr>
					<td><%=tmp.getNum() %></td>
					<td>
						<a href="${pageContext.request.contextPath}/videos/detail.jsp?num=<%=tmp.getNum() %>&condition=<%=condition%>&keyword=<%=keyword%>&type=<%=type %>">
							<span>[<%=tmp.getType() %>]</span>
							<%=tmp.getTitle() %>
						</a>
					</td>
					<td><%=tmp.getWriter() %></td>
					<td><%=tmp.getRegdate() %></td>
					<td><%=tmp.getView_count() %></td>
					<td><%=tmp.getGood_count() %></td>
				</tr>
			<%} %>
			</tbody>
		</table>
		
		<!-- 페이지 표기 -->
		<div class="pagination">
		<%-- startPageNum 가 1이면 이전으로 가는  페이지는 없어야한다.--%>
		<% if(startPageNum != 1) {%>
			<a href="<%= request.getRequestURI() %>?pageNum=<%= startPageNum - 1%>&condition=<%=condition%>&keyword=<%=encodeK%>&type=<%=type %>">
				<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#2252e3" class="bi bi-chevron-double-left" viewBox="0 0 16 16">
				  <path fill-rule="evenodd" d="M8.354 1.646a.5.5 0 0 1 0 .708L2.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z"/>
				  <path fill-rule="evenodd" d="M12.354 1.646a.5.5 0 0 1 0 .708L6.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z"/>
				</svg>
			</a>
		<%} %>
		<%for(int i = startPageNum; i <= endPageNum; i++){ %>
			<a id="pageNum" href="<%= request.getRequestURI() %>?pageNum=<%= i%>&condition=<%=condition%>&keyword=<%=encodeK%>&type=<%=type %>" <%= pageNum==i ? "class=\"active\"" : "" %>><%= i %></a>
		<%} %>
		<%-- 아래 보여주는 페이지 번호의 끝이 전체 row 보다 작을 때만 next 출력 --%>
		<%if(endPageNum < totalPageCount){ %>
			<a href="<%= request.getRequestURI() %>?pageNum=<%= endPageNum + 1%>&condition=<%=condition%>&keyword=<%=encodeK%>&type=<%=type %>">
				<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#2252e3" class="bi bi-chevron-double-right" viewBox="0 0 16 16">
				  <path fill-rule="evenodd" d="M3.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L9.293 8 3.646 2.354a.5.5 0 0 1 0-.708z"/>
				  <path fill-rule="evenodd" d="M7.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L13.293 8 7.646 2.354a.5.5 0 0 1 0-.708z"/>
				</svg>
			</a>
		<%} %>
		</div>
		
		<!-- 검색 -->
		<div class="seartch_wrapper" style="clear:both;">
			<form class="input-group-text" action="list.jsp" method="get" id="search_form">
				<%-- selected 안붙이고 select 에 value 로 붙여서 사용 안됨 -> javascript 로는 바꾸면 가능! --%>
				<select name="condition" id="condition">
					<option value="title_content" <%="title_content".equals(condition)?"selected":"" %>>제목+내용</option>
					<option value="title" <%="title".equals(condition)?"selected":"" %> >제목</option>
					<option value="writer" <%="writer".equals(condition)?"selected":"" %> >작성자</option>
					<option value="type" <%="type".equals(condition)?"selected":"" %> >카테고리</option>
				</select>
				<div class="input-group-text">
					<input class="border border-secondary" type="text" name="keyword" id="keyword" placeholder="검색어..." value="<%=keyword %>" />
					<select name="type" id="type">
			        	<option value="not-selected">카테고리를 선택해주세요.</option>
			            <option value="yoga" <%="yoga".equals(type)?"selected":"" %>>요가</option>
			            <option value="stretching" <%="stretching".equals(type)?"selected":"" %>>스트레칭</option>
			            <option value="diet" <%="diet".equals(type)?"selected":"" %>>다이어트</option>
			            <option value="rehabili" <%="rehabili".equals(type)?"selected":"" %>>재활 및 교정</option>
			        </select>
					<button class="search_submit" type="submit">
						<svg xmlns="http://www.w3.org/2000/svg" width="16" height="24" fill="currentColor" class="bi bi-search" viewBox="0 0 16 16">
			  				<path d="M11.742 10.344a6.5 6.5 0 1 0-1.397 1.398h-.001c.03.04.062.078.098.115l3.85 3.85a1 1 0 0 0 1.415-1.414l-3.85-3.85a1.007 1.007 0 0 0-.115-.1zM12 6.5a5.5 5.5 0 1 1-11 0 5.5 5.5 0 0 1 11 0z"/>
						</svg>
					</button>
				</div>
			</form>
		</div>
	<%if(!"".equals(condition) && (!"".equals(keyword) || !("".equals(type) || "not-selected".equals(type)))){ %>
		<div>
			<strong><%=totalRow %></strong> 개의 글이 검색되었습니다.
		</div>
	<%} %>
			
		<script>
			document.querySelector("#condition").addEventListener("change", function(){
				//type 이 선택되었을 때
				if(this.value === "type"){
					// -> 아래의 type 의 select html 을 display inline 한다.
					document.querySelector("#type").style.display = "inline";
					
					//내용 또한 삭제
					document.querySelector("#keyword").value = "";
					// -> input#keyword 를 안보이게한다.
					document.querySelector("#keyword").style.display = "none";
				}else{
					//type 이외의 option 선택 
					//내용 또한 삭제
					document.querySelector("#type").value = "not-selected";
					//-> 아래의 type 의 select html 을 display none 한다.
					document.querySelector("#type").style.display = "none";
					
					//-> input#keyword 를 보이게한다.
					document.querySelector("#keyword").style.display = "inline";
				}
				
			});
			
			//type 이 있으면 -> display:block / 없으면 -> display:none, keyword:block
			if(<%=isTypeExist %>){
				//type 검색 
				//keyword -> display:"none"
				document.querySelector("#keyword").style.display = "none";
				//type -> display:"inline"
				document.querySelector("#type").style.display = "inline";
			}else{
				//type 검색 X
				//keyword -> display:"inline"
				document.querySelector("#keyword").style.display = "inline";
				//type -> display:"none"
				document.querySelector("#type").style.display = "none";
			}
		</script>
	</div>
</body>
</html>