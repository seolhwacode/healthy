<%@page import="videos.board.dto.VideosCommentDto"%>
<%@page import="videos.board.dao.VideosCommentDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//1. 댓글 form 의 parameter 읽어오기 - target_id(게시글 or 댓글 작성자 id), ref_group(게시글 num), content(댓글 내용)
	int ref_group = Integer.parseInt(request.getParameter("ref_group"));
	String target_id = request.getParameter("target_id");
	String content = request.getParameter("content");
	
	/*
		원글의 댓글은 commet_group 번호가 전송이 안되고
		댓글의 댓글은 commet_group 번호가 전송이 된다.
		따라서 null 여부를 조사하면 원글의 댓글인지, 댓글의 댓글인지 판단할 수 있다.
	*/
	String comment_group = request.getParameter("comment_group");
	
	//2. 댓글 작성자 - session 영역에서 id 읽어오기
	String writer = (String)session.getAttribute("id");
	
	//3. VideosCommentDao 의 getSequence() 메소드를 통해 insert 댓글의 시퀀스 번호 미리 얻어오기 
	//-> 원글의 댓글인 경우, 댓글의 시퀀스 번호 num 이 comment_group 과 같다. 그래서 미리 가져옴
	int seq = VideosCommentDao.getInstance().getSequence();
	
	//4. insert 를 위한 VideosCommentDto 생성 - num, writer, content, target_id, ref_group, comment_group 저장
	VideosCommentDto dto = new VideosCommentDto();
	dto.setNum(seq);
	dto.setWriter(writer);
	dto.setTarget_id(target_id);
	dto.setContent(content);
	dto.setRef_group(ref_group);
	
	//원글의 댓글은 commet_group 번호가 전송이 안된다.
	//원글의 댓글인 경우 -> 댓글의 글번호를 commet_group 번호로 사용한다.
	if(comment_group == null){
		//댓글의 글번호를 commet_group 번호로 사용한다.
		dto.setComment_group(seq);
	}else{
		//댓글의 댓글은 commet_group 번호가 전송이 된다.
		//전송된 commet_group 번호를 숫자로 바꾸어 dto 에 넣는다.
		dto.setComment_group(Integer.parseInt(comment_group));
	}
	
	//5. VideosCommentDao 의 insert() 메소드를 사용하여 db 에 저장
	boolean isSuccess = VideosCommentDao.getInstance().insert(dto);
	
	//6. 원래 페이지로 돌아가기
	String cpath = request.getContextPath();
	response.sendRedirect(cpath + "/videos/detail.jsp?num=" + ref_group);
%>
