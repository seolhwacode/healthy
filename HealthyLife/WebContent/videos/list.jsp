<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="videos.board.dao.VideosDao"%>
<%@page import="videos.board.dto.VideosDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//여러 페이지에 나눠서 출력하기 - 여기서는 한 페이지에 10개!
	//한 페이지에 몇개씩 표시할 것인지
	final int PAGE_ROW_COUNT=5;
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
	//type 없을 때 or "not-selected" 일 때 => ""
	if("not-selected".equals(type) || type == null){
		type = "";
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
	.page-ui a{
      text-decoration: none;
      color: #000;
   }
   
   .page-ui a:hover{
      text-decoration: underline;
   }
   
   .page-ui a.active{
      color: red;
      font-weight: bold;
      text-decoration: underline;
   }
   .page-ui ul{
      list-style-type: none;
      padding: 0;
   }
   
   .page-ui ul > li{
      float: left;
      padding: 5px;
   }
   
   	#type{
   		display: none;
   	}
</style>
</head>
<body>
	<div class="container">
		<a href="${pageContext.request.contextPath}/videos/private/insert_form.jsp">새 글 작성</a>
		<h1>글 목록입니다.</h1>
		<table>
			<thead>
				<tr>
					<th>글번호</th>
					<th>제목</th>
					<th>작성자</th>
					<th>등록일</th>
					<th>조회수</th>
					<th>좋아요</th>
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
		<div class="page-ui clearfix">
			<ul>
				<%-- startPageNum 가 1이면 이전으로 가는  페이지는 없어야한다.--%>
				<% if(startPageNum != 1) {%>
					<li>
						<a href="<%= request.getRequestURI() %>?pageNum=<%= startPageNum - 1%>&condition=<%=condition%>&keyword=<%=encodeK%>&type=<%=type %>">Prev</a>
					</li>
				<%} %>
				<%for(int i = startPageNum; i <= endPageNum; i++){ %>
					<li>
						<a href="<%= request.getRequestURI() %>?pageNum=<%= i%>&condition=<%=condition%>&keyword=<%=encodeK%>&type=<%=type %>" <%= pageNum==i ? "class=\"active\"" : "" %>><%= i %></a>
					</li>
				<%} %>
				<%-- 아래 보여주는 페이지 번호의 끝이 전체 row 보다 작을 때만 next 출력 --%>
				<%if(endPageNum < totalPageCount){ %>
					<li>
						<a href="<%= request.getRequestURI() %>?pageNum=<%= endPageNum + 1%>&condition=<%=condition%>&keyword=<%=encodeK%>&type=<%=type %>"><span >Next</span></a>
					</li>
				<%} %>
			</ul>
		</div>
		
		<!-- 검색 -->
		<div style="clear: both">
			<form action="list.jsp" method="get">
				<label for="condition">검색 조건</label>
				<%-- selected 안붙이고 select 에 value 로 붙여서 사용 안됨 -> javascript 로는 바꾸면 가능! --%>
				<select name="condition" id="condition">
					<option value="title_content" <%="title_content".equals(condition)?"selected":"" %>>제목+내용</option>
					<option value="title" <%="title".equals(condition)?"selected":"" %> >제목</option>
					<option value="writer" <%="writer".equals(condition)?"selected":"" %> >작성자</option>
					<option value="type" <%="type".equals(condition)?"selected":"" %> >카테고리</option>
				</select>
				<input type="text" name="keyword" id="keyword" placeholder="검색어..." value="<%=keyword %>" />
				<select name="type" id="type">
		        	<option value="not-selected">카테고리를 선택해주세요.</option>
		            <option value="yoga">요가</option>
		            <option value="stretching">스트레칭</option>
		            <option value="diet">다이어트</option>
		            <option value="rehabili">재활 및 교정</option>
		        </select>
				<button type="submit">검색</button>
			</form>
			
		<%if(!"".equals(condition)){ %>
			<p>
				<strong><%=totalRow %></strong> 개의 글이 검색되었습니다.
			</p>
		<%} %>
		</div>
			
		<script>
			document.querySelector("#condition").addEventListener("change", function(){
				//type 이 선택되었을 때
				if(this.value === "type"){
					// -> 아래의 type 의 select html 을 display inline 한다.
					document.querySelector("#type").style.display = "inline";
					// -> input#keyword 를 안보이게한다.
					document.querySelector("#keyword").style.display = "none";
				}else{
					//type 이외의 option 선택 
					//-> 아래의 type 의 select html 을 display none 한다.
					document.querySelector("#type").style.display = "none";
					//-> input#keyword 를 보이게한다.
					document.querySelector("#keyword").style.display = "inline";
				}
				
			});
		</script>
	</div>
</body>
</html>