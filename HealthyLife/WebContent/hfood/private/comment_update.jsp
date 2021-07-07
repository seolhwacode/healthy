<%@page import="hfood.board.dao.Hfood_comment_dao"%>
<%@page import="hfood.board.dto.Hfood_comment_dto"%>

<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
   //ajax 전송되는 수정할 댓글의 번호와 내용을 읽어온다.
   int num=Integer.parseInt(request.getParameter("num"));
   String content=request.getParameter("content");
   
   //dto에 담는다.
   Hfood_comment_dto dto=new Hfood_comment_dto();
   dto.setNum(num);
   dto.setContent(content);
   
   //db에 수정 반영한다.
   boolean isSuccess=Hfood_comment_dao.getInstance().update(dto);
   
   //json 으로 응답한다.
%>
{"isSuccess":<%=isSuccess%>}