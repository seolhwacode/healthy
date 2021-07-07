<%@page import="java.util.List"%>
<%@page import="test.homeW.dao.HomeWCommentDao"%>
<%@page import="test.homeW.dto.HomeWCommentDto"%>
<%@page import="test.homeW.dto.HomeWDto"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="test.homeW.dao.HomeWDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//해당 글 번호 읽어오기
	int num=Integer.parseInt(request.getParameter("num"));
	//조회수 올리기
	HomeWDao.getInstance().addViewCount(num);
	/*
    [ 검색 키워드에 관련된 처리 ]
    -검색 키워드가 파라미터로 넘어올수도 있고 안넘어 올수도 있다.      
	 */
	 String keyword=request.getParameter("keyword");
	 String condition=request.getParameter("condition");
	 //만일 키워드가 넘어오지 않는다면 
	 if(keyword==null){
	    //키워드와 검색 조건에 빈 문자열을 넣어준다. 
	    //클라이언트 웹브라우저에 출력할때 "null" 을 출력되지 않게 하기 위해서  
	    keyword="";
	    condition=""; 
	 }
	 //HomeWDto 객체를 생성해서 
	 HomeWDto dto=new HomeWDto();
	 //자세히 보여줄 글번호를 넣어준다. 
	 dto.setNum(num);
	 //만일 검색 키워드가 넘어온다면 
	 if(!keyword.equals("")){
	    //검색 조건이 무엇이냐에 따라 분기 하기
	    if(condition.equals("title_content")){//제목 + 내용 검색인 경우
	       //검색 키워드를 HomeWDto 에 담아서 전달한다.
	       dto.setTitle(keyword);
	       dto.setContent(keyword);
	       dto=HomeWDao.getInstance().getDataTC(dto);
	    }else if(condition.equals("title")){ //제목 검색인 경우
	       dto.setTitle(keyword);
	       dto=HomeWDao.getInstance().getDataT(dto);
	    }else if(condition.equals("writer")){ //작성자 검색인 경우
	       dto.setWriter(keyword);
	       dto=HomeWDao.getInstance().getDataW(dto);
	    } // 다른 검색 조건을 추가 하고 싶다면 아래에 else if() 를 계속 추가 하면 된다.
	 }else{//검색 키워드가 넘어오지 않는다면
	    dto=HomeWDao.getInstance().getData(dto);
	 }
	 //특수기호를 인코딩한 키워드를 미리 준비한다. 
	 String encodedK=URLEncoder.encode(keyword);
	 
	 //로그인된 아이디 (로그인을 하지 않았으면 null 이다)
	 String id=(String)session.getAttribute("id");
	 //로그인 여부
	 boolean isLogin=false;
	 if(id != null){
	    isLogin=true;
	 }
	 
  /*
     [ 댓글 페이징 처리에 관련된 로직 ]
  */
  //한 페이지에 몇개씩 표시할 것인지
  final int PAGE_ROW_COUNT=10;
  
  //detail.jsp 페이지에서는 항상 1페이지의 댓글 내용만 출력한다. 
  int pageNum=1;
  
  //보여줄 페이지의 시작 ROWNUM
  int startRowNum=1+(pageNum-1)*PAGE_ROW_COUNT;
  //보여줄 페이지의 끝 ROWNUM
  int endRowNum=pageNum*PAGE_ROW_COUNT;
  
  //원글의 글번호를 이용해서 해당글에 달린 댓글 목록을 얻어온다.
  HomeWCommentDto commentDto=new HomeWCommentDto();
  commentDto.setRef_group(num);
  //1페이지에 해당하는 startRowNum 과 endRowNum 을 dto 에 담아서  
  commentDto.setStartRowNum(startRowNum);
  commentDto.setEndRowNum(endRowNum);
  
  //1페이지에 해당하는 댓글 목록만 select 되도록 한다. 
  List<HomeWCommentDto> commentList=
		  HomeWCommentDao.getInstance().getList(commentDto);
  

	
	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/homeW/detail.jsp</title>
<jsp:include page="../include/resource.jsp"></jsp:include>
<style>
   .content{
      border: 1px solid gray;
   }
   
   /* 댓글 프로필 이미지를 작은 원형으로 만든다. */
   .profile-image{
      width: 50px;
      height: 50px;
      border: 1px solid #cecece;
      border-radius: 50%;
   }
   /* ul 요소의 기본 스타일 제거 */
   .comments ul{
      padding: 0;
      margin: 0;
      list-style-type: none;
   }
   .comments dt{
      margin-top: 5px;
   }
   .comments dd{
      margin-left: 50px;
   }
   .comment-form textarea, .comment-form button{
      float: left;
   }
   .comments li{
      clear: left;
   }
   .comments ul li{
      border-top: 1px solid #888;
   }
   .comment-form textarea{
      width: 84%;
      height: 100px;
   }
   .comment-form button{
      width: 14%;
      height: 100px;
   }
   /* 댓글에 댓글을 다는 폼과 수정폼은 일단 숨긴다. */
   .comments .comment-form{
      display: none;
   }
   /* .reply_icon 을 li 요소를 기준으로 배치 하기 */
   .comments li{
      position: relative;
   }
   .comments .reply-icon{
      position: absolute;
      top: 1em;
      left: 1em;
      color: red;
   }
   pre {
     display: block;
     padding: 9.5px;
     margin: 0 0 10px;
     font-size: 13px;
     line-height: 1.42857143;
     color: #333333;
     word-break: break-all;
     word-wrap: break-word;
     background-color: #f5f5f5;
     border: 1px solid #ccc;
     border-radius: 4px;
   }  
   .loader{
   		/*로딩 이미지를 가운데 정렬하기 위해*/
   		text-align: center;
   		/*일단 숨겨놓기*/
   		display:none;
   }
   
   .loader svg{
   		animation: rotateAni 1s ease-out infinite;
   }
   
   @keyframes rotateAni{
   		0%{
   			transform: rotate(0deg);
   		}
   		100%{
   			transform: rotate(360deg);
   		}
   }    


</style>
</head>
<body>
<div class="container">
	 <%if(dto.getPrevNum()!=0){ %>
      <a href="detail.jsp?num=<%=dto.getPrevNum() %>&keyword=<%=encodedK %>&condition=<%=condition%>">이전글</a>
	 <%} %>
	 <%if(dto.getNextNum()!=0){ %>
	 	<a href="detail.jsp?num=<%=dto.getNextNum() %>&keyword=<%=encodedK %>&condition=<%=condition%>">다음글</a>
	 <%} %>
	 <ul>
	 	<li><a href="list.jsp">목록보기</a></li> 
	 	<%if(dto.getWriter().equals(id)){ %>
	        <li><a href="private/updateform.jsp?num=<%=dto.getNum()%>">수정</a></li>
	        <li><a href="private/delete.jsp?num=<%=dto.getNum()%>">삭제</a></li>
      	<%} %>
	 </ul>
	 <% if(!keyword.equals("")){ %>
     	<p>   
          <strong><%=condition %></strong> 조건, 
          <strong><%=keyword %></strong> 검색어로 검색된 내용 자세히 보기 
     	</p>
	   <%} %>
	   <table class="table table-warning ">
	      <tr>
	         <th>글번호</th>
	         <td colspan="5"><%=dto.getNum() %></td>
	      </tr>
	      <tr>
	         <th>제목</th>
	         <td colspan="5"><%=dto.getTitle() %></td>
	      </tr>
	      <tr>
	         <th>작성자</th>
	         <td><%=dto.getWriter() %></td>
	         <th>조회수</th>
	         <td><%=dto.getViewCount() %></td>
	         <th>등록일</th>
	         <td><%=dto.getRegdate() %></td>
	      </tr>
	      <tr class="table">
	         <td colspan="6">
	            <div class="content"><%=dto.getContent() %></div>
	         </td>
	      </tr>
	   </table>
	   <p><strong>홈트 관련 상품 구매하기</strong></p>
	   <script language="JavaScript">
			function random_imglink(){
		    let myimages=new Array()
		
		      /* 각각의 이미지 경로 지정 */
		      myimages[1]="${pageContext.request.contextPath}/ht_images/hover_roller.png";
		      myimages[2]="${pageContext.request.contextPath}/ht_images/htmt.jpg";
		      myimages[3]="${pageContext.request.contextPath}/ht_images/massage_ball.jpg";
		      myimages[4]="${pageContext.request.contextPath}/ht_images/massage_stick.png";
		      myimages[5]="${pageContext.request.contextPath}/ht_images/yoga_ring.jpg";
		  
		      /* 각각의 이미지 링크 지정 */
		      let imagelinks=new Array()
		      imagelinks[1]="https://danoshop.net/product?product_no=380";
		      imagelinks[2]="https://danoshop.net/product?product_no=327";
		      imagelinks[3]="https://danoshop.net/product?product_no=451";
		      imagelinks[4]="https://danoshop.net/product?product_no=478";
		      imagelinks[5]="https://danoshop.net/product?product_no=453";
		
		   let array=Math.floor(Math.random()*myimages.length)
		   if (array==0)
		   array=1
		
		   document.write('<a href='+'"'+imagelinks[array]+'"'+' target=_blank><img src="'+myimages[array]+'" border=0></a>')
		   }
		   random_imglink()
		   random_imglink()
	  </script>
	  
	  <!-- 댓글 목록 가져오기 -->
	  <div class="comments">
	  	<ul>
	  		<%for(HomeWCommentDto tmp: commentList){ %>
	  			<li>
	  				<dl>
	  					<dt>
	  						<%if(tmp.getProfile()==null) {%>
	  							<svg class="profile-image" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
									<path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
									<path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
								</svg>
	  						<%}else{ %>
	  							<img class="profile-image" src="${pageContext.request.contextPath}<%=tmp.getProfile()%>"/>
	  						<%} %>
	  							<span><%=tmp.getWriter() %></span>
	  						
	  							@<i><%=tmp.getTarget_id() %></i>
	  							<%=tmp.getRegdate() %>
	  							<a href="">답글</a>
	  							<a href="">수정</a>
	  							<a href="">삭제</a>	
	  					</dt>
	  					<dd>
	  						<pre ><%=tmp.getContent() %></pre>
	  					</dd>
	  				</dl>
	  				<form action="private/comment_insert.jsp" 
	  					class="animate__animated comment-form re-insert-form" method="post">
	  					<input type="hidden" name="ref_group" value="<%=dto.getNum() %>" />
	  					<input type="hidden" name="target_id" value="<%=tmp.getTarget_id() %>" />
	  					<input type="hidden" name="comment_group" value="<%=tmp.getComment_group() %>" />
	  					<textarea name="content"></textarea>
	  					<button type="submit">확인</button>
	  				</form>
	  			</li>
	  		<%} %>
	  	</ul>
	  </div>
	  <!-- 원글의 댓글을 작성할 댓글 폼 -->
	  <form class="comment-form insert-form" 
	  	action="private/comment_insert.jsp" method="post">
	  		<!-- 원글의 글번호가 댓글의 ref_group 번호가 된다. -->
	  		<input type="hidden" name="ref_group" value="<%=num %>" />
	  		<!-- 원글의 작성자가 댓글의 대상자가 된다. -->
	  		<input type="hidden" name="target_id" value="<%=dto.getWriter() %>" />
	  		<textarea name="content" ></textarea>
	  		<button type="submit">등록</button>
	  </form>		
</div>
</body>
</html>