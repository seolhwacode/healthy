<%@page import="java.util.List"%>
<%@page import="oneday.booking.dao.BookingDao"%>
<%@page import="oneday.booking.dto.BookingDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
//한 페이지에 몇개씩 표시할 것인지
final int PAGE_ROW_COUNT=5;
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

//BookingDto 객체에 startRowNum 과 endRowNum 을 담는다.
BookingDto dto=new BookingDto();
dto.setStartRowNum(startRowNum);
dto.setEndRowNum(endRowNum);

//BookingDao 객체의 참조값 얻어와서 
BookingDao dao=BookingDao.getInstance();
//글목록 얻어오기 
List<BookingDto> list=dao.getList(dto);

//하단 시작 페이지 번호 
int startPageNum = 1 + ((pageNum-1)/PAGE_DISPLAY_COUNT)*PAGE_DISPLAY_COUNT;
//하단 끝 페이지 번호
int endPageNum=startPageNum+PAGE_DISPLAY_COUNT-1;

//전체 row 의 갯수 
int totalRow=dao.getCount();
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
</head>
<body>
<jsp:include page="/include/navbar.jsp"></jsp:include>
<div class="container">
	<h1>예약 목록</h1>
	<table>
		<thead>
			<tr>
				<th>글번호</th>
				<th>조회수</th>
				<th>작성자</th>
				<th>예약자이름</th>
				<th>클래스명</th>
				<th>클래스날짜</th>
			</tr>
		</thead>
		<tbody>
		<%for(BookingDto tmp:list){ %>
			<tr>
			
				<td><%=tmp.getNum() %></td>
				<td><%=tmp.getViewCount() %></td>
				<td><%=tmp.getWriter() %></td>
				<td><%=tmp.getName() %></td>
				<td><a href="detail.jsp?num=<%=tmp.getNum()%>"><%=tmp.getClassName()%></a></td>
				<td><%=tmp.getClassDate() %></td>
				
			</tr>
		<%} %>
		</tbody>
	</table>
	     <ul class="pagination justify-content-center">
         <%if(startPageNum != 1){ %>
            <li class="page-item">
               <a class="page-link" href="bookingList.jsp?pageNum=<%=startPageNum-1 %>">Prev</a>
            </li>
         <%}else{ %>
            <li class="page-item disabled">
               <a class="page-link" href="javascript:">Prev</a>
            </li>
         <%} %>
         <%for(int i=startPageNum; i<=endPageNum; i++) {%>
            <%if(i==pageNum){ %>
               <li class="page-item active">
                  <a class="page-link" href="bookingList.jsp?pageNum=<%=i %>"><%=i %></a>
               </li>
            <%}else{ %>
               <li class="page-item">
                  <a class="page-link" href="bookingList.jsp?pageNum=<%=i %>"><%=i %></a>
               </li>
            <%} %>
         <%} %>
         <%if(endPageNum < totalPageCount){ %>
            <li class="page-item">
               <a class="page-link" href="bookingList.jsp?pageNum=<%=endPageNum+1 %>">Next</a>
            </li>
         <%}else{ %>
            <li class="page-item disabled">
               <a class="page-link" href="javascript:">Next</a>
            </li>
         <%} %>
      </ul>
</div>
</body>
</html>