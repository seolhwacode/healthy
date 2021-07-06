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
	 
	 //원글의 글번호를 이용해서 해당글에 달린 댓글 목록을 얻어온다
	 HomeWCommentDto commentDto=new HomeWCommentDto();
	 commentDto.setRef_group(num);
	 
	 List<HomeWCommentDto> commentList=HomeWCommentDao.getInstance().getList(commentDto);
	 
	 //로그인된 아이디 (로그인을 하지 않았으면 null 이다)
	 String id=(String)session.getAttribute("id");
	 //로그인 여부
	 boolean isLogin=false;
	 if(id != null){
	    isLogin=true;
	 }
	
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
   ul{
	   list-style:none;
	   padding-left:0px;
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
	  					<dt>프로필 이미지, 작성자 아이디 , 삭제 표시할 예정</dt>
	  					<dd>
	  						<pre><%=tmp.getContent() %></pre>
	  					</dd>
	  				</dl>
	  			</li>
	  		<%} %>
	  		
	  	</ul>
	  </div>
	  <!-- 원글의 댓글을 작성할 댓글 폼 -->
	  <form action="private/comment_insert.jsp" method="post">
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