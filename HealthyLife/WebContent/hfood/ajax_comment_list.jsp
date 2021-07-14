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
               <li id="del_reply" >삭제된 댓글 입니다.</li>
            <% 
               // continue; 아래의 코드를 수행하지 않고 for 문으로 실행순서 다시 보내기 
               continue;
            }%>
         
            <%if(tmp.getNum() == tmp.getComment_group()){ %>
            <li id="reli<%=tmp.getNum()%>" class="page-<%=pageNum %>">
            <%}else{ %>
            <li id="reli<%=tmp.getNum()%>" class="page-<%=pageNum %> re_reply" >
            <%} %>
               <dl>
                  <dd>
                  <%if(tmp.getProfile() == null){ %>
                     <svg class="profile-image" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-person-circle" viewBox="0 0 16 16">
                          <path d="M11 6a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
                          <path fill-rule="evenodd" d="M0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8zm8-7a7 7 0 0 0-5.468 11.37C3.242 11.226 4.805 10 8 10s4.757 1.225 5.468 2.37A7 7 0 0 0 8 1z"/>
                     </svg>
                  <%}else{ %>
                     <img class="profile-image" src="${pageContext.request.contextPath}<%=tmp.getProfile()%>"/>
                  <%} %>
                     <span style="font-weight: bold;"><%=tmp.getWriter() %></span>
                  <%if(tmp.getNum() != tmp.getComment_group()){ %>
                     <span style="color:#2252e3;">@<i><%=tmp.getTarget_id() %></i></span>
                  <%} %>
                  		 <span id="pre<%=tmp.getNum()%>"><%=tmp.getContent() %></span>  
                     
                     
                  </dd>
                  <dd>
                     <span style="margin-left:30px; font-size:13.5px;"><%=tmp.getRegdate() %></span>
                     <a data-num="<%=tmp.getNum() %>" href="javascript:" style="font-size:13.5px;" class="reply_link">답글</a>
                  <%if(id != null && tmp.getWriter().equals(id)){ %>
                     <a data-num="<%=tmp.getNum() %>" class="update_link" style="font-size:13.5px;" href="javascript:">수정</a>
                     <a data-num="<%=tmp.getNum() %>" class="delete_link" style="font-size:13.5px;" href="javascript:">삭제</a>
                  <%} %>              
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
