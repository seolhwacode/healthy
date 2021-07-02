<%@page import="test.users.dao.UsersDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	//get 방식으로 전달된 id 읽어온다.
	String inputId = request.getParameter("inputId");
	//DB 에서 가입된 아이디가 존재하는지 여부를 얻어낸다.
	boolean isExist = UsersDao.getInstance().isExist(inputId);
%>
{ "isExist" : <%=isExist %> }
