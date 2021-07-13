<%@page import="hfood.board.dao.Hfood_comment_dao"%>
<%@page import="java.util.List"%>
<%@page import="hfood.board.dto.Hfood_comment_dto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%

	String id=(String)session.getAttribute("id");
	
	int pageNum=Integer.parseInt(request.getParameter("pageNum"));
	int num=Integer.parseInt(request.getParameter("num"));
	
	//댓글 페이징 처리 
	final int PAGE_ROW_COUNT=5;
	
	int startRowNum=1+(pageNum-1)*PAGE_ROW_COUNT;
	int endRowNum=pageNum*PAGE_ROW_COUNT;
	
	Hfood_comment_dto commentDto=new Hfood_comment_dto();
	commentDto.setRef_group(num);
	
	commentDto.setStartRowNum(startRowNum);
	commentDto.setEndRowNum(endRowNum);
	
	List<Hfood_comment_dto> commentList=
			Hfood_comment_dao.getInstance().getList(commentDto);
	
	//원글의 글번호를 이용해 댓글 전체의 갯수를 얻어냄
	int totalRow=Hfood_comment_dao.getInstance().getCount(num);
	//댓글 전체 페이지의 갯수
	int totalPageCount=(int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
%>
<%for(Hfood_comment_dto tmp: commentList){ %>
   <%if(tmp.getDeleted().equals("yes")){ %>
      <li>삭제된 댓글 입니다.</li>
   <% 
      // continue; 아래의 코드를 수행하지 않고 for 문으로 실행순서 다시 보내기 
      continue;
   }%>

   <%if(tmp.getNum() == tmp.getComment_group()){ %>
   <li id="reli<%=tmp.getNum()%>" class="page-<%=pageNum%>">
   <%}else{ %>
   <li id="reli<%=tmp.getNum()%>" class="page-<%=pageNum%>"  style="padding-left:50px;">
      <svg class="reply-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-return-right" viewBox="0 0 16 16">
               <path fill-rule="evenodd" d="M1.5 1.5A.5.5 0 0 0 1 2v4.8a2.5 2.5 0 0 0 2.5 2.5h9.793l-3.347 3.346a.5.5 0 0 0 .708.708l4.2-4.2a.5.5 0 0 0 0-.708l-4-4a.5.5 0 0 0-.708.708L13.293 8.3H3.5A1.5 1.5 0 0 1 2 6.8V2a.5.5 0 0 0-.5-.5z"/>
      </svg>
   <%} %>
      <dl>
         <dt>
         <%if(tmp.getProfile() == null){ %>
            <svg class="profile-image" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
                 <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
                 <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
            </svg>
         <%}else{ %>
            <img class="profile-image" src="${pageContext.request.contextPath}<%=tmp.getProfile()%>"/>
         <%} %>
            <span><%=tmp.getWriter() %></span>
         <%if(tmp.getNum() != tmp.getComment_group()){ %>
            @<i><%=tmp.getTarget_id() %></i>
         <%} %>
            <span><%=tmp.getRegdate() %></span>
            <a data-num="<%=tmp.getNum() %>" href="javascript:" class="reply-link">답글</a>
         <%if(id != null && tmp.getWriter().equals(id)){ %>
            <a data-num="<%=tmp.getNum() %>" class="update-link" href="javascript:">수정</a>
            <a data-num="<%=tmp.getNum() %>" class="delete-link" href="javascript:">삭제</a>
         <%} %>
         </dt>
         <dd>
            <pre id="pre<%=tmp.getNum()%>"><%=tmp.getContent() %></pre>                  
         </dd>
      </dl>   
      <form id="reForm<%=tmp.getNum() %>" class="comment-form re-insert-form" 
         action="private/comment_insert.jsp" method="post">
         <input type="hidden" name="ref_group"
            value="<%=num%>"/>
         <input type="hidden" name="target_id"
            value="<%=tmp.getWriter()%>"/>
         <input type="hidden" name="comment_group"
            value="<%=tmp.getComment_group()%>"/>
         <textarea name="content"></textarea>
         <button type="submit">등록</button>
      </form>   
      <%if(tmp.getWriter().equals(id)){ %>   
      <form id="updateForm<%=tmp.getNum() %>" class="comment-form update-form" 
         action="private/comment_update.jsp" method="post">
         <input type="hidden" name="num" value="<%=tmp.getNum() %>" />
         <textarea name="content"><%=tmp.getContent() %></textarea>
         <button type="submit">수정</button>
      </form>
      <%} %>                  
   </li>
<%} %>  