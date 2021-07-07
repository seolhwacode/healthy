<%@page import="videos.board.dao.VideosCommentDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	//삭제할 댓글 번호를 읽어온다.
	int num = Integer.parseInt(request.getParameter("num"));
	//DB 에서 'deleted' 의 값을 "yes" 로 변경한다.
	boolean isSuccess = VideosCommentDao.getInstance().delete(num);
	//json 응답
%>
{ "isSuccess" : "<%=isSuccess %>" }