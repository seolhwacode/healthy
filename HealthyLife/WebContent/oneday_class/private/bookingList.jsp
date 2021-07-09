<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="oneday.booking.dao.BookingDao"%>
<%@page import="oneday.booking.dto.BookingDto"%>
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

//BookingDto 객체에 startRowNum 과 endRowNum 을 담는다.
BookingDto dto=new BookingDto();
dto.setStartRowNum(startRowNum);
dto.setEndRowNum(endRowNum);

//ArrayList 객체의 참조값을 담을 지역변수를 미리 만든다.
List<BookingDto> list=null;
//전체 row 의 갯수를 담을 지역변수를 미리 만든다.
int totalRow=0;
//만일 검색 키워드가 넘어온다면 
if(!keyword.equals("")){
   //검색 조건이 무엇이냐에 따라 분기 하기
   if(condition.equals("className")){//클래스명 검색인 경우
      //검색 키워드를 BookingDto 에 담아서 전달한다.
      dto.setClassName(keyword);
      //클래스명 검색일때 호출하는 메소드를 이용해서 목록 얻어오기 
      list=BookingDao.getInstance().getListC(dto);
      //클래스명 검색일때 호출하는 메소드를 이용해서 row  의 갯수 얻어오기
      totalRow=BookingDao.getInstance().getCountC(dto);
   }else if(condition.equals("name")){ //이름 검색인 경우
      dto.setName(keyword);
      list=BookingDao.getInstance().getListN(dto);
      totalRow=BookingDao.getInstance().getCountN(dto);
   }else if(condition.equals("writer")){ //작성자 검색인 경우
      dto.setWriter(keyword);
      list=BookingDao.getInstance().getListW(dto);
      totalRow=BookingDao.getInstance().getCountW(dto);
   } // 다른 검색 조건을 추가 하고 싶다면 아래에 else if() 를 계속 추가 하면 된다.
}else{//검색 키워드가 넘어오지 않는다면
   //키워드가 없을때 호출하는 메소드를 이용해서 파일 목록을 얻어온다. 
   list=BookingDao.getInstance().getList(dto);
   //키워드가 없을때 호출하는 메소드를 이용해서 전제 row 의 갯수를 얻어온다.
   totalRow=BookingDao.getInstance().getCount();
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
<title>bookingList.jsp</title>
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
</style>
</head>
<body>
<jsp:include page="/include/navbar.jsp"></jsp:include>
<div class="container">
	<h1>예약 목록</h1>
	<table class="table">
		<thead>
			<tr id="thead">
				<th scope="col">글번호</th>
				<th scope="col">조회수</th>
				<th scope="col">작성자</th>
				<th scope="col">예약자이름</th>
				<th scope="col">클래스명</th>
				<th scope="col">클래스날짜</th>
			</tr>
		</thead>
		<tbody>
		<%for(BookingDto tmp:list){ %>
			<tr>
			
				<td scope="row"><%=tmp.getNum() %></td>
				<td scope="row"><%=tmp.getViewCount() %></td>
				<td scope="row"><%=tmp.getWriter() %></td>
				<td scope="row"><%=tmp.getName() %></td>
				<td scope="row"><a href="detail.jsp?num=<%=tmp.getNum()%>&keyword=<%=encodedK%>&condition=<%=condition%>"><%=tmp.getClassName()%></a></td>
				<td scope="row"><%=tmp.getClassDate() %></td>
				
			</tr>
		<%} %>
		</tbody>
	</table>
	     <ul class="pagination justify-content-center">
         <%if(startPageNum != 1){ %>
            <li class="page-item">
               <a class="page-link" href="bookingList.jsp?pageNum=<%=startPageNum-1 %>&keyword=<%=encodedK%>&condition=<%=condition%>">Prev</a>
            </li>
         <%}else{ %>
            <li class="page-item disabled">
               <a class="page-link" href="javascript:">Prev</a>
            </li>
         <%} %>
         <%for(int i=startPageNum; i<=endPageNum; i++) {%>
            <%if(i==pageNum){ %>
               <li class="page-item active">
                  <a class="page-link" href="bookingList.jsp?pageNum=<%=i %>&keyword=<%=encodedK%>&condition=<%=condition%>"><%=i %></a>
               </li>
            <%}else{ %>
               <li class="page-item">
                  <a class="page-link" href="bookingList.jsp?pageNum=<%=i %>&keyword=<%=encodedK%>&condition=<%=condition%>"><%=i %></a>
               </li>
            <%} %>
         <%} %>
         <%if(endPageNum < totalPageCount){ %>
            <li class="page-item">
               <a class="page-link" href="bookingList.jsp?pageNum=<%=endPageNum+1 %>&keyword=<%=encodedK%>&condition=<%=condition%>">Next</a>
            </li>
         <%}else{ %>
            <li class="page-item disabled">
               <a class="page-link" href="javascript:">Next</a>
            </li>
         <%} %>
      </ul>
      
      <div style="clear:both;"></div>
   
   	<form id="search" action="bookingList.jsp" method="get"> 
      <select name="condition" id="condition">
         <option value="className" <%=condition.equals("className") ? "selected" : ""%>>클래스명</option>
         <option value="name" <%=condition.equals("name") ? "selected" : ""%>>예약자</option>
         <option value="writer" <%=condition.equals("writer") ? "selected" : ""%>>작성자</option>
      </select>
      <input class= "border border-secondary" type="text" id="keyword" name="keyword" placeholder="검색어를 입력하세요" value="<%=keyword%>"/>
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