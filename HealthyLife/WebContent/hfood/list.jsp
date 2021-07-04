<%@page import="java.util.ArrayList"%>
<%@page import="hfood.board.dao.HfoodDao"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="hfood.board.dto.HfoodDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//한 페이지에 몇개씩 표시할 것인지
	final int PAGE_ROW_COUNT=10;
	//하단 페이지를 몇개씩 표시할 것인지
	final int PAGE_DISPLAY_COUNT=5;
	
	//보여줄 페이지의 번호를 일단 1이라고 초기값 지정
	int pageNum=1;
	//페이지 번호가 파라미터로 전달되는지 읽어와 본다.
	String strPageNum=request.getParameter("pageNum");
	//만일 페이지 번호가 파라미터로 넘어 온다면
	if(strPageNum != null){
	   //숫자로 바꿔서 보여줄 페이지 번호로 지정한다.
	   pageNum=Integer.parseInt(strPageNum);
	}
	
	//보여줄 페이지의 시작 ROWNUM
	int startRowNum=1+(pageNum-1)*PAGE_ROW_COUNT;
	//보여줄 페이지의 끝 ROWNUM
	int endRowNum=pageNum*PAGE_ROW_COUNT;
	
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
	
	//특수기호를 인코딩한 키워드를 미리 준비한다. 
	String encodedK=URLEncoder.encode(keyword);
	
    HfoodDto dto=new HfoodDto();
    dto.setStartRowNum(startRowNum);
    dto.setEndRowNum(endRowNum);

	   
	//ArrayList 객체의 참조값을 담을 지역변수를 미리 만든다.
	List<HfoodDto> list=null;
	//전체 row 의 갯수를 담을 지역변수를 미리 만든다.
	int totalRow=0;

	if(!keyword.equals("")){
	      //검색 조건이 무엇이냐에 따라 분기 하기
	      if(condition.equals("title_content")){//제목 + 내용 검색인 경우
	         //검색 키워드를 CafeDto 에 담아서 전달한다.
	         dto.setTitle(keyword);
	         dto.setContent(keyword);
	         //제목+내용 검색일때 호출하는 메소드를 이용해서 목록 얻어오기 
	         list=HfoodDao.getInstance().getListTC(dto);
	         //제목+내용 검색일때 호출하는 메소드를 이용해서 row  의 갯수 얻어오기
	         totalRow=HfoodDao.getInstance().getCountTC(dto);
	      }else if(condition.equals("title")){ //제목 검색인 경우
	         dto.setTitle(keyword);
	         list=HfoodDao.getInstance().getListT(dto);
	         totalRow=HfoodDao.getInstance().getCountT(dto);
	      }else if(condition.equals("writer")){ //작성자 검색인 경우
	         dto.setWriter(keyword);
	         list=HfoodDao.getInstance().getListW(dto);
	         totalRow=HfoodDao.getInstance().getCountW(dto);
	      } // 다른 검색 조건을 추가 하고 싶다면 아래에 else if() 를 계속 추가 하면 된다.
	   }else{//검색 키워드가 넘어오지 않는다면
	      //키워드가 없을때 호출하는 메소드를 이용해서 파일 목록을 얻어온다. 
	      list=HfoodDao.getInstance().getList(dto);
	      //키워드가 없을때 호출하는 메소드를 이용해서 전제 row 의 갯수를 얻어온다.
	      totalRow=HfoodDao.getInstance().getCount();
	   }
		//하단 시작 페이지 번호 
	   	int startPageNum = 1 + ((pageNum-1)/PAGE_DISPLAY_COUNT)*PAGE_DISPLAY_COUNT;
	   	//하단 끝 페이지 번호
	   	int endPageNum=startPageNum+PAGE_DISPLAY_COUNT-1;
	   

	   	//전체 페이지의 갯수
	   	int totalPageCount=(int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
	   	//끝 페이지 번호가 전체 페이지 갯수보다 크다면 잘못된 값이다.
	   	if(endPageNum > totalPageCount){
	      endPageNum=totalPageCount; //보정해 준다.
	   }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/h_food/list.jsp</title>
<jsp:include page="/include/resource.jsp"></jsp:include>
<style>
	#thead{
		background:white;
		color : #2252e3;
		font-size :20px;
	}

	.container {
		text-align: center;
	}
	
	
	
	#insert {
		text-align: right;
		margin-top: 10px;
	}
	
	h1 {
		margin-bottom:20px !important;
		text-align: center;
	}
	
	#pageNum{
		  display: table;
		  margin-left: auto;
		  margin-right: auto;
		  padding : 20px;
	}
	.page-ui a{
      text-decoration: none;
      color: #000;
      
   }
   
   .page-ui a:hover{
      text-decoration: underline;
   }
   
   .page-ui a.active{
      color: #2252e3;
      font-weight: bold;
   }
   .page-ui ul{
      list-style-type: none;
      padding: 0;
   }
   
   .page-ui ul > li{
      float: left;
      padding: 5px;
   }
</style>
</head>
<body>
<jsp:include page="/include/navbar.jsp"></jsp:include>
<div class="container">
	<div id="insert">
	<button class="btn btn-primary me-md-2" style="background:white;" type="button"><a href="private/insertform.jsp">Create New Text</a></button>
	</div>
	<h1>For healthy food</h1>
	<table class="table" >
		<thead>
			<tr id="thead">
				<th scope="col">num</th>
				<th scope="col">title</th>
				<th scope="col">writer</th>
				<th scope="col">registration date</th>
				<th scope="col">hits</th>
			</tr>
		</thead>
		<tbody>
      <%for(HfoodDto tmp:list){%>
         <tr id="tbody">
            <td scope="row"><%=tmp.getNum() %></td>
            <td scope="row">
               <a href="detail.jsp?num=<%=tmp.getNum()%>&keyword=<%=encodedK %>&condition=<%=condition%>"><%=tmp.getTitle() %></a>
            </td>
            <td scope="row"><%=tmp.getWriter() %></td>
            <td scope="row"><%=tmp.getRegdate() %></td>
            <td scope="row"><%=tmp.getViewCount() %></td>
         </tr>
      <%} %>
      </tbody>
	</table>
	<div  class="page-ui clearfix">
      <ul id="pageNum">
         <%if(startPageNum != 1){ %>
            <li>
               	<a href="list.jsp?pageNum=<%=startPageNum-1 %>&condition=<%=condition %>&keyword=<%=encodedK %>">
               	<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#2252e3" class="bi bi-chevron-double-left" viewBox="0 0 16 16">
				  <path fill-rule="evenodd" d="M8.354 1.646a.5.5 0 0 1 0 .708L2.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z"/>
				  <path fill-rule="evenodd" d="M12.354 1.646a.5.5 0 0 1 0 .708L6.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z"/>
				</svg>
               	</a>
            </li>   
         <% } %>
         
         <%for(int i=startPageNum; i<=endPageNum ; i++){ %>
            <li>
               <%if(pageNum == i){ %>
                  <a class="active" href="list.jsp?pageNum=<%=i %>&condition=<%=condition %>&keyword=<%=encodedK %>"><%=i %></a>
               <%}else{ %>
                  <a href="list.jsp?pageNum=<%=i %>&condition=<%=condition %>&keyword=<%=encodedK %>"><%=i %></a>
               <%} %>
            </li>   
         <%} %>
         <%if(endPageNum < totalPageCount){ %>
            <li>
               	<a href="list.jsp?pageNum=<%=endPageNum+1 %>&condition=<%=condition %>&keyword=<%=encodedK %>">
               	<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" fill="#2252e3" class="bi bi-chevron-double-right" viewBox="0 0 16 16">
				  <path fill-rule="evenodd" d="M3.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L9.293 8 3.646 2.354a.5.5 0 0 1 0-.708z"/>
				  <path fill-rule="evenodd" d="M7.646 1.646a.5.5 0 0 1 .708 0l6 6a.5.5 0 0 1 0 .708l-6 6a.5.5 0 0 1-.708-.708L13.293 8 7.646 2.354a.5.5 0 0 1 0-.708z"/>
				</svg>
				</a>
            </li>
         <%} %>
        
      </ul>
   </div>
	<div style="clear:both;"></div>
   
   	<form action="list.jsp" method="get"> 
      <label for="condition">검색조건</label>
      <select name="condition" id="condition">
         <option value="title_content" <%=condition.equals("title_content") ? "selected" : ""%>>제목+내용</option>
         <option value="title" <%=condition.equals("title") ? "selected" : ""%>>제목</option>
         <option value="writer" <%=condition.equals("writer") ? "selected" : ""%>>작성자</option>
      </select>
      <input type="text" id="keyword" name="keyword" placeholder="검색어..." value="<%=keyword%>"/>
      <button class="btn btn-primary me-md-2" type="submit">검색</button>
     
   	</form>   
   
   	<%if(!condition.equals("")){ %>
      <p>
         <strong><%=totalRow %></strong> 개의 글이 검색 되었습니다.
      </p>
   	<%} %>

</div>
</body>
</html>