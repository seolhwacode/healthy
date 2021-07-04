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
	   <table class="table table-warning">
	      <tr>
	         <th>글번호</th>
	         <td><%=dto.getNum() %></td>
	      </tr>
	      <tr>
	         <th>제목</th>
	         <td><%=dto.getTitle() %></td>
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
	         <td colspan="2">
	            <div class="content"><%=dto.getContent() %></div>
	         </td>
	      </tr>
	   </table>
	   <ul>
      <li><a href="list.jsp">목록보기</a></li>
       
   </ul>
</div>
</body>
</html>