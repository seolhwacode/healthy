<%@page import="java.util.ArrayList"%>
<%@page import="hfood.board.dao.HfoodDao"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="java.util.List"%>
<%@page import="hfood.board.dto.HfoodDto"%>
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
	//만일 검색 키워드가 넘어온다면 
	
	   list=HfoodDao.getInstance().getList(dto);
	   //키워드가 없을때 호출하는 메소드를 이용해서 전제 row 의 갯수를 얻어온다.
	   totalRow=HfoodDao.getInstance().getCount();


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
				<th scope="col">writer</th>
				<th scope="col">title</th>
				<th scope="col">hits</th>
				<th scope="col">registration date</th>
			</tr>
		</thead>
		<tbody>
      <%for(HfoodDto tmp:list){%>
         <tr id="tbody">
            <td scope="row"><%=tmp.getNum() %></td>
            <td scope="row"><%=tmp.getWriter() %></td>
            <td scope="row">
              <%=tmp.getTitle() %>
            </td>
            <td scope="row"><%=tmp.getViewCount() %></td>
            <td scope="row"><%=tmp.getRegdate() %></td>
         </tr>
      <%} %>
      </tbody>
	</table>
</div>
</body>
</html>