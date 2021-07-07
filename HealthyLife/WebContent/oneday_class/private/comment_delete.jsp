<%@page import="oneday.booking.dao.BookingCommentDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int num = Integer.parseInt(request.getParameter("num"));

	boolean isSuccess=BookingCommentDao.getInstance().delete(num);
%>
{"isSuccess":<%=isSuccess%>}