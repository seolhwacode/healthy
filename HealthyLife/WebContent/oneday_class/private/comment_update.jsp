<%@page import="oneday.booking.dao.BookingCommentDao"%>
<%@page import="oneday.booking.dto.BookingCommentDto"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//ajax 전송되는 수정할 댓글의 번호와 내용을 읽어온다.
	int num=Integer.parseInt(request.getParameter("num"));
	String content = request.getParameter("content");
	
	//dto에 담는다.
	BookingCommentDto dto = new BookingCommentDto();
	dto.setNum(num);
	dto.setContent(content);
	
	boolean isSuccess = BookingCommentDao.getInstance().update(dto);
%>
{"isSuccess":<%=isSuccess %>}