<%@page import="videos.board.dao.VideosDao"%>
<%@page import="users.good.dao.UsersGoodDao"%>
<%@page import="users.good.dto.UsersGoodDto"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8" trimDirectiveWhitespaces="true"%>
<%
	//id : 사용자 id, num : 게시글 번호
	String id = (String)session.getAttribute("id");
	int num = Integer.parseInt(request.getParameter("num"));
	
	//db 에 update
	//update 하기 위해 전달하는 UsersGoodDto 생성
	UsersGoodDto dto = new UsersGoodDto(id, num);
	
	//table 에 존재 하는가?
	boolean isGood = UsersGoodDao.getInstance().isExist(dto);
	
	//분기
	if(isGood){
		//현재 상태가 좋아요 상태 -> 좋아요 삭제(delete)
		UsersGoodDao.getInstance().delete(dto);
		//video_board 테이블 update -> 좋아요 개수 감소
		VideosDao.getInstance().subtractGoodCount(num);
		//현재 상태가 좋아요 상태 -> false 로 변경
		isGood = false;
	}else{
		//현재 상태가 좋아요 X 상태 -> 좋아요 추가(add)
		UsersGoodDao.getInstance().insert(dto);
		//video_board 테이블 update -> 좋아요 수 증가
		VideosDao.getInstance().addGoodCount(num);
		//현재 상태가 좋아요 X 상태 -> true 로 변경
		isGood = true;
	}
	
	//게시글의 좋아요 개수 가져오기
	int goodCount = VideosDao.getInstance().getGoodCount(num);

%>
{ "isGood":<%=isGood %>, "goodCount":<%=goodCount %> }