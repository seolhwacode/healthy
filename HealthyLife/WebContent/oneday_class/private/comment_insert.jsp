<%@page import="oneday.booking.dto.BookingCommentDto"%>
<%@page import="oneday.booking.dao.BookingCommentDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//전송된 파라미터 읽어오기
	int ref_group = Integer.parseInt(request.getParameter("ref_group"));
	String target_id = request.getParameter("target_id");
	String content = request.getParameter("content");
	/*
		원글의 댓글은 comment_group 번호가 전송이 안되고
		댓글의 댓글은 comment_group 번호가 전송이 된다.
		따라서 null 여부를 조사하면 원글의 댓글인지 댓글의 댓글인지 알 수 있다.
	*/
	String comment_group = request.getParameter("comment_group");
	
	//댓글 작성자는 session 영역에서 얻어내기
	String writer = (String)session.getAttribute("id");
	
	//댓글의 시퀀스 번호 미리 얻어내기
	int seq = BookingCommentDao.getInstance().getSequence();
	
	//저장할 댓글의 정보를 dto에 담기
	BookingCommentDto dto = new BookingCommentDto();
	dto.setNum(seq);
	dto.setWriter(writer);
	dto.setTarget_id(target_id);
	dto.setContent(content);
	dto.setRef_group(ref_group);
	//원글의 댓글인 경우
	if(comment_group == null){
		//댓글의 글번호를 comment_group 번호로 사용한다.
		dto.setComment_group(seq);
	}else{
		//전송된 comment_group번호를 숫자로 바꿔서 dto에 넣어준다.
		dto.setComment_group(Integer.parseInt(comment_group));
	}
	
	//댓글 정보를 DB에 저장하기
	BookingCommentDao.getInstance().insert(dto);
	//응답하기
	String cPath = request.getContextPath();
	response.sendRedirect(cPath+"/oneday_class/private/detail.jsp?num="+ref_group);
%>
