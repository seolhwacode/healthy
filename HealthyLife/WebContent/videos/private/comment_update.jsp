<%@page import="videos.board.dao.VideosCommentDao"%>
<%@page import="videos.board.dto.VideosCommentDto"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	//ajax 전송되는 수정할 댓글의 번호화 내용을 읽어온다.
	int num = Integer.parseInt(request.getParameter("num"));
	String content = request.getParameter("content");
	
	//dto 에 담는다.
	VideosCommentDto dto = new VideosCommentDto();
	dto.setNum(num);
	dto.setContent(content);
	
	//DB 에 수정 반영한다.
	boolean isSuccess = VideosCommentDao.getInstance().update(dto);
	//json 응답
%>
{ "isSuccess":<%=isSuccess %> }