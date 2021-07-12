<%@page import="java.util.List"%>
<%@page import="hfood.board.dao.Hfood_comment_dao"%>
<%@page import="hfood.board.dto.Hfood_comment_dto"%>
<%@page import="hfood.board.dao.HfoodDao"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="hfood.board.dto.HfoodDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int num=Integer.parseInt(request.getParameter("num"));
	
	HfoodDao.getInstance().addViewCount(num);

	String keyword=request.getParameter("keyword");
	String condition=request.getParameter("condition");
	//만일 키워드가 넘어오지 않는다면 
	if(keyword==null){
	   //키워드와 검색 조건에 빈 문자열을 넣어준다. 
	   //클라이언트 웹브라우저에 출력할때 "null" 을 출력되지 않게 하기 위해서  
	   keyword="";
	   condition=""; 
	}
	
	HfoodDto dto=new HfoodDto();
	dto.setNum(num);
	
	HfoodDto resultDto =null;
	
	 if(!keyword.equals("")){
	      //검색 조건이 무엇이냐에 따라 분기 하기
	      if(condition.equals("title_content")){//제목 + 내용 검색인 경우
	         //검색 키워드를 CafeDto 에 담아서 전달한다.
	         dto.setTitle(keyword);
	         dto.setContent(keyword);
	         dto=HfoodDao.getInstance().getDataTC(dto);
	      }else if(condition.equals("title")){ //제목 검색인 경우
	         dto.setTitle(keyword);
	         dto=HfoodDao.getInstance().getDataT(dto);
	      }else if(condition.equals("writer")){ //작성자 검색인 경우
	         dto.setWriter(keyword);
	         dto=HfoodDao.getInstance().getDataW(dto);
	      } // 다른 검색 조건을 추가 하고 싶다면 아래에 else if() 를 계속 추가 하면 된다.
	   }else{//검색 키워드가 넘어오지 않는다면
	      dto=HfoodDao.getInstance().getData(dto);
	   }
	   //특수기호를 인코딩한 키워드를 미리 준비한다. 
	   String encodedK=URLEncoder.encode(keyword);
	   
	 //로그인된 아이디 (로그인을 하지 않았으면 null 이다)
	   String id=(String)session.getAttribute("id");
	   	
	 //로그인 여부
	   	boolean isLogin=false;
	   	if(id != null){
	      	isLogin=true;
	   	}
	   	
	  //한 페이지에 몇개씩 표시할 것인지
	    final int PAGE_ROW_COUNT=10;
	    
	    //detail.jsp 페이지에서는 항상 1페이지의 댓글 내용만 출력한다. 
	    int pageNum=1;
	    
	    //보여줄 페이지의 시작 ROWNUM
	    int startRowNum=1+(pageNum-1)*PAGE_ROW_COUNT;
	    //보여줄 페이지의 끝 ROWNUM
	    int endRowNum=pageNum*PAGE_ROW_COUNT;
	    
	    //원글의 글번호를 이용해서 해당글에 달린 댓글 목록을 얻어온다.
	    Hfood_comment_dto commentDto=new Hfood_comment_dto();
	    commentDto.setRef_group(num);
	    //1페이지에 해당하는 startRowNum 과 endRowNum 을 dto 에 담아서  
	    commentDto.setStartRowNum(startRowNum);
	    commentDto.setEndRowNum(endRowNum);
	    
	    //1페이지에 해당하는 댓글 목록만 select 되도록 한다. 
	    List<Hfood_comment_dto> commentList=
	    		Hfood_comment_dao.getInstance().getList(commentDto);
	    
	    //원글의 글번호를 이용해서 댓글 전체의 갯수를 얻어낸다.
	    int totalRow=Hfood_comment_dao.getInstance().getCount(num);
	    //댓글 전체 페이지의 갯수
	    int totalPageCount=(int)Math.ceil(totalRow/(double)PAGE_ROW_COUNT);
	    
	    //글정보를 응답한다.
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	.container{
		width:800px !important;
	}
	#content {
		 margin-top:20px;
	}
	
	#private {
		margin: 5px;
		padding: 0px;
		display: flex;
		justify-content: flex-end;
	}
	
	#private> li{
		margin-left:15px;
	}
	
	ul {
    	list-style:none;

	}
	

   
   /* 댓글 프로필 이미지를 작은 원형으로 만든다. */
   .profile-image{
      width: 35px;
      height: 35px;
      border: 1px solid #cecece;
      border-radius: 50%;
   }
   /* ul 요소의 기본 스타일 제거 */
   .comments ul{
      padding: 0;
      margin: 0;
      list-style-type: none;
   }
   .comments dt{
      margin-top: 5px;
   }
   .comments dd{
      margin: 0px 25px 0px;
   }
   .comment-form textarea, .comment-form button{
      float: left;
      margin-bottom : 20px;
   }
   .comments li{
      clear: left;
   }
   
   .comment-form textarea{
      width: 84%;
      height: 100px;
   }
   .comment-form button{
      width: 14%;
      height: 100px;
   }
   /* 댓글에 댓글을 다는 폼과 수정폼은 일단 숨긴다. */
   .comments .comment-form {
      display: none;
   }
   
   .re-insert-form{
           display: none;
   }
   
   /* 댓글 더보러가기 CSS */
   
  
   #view_more {
   	    border: 2px solid #bfbebe;
    	background-color: #e8e8e8;
   	 	margin: 0px auto 10px;
    	width: 75%;
   		text-align: center;   
 	}
 
 	
   /* .reply_icon 을 li 요소를 기준으로 배치 하기 */
   .comments li{
      position: relative;
   }
   .comments .reply-icon {
      position: absolute;
      top: 1em;
      left: 1em;
      color: red;
   }
   
   pre {
     padding: 9.5px;
     margin: 0 0 10px;
     font-size: 13px;
     line-height: 1.42857143;
     color: #333333;
     word-break: break-all;
     word-wrap: break-word;
     background-color: #f5f5f5;
     border: 1px solid #ccc;
     border-radius: 4px;
   } 
   
   #reply_info { 
   	font-size: 13px;
    margin-left: 65px;
   }  
   
   .loader{
      /* 로딩 이미지를 가운데 정렬하기 위해 */
      text-align: center;
      /* 일단 숨겨 놓기 */
      display: none;
   }   
   
   .loader svg{
      animation: rotateAni 1s ease-out infinite;
   }
  
   .content_loading {
   		display: table;
   		margin: auto;	
   }
   
    .content_loading>#cl {
   		margin: 20px;
   }
   @keyframes rotateAni{
      0%{
         transform: rotate(0deg);
      }
      100%{
         transform: rotate(360deg);
      }
   }
</style>

<jsp:include page="/include/resource.jsp"></jsp:include>
</head>
<body>
<jsp:include page="/include/navbar.jsp"></jsp:include>
<div class="container">
	
	  <div class="row">
	    <div class="col-sm"><a href="list.jsp">건강레시피</a></div>
	  </div>
	  <div class="row">
	    <div class="col-sm" style="font-size:20px; font-weight:bold;"><%=dto.getTitle() %></div>
	  </div>	
	  <div class="row">
	    <div class="col-sm"><%=dto.getWriter() %></div>
	  </div>
	  <div class="row">
	    <div class="col-sm" id="content"><%=dto.getContent() %></div>
	  </div>
	  <div class="row">
	    <div class="col-sm-3" style="font-size:13px; padding-right:0px; width:160px;"><%=dto.getRegdate() %></div>
	    <div class="col-sm-2" style="font-size:13px; padding-left:0px; ">조회수 <%=dto.getViewCount() %></div>
	  </div>
		<ul id="private">
	      <%if(dto.getWriter().equals(id)){ %>
	         <li><a href="private/updateform.jsp?num=<%=dto.getNum()%>">수정</a></li>
	         <li><a href="private/delete.jsp?num=<%=dto.getNum()%>">삭제</a></li>
	      <%} %>
	   	</ul>



		
	   	<!-- 댓글  -->
      
		<div class="comments">
      	<ul>
         <%for(Hfood_comment_dto tmp: commentList){ %>
            <%if(tmp.getDeleted().equals("yes")){ %>
               <li>삭제된 댓글 입니다.</li>
            <% 
               // continue; 아래의 코드를 수행하지 않고 for 문으로 실행순서 다시 보내기 
               continue;
            }%>
         
            <%if(tmp.getNum() == tmp.getComment_group()){ %>
            <li id="reli<%=tmp.getNum()%>">
            <%}else{ %>
            <li id="reli<%=tmp.getNum()%>" style="padding-left:50px;">
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
                     value="<%=dto.getNum()%>"/>
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
      </ul>
      
      	<div id="view_more" >
			<%-- ajax 로 전송할 것 --%>
			<a href="javascript:" >댓글 더 보러 가기(ง ᵕᴗᵕ)ว</a>
		</div>
   
   </div>
    <div class="loader">
      <svg xmlns="http://www.w3.org/2000/svg" width="100" height="100" fill="currentColor" class="bi bi-arrow-clockwise" viewBox="0 0 16 16">
           <path fill-rule="evenodd" d="M8 3a5 5 0 1 0 4.546 2.914.5.5 0 0 1 .908-.417A6 6 0 1 1 8 2v1z"/>
           <path d="M8 4.466V.534a.25.25 0 0 1 .41-.192l2.36 1.966c.12.1.12.284 0 .384L8.41 4.658A.25.25 0 0 1 8 4.466z"/>
      </svg>
   </div>
   
      <!-- 원글에 댓글을 작성할 폼 -->
   <form class="comment-form insert-form" action="private/comment_insert.jsp" method="post">
      <!-- 원글의 글번호가 댓글의 ref_group 번호가 된다. -->
      <input type="hidden" name="ref_group" value="<%=num%>"/>
      <!-- 원글의 작성자가 댓글의 대상자가 된다. -->
      <input type="hidden" name="target_id" value="<%=dto.getWriter()%>"/>
      
      <textarea name="content"><%if(!isLogin){%>댓글 작성을 위해 로그인이 필요 합니다.<%}%></textarea>
      <button class="btn btn-primary" type="submit">등록</button>
   </form>
   
   <!-- 이전글 다음글 로딩 -->
   <div class="content_loading">
	   <%if(dto.getPrevNum()!=0){ %>
      	<a id="cl" href="detail.jsp?num=<%=dto.getPrevNum() %>&keyword=<%=encodedK %>&condition=<%=condition%>">
		    <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="#2252e3" class="bi bi-arrow-left-circle" viewBox="0 0 16 16">
	 		 	<path fill-rule="evenodd" d="M1 8a7 7 0 1 0 14 0A7 7 0 0 0 1 8zm15 0A8 8 0 1 1 0 8a8 8 0 0 1 16 0zm-4.5-.5a.5.5 0 0 1 0 1H5.707l2.147 2.146a.5.5 0 0 1-.708.708l-3-3a.5.5 0 0 1 0-.708l3-3a.5.5 0 1 1 .708.708L5.707 7.5H11.5z"/>
			</svg>
		</a>
	   <%} %>
	   <%if(dto.getNextNum()!=0){ %>
	      <a id="cl" href="detail.jsp?num=<%=dto.getNextNum() %>&keyword=<%=encodedK %>&condition=<%=condition%>">
	      	<svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="#2252e3" class="bi bi-arrow-right-circle" viewBox="0 0 16 16">
	 		 	<path fill-rule="evenodd" d="M1 8a7 7 0 1 0 14 0A7 7 0 0 0 1 8zm15 0A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM4.5 7.5a.5.5 0 0 0 0 1h5.793l-2.147 2.146a.5.5 0 0 0 .708.708l3-3a.5.5 0 0 0 0-.708l-3-3a.5.5 0 1 0-.708.708L10.293 7.5H4.5z"/>
			</svg>
	      </a>
	   <%} %>

   </div>
</div>

<script src="${pageContext.request.contextPath}/js/gura_util.js"></script>
<script>
   
   //클라이언트가 로그인 했는지 여부
   let isLogin=<%=isLogin%>;
   
   document.querySelector(".insert-form")
      .addEventListener("submit", function(e){
         //만일 로그인 하지 않았으면 
         if(!isLogin){
            //폼 전송을 막고 
            e.preventDefault();
            //로그인 폼으로 이동 시킨다.
            location.href=
               "${pageContext.request.contextPath}/users/login_form.jsp?url=${pageContext.request.contextPath}/hfood/detail.jsp?num=<%=num%>";
         }
      });
   
   /*
      detail.jsp 페이지 로딩 시점에 만들어진 1 페이지에 해당하는 
      댓글에 이벤트 리스너 등록 하기 
   */
   addUpdateFormListener(".update-form");
   addUpdateListener(".update-link");
   addDeleteListener(".delete-link");
   addReplyListener(".reply-link");
   
   
   //댓글의 현재 페이지 번호를 관리할 변수를 만들고 초기값 1 대입하기
//댓글의 현재 페이지 번호를 관리할 변수를 만들고, 초기값 1 대입하기
		let currentPage = 1;
		
<<<<<<< HEAD
		//마지막 페이지는 totalPageCount 이다.
		let lastPage = <%=totalPageCount %>;
=======
		//현재 페이지가 마지막 페이지보다 작거나 같을 때 -> 댓글 페이지 출력하기
		if(currentPage <= lastPage){				
			/*
				해당 페이지의 내용을 ajax 요청을 통해서 받아온다.
				"pageNum=xxx&num=xxx" 형식으로 GET 방식 파라미터를 전달한다.
			*/
			ajaxPromise("${pageContext.request.contextPath}/hfood/ajax_comment_list.jsp", "post", "pageNum="+currentPage+"&num="+<%=num %>)
			.then(function(response){
				return response.text();
			})
			.then(function(data){
				//data 에는 html text 가 들어있다.
				document.querySelector(".comment_list").insertAdjacentHTML("beforeend", data);
				
				//새로 추가된 댓글 li 요소 안에 있는 a 요소를 찾아서 이벤트 리스너 등록하기
				addDeleteListener(".page-" + currentPage + " .delete_link");
				addReplyListener(".page-" + currentPage + " .reply_link");
				addUpdateFormListener(".page-" + currentPage + " .update_form");
				addUpdateListener(".page-" + currentPage + " .update_link");
			});
		}
>>>>>>> stash
		
		if(<%=totalRow %> <= 10){
			document.querySelector("#view_more").style.display = "none";
		}
		
		document.querySelector("#view_more").addEventListener("click", function(){
			//현재 댓글 페이지를 1 증가시키고
			currentPage++;			
			
			//현재 페이지가 마지막 페이지보다 작거나 같을 때 -> 댓글 페이지 출력하기
			if(currentPage <= lastPage){				
				/*
					해당 페이지의 내용을 ajax 요청을 통해서 받아온다.
					"pageNum=xxx&num=xxx" 형식으로 GET 방식 파라미터를 전달한다.
				*/
				ajaxPromise("${pageContext.request.contextPath}/hfood/ajax_comment_list.jsp", "post", "pageNum="+currentPage+"&num="+<%=num %>)
				.then(function(response){
					return response.text();
				})
				.then(function(data){
					//data 에는 html text 가 들어있다.
					document.querySelector(".comment_list").insertAdjacentHTML("beforeend", data);
					
					//새로 추가된 댓글 li 요소 안에 있는 a 요소를 찾아서 이벤트 리스너 등록하기
					addDeleteListener(".page-" + currentPage + " .delete_link");
					addReplyListener(".page-" + currentPage + " .reply_link");
					addUpdateFormListener(".page-" + currentPage + " .update_form");
					addUpdateListener(".page-" + currentPage + " .update_link");
				});
			}
			
			if(currentPage == lastPage){
				document.querySelector("#view_more").style.display = "none";
			}else{
				document.querySelector("#view_more").steyl.display = "block";
			}
		});
    //인자로 전달되는 선택자를 이용해서 이벤트 리스너를 등록하는 함수 
      function addUpdateListener(sel){
         //댓글 수정 링크의 참조값을 배열에 담아오기 
         // sel 은  ".page-xxx  .update-link" 형식의 내용이다 
         let updateLinks=document.querySelectorAll(sel);
         for(let i=0; i<updateLinks.length; i++){
            updateLinks[i].addEventListener("click", function(){
               //click 이벤트가 일어난 바로 그 요소의 data-num 속성의 value 값을 읽어온다. 
               const num=this.getAttribute("data-num"); //댓글의 글번호
               document.querySelector("#updateForm"+num).style.display="block";
               
            });
         }
      }
   
      function addDeleteListener(sel){
          //댓글 삭제 링크의 참조값을 배열에 담아오기 
          let deleteLinks=document.querySelectorAll(sel);
          for(let i=0; i<deleteLinks.length; i++){
             deleteLinks[i].addEventListener("click", function(){
                //click 이벤트가 일어난 바로 그 요소의 data-num 속성의 value 값을 읽어온다. 
                const num=this.getAttribute("data-num"); //댓글의 글번호
                const isDelete=confirm("댓글을 삭제 하시겠습니까?");
                if(isDelete){
                   // gura_util.js 에 있는 함수들 이용해서 ajax 요청
                   ajaxPromise("private/comment_delete.jsp", "post", "num="+num)
                   .then(function(response){
                      return response.json();
                   })
                   .then(function(data){
                      //만일 삭제 성공이면 
                      if(data.isSuccess){
                         //댓글이 있는 곳에 삭제된 댓글입니다를 출력해 준다. 
                         document.querySelector("#reli"+num).innerText="삭제된 댓글입니다.";
                      }
                   });
                }
             });
          }
       }
      
      
      function addReplyListener(sel){
          //댓글 링크의 참조값을 배열에 담아오기 
          let replyLinks=document.querySelectorAll(sel);
          //반복문 돌면서 모든 링크에 이벤트 리스너 함수 등록하기
          for(let i=0; i<replyLinks.length; i++){
             replyLinks[i].addEventListener("click", function(){
                
                if(!isLogin){
                   const isMove=confirm("로그인이 필요 합니다. 로그인 페이지로 이동 하시겠습니까?");
                   if(isMove){
                      location.href=
                         "${pageContext.request.contextPath}/users/login_form.jsp?url=${pageContext.request.contextPath}/hfood/detail.jsp?num=<%=num%>";
                   }
                   return;
                }
                
                //click 이벤트가 일어난 바로 그 요소의 data-num 속성의 value 값을 읽어온다. 
                const num=this.getAttribute("data-num"); //댓글의 글번호
                
                const form=document.querySelector("#reForm"+num);
                
                //현재 문자열을 읽어온다 ( "답글" or "취소" )
                let current = this.innerText;
                
                form.style.display="none";
                
                if(current == "답글"){
                   //번호를 이용해서 댓글의 댓글폼을 선택해서 보이게 한다. 
                   form.style.display="block";
                   this.innerText="취소";   

                }else if(current == "취소"){
                  
                   this.innerText="답글";
                   form.style.display="none";
                   
                }
             });
          }
       }
      
      function addUpdateFormListener(sel){
          //댓글 수정 폼의 참조값을 배열에 담아오기
          let updateForms=document.querySelectorAll(sel);
          for(let i=0; i<updateForms.length; i++){
             //폼에 submit 이벤트가 일어 났을때 호출되는 함수 등록 
             updateForms[i].addEventListener("submit", function(e){
                //submit 이벤트가 일어난 form 의 참조값을 form 이라는 변수에 담기 
                const form=this;
                //폼 제출을 막은 다음 
                e.preventDefault();
                //이벤트가 일어난 폼을 ajax 전송하도록 한다.
                ajaxFormPromise(form)
                .then(function(response){
                   return response.json();
                })
                .then(function(data){
                   if(data.isSuccess){
                      /*
                         document.querySelector() 는 html 문서 전체에서 특정 요소의 참조값을 찾는 기능
             			  특정문서의 참조값.querySelector() 는 해당 문서 객체의 자손 요소 중에서 특정 요소의 참조값을 찾는 기능
                      */
                      const num=form.querySelector("input[name=num]").value;
                      const content=form.querySelector("textarea[name=content]").value;
                      //수정폼에 입력한 value 값을 pre 요소에도 출력하기 
                      document.querySelector("#pre"+num).innerText=content;
                      form.style.display="none";
                   }
                });
             });
          }

       }
    </script>
      
</body>
</html>