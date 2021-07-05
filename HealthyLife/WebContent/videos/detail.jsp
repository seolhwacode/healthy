<%@page import="java.net.URLEncoder"%>
<%@page import="test.users.dao.UsersDao"%>
<%@page import="test.users.dto.UsersDto"%>
<%@page import="kang.videos.dao.VideosDao"%>
<%@page import="kang.videos.dto.VideosDto"%>
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
					<td><%=resultDto.getTitle() %></td>
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
	</script>
</body>
</html>