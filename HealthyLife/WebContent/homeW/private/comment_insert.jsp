
<%@page import="test.homeW.dto.HomeWCommentDto"%>
<%@page import="test.homeW.dao.HomeWCommentDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//댓글 폼에 전송되는 파라미터를 추출한다
	int ref_group=Integer.parseInt(request.getParameter("ref_group"));
	String target_id=request.getParameter("target_id");
	String content=request.getParameter("content");
	
	//원글의 댓글인지 댓글의 댓글인지 판단할 수 있는 방법 -comment_group
	String comment_group=request.getParameter("comment_group");
	
	//댓글 작성자 session 영역에서 얻어오기
	String writer=(String)session.getAttribute("id");
	
	//시퀀스 값 미리 얻어내기
	int seq=HomeWCommentDao.getInstance().getSequence();
	//저장할 댓글정보 dto에 담기
	HomeWCommentDto dto=new HomeWCommentDto();
	dto.setNum(seq);
	dto.setWriter(writer);
	dto.setTarget_id(target_id);
	dto.setContent(content);
	dto.setRef_group(ref_group);
	
	//원글의 댓글인지 댓글의 댓글인지 구별하기
	 if(comment_group == null){
	 	//원글의 댓글일 때, 댓글의 글 번호를 comment_group 번호로 사용한다
		 dto.setComment_group(seq);
	 }else{
		 dto.setComment_group(Integer.parseInt(comment_group));
	 }
	 //DB에 저장하기
	 HomeWCommentDao.getInstance().insert(dto);
	 //성공했으면 다시 해당 글로 이동하기
	 String cpath=request.getContextPath();
	 response.sendRedirect(cpath+"/homeW/detail.jsp?num="+ref_group);
%> 
