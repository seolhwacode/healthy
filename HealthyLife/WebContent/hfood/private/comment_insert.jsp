<%@page import="hfood.board.dto.Hfood_comment_dto"%>
<%@page import="hfood.board.dao.Hfood_comment_dao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int ref_group=Integer.parseInt(request.getParameter("ref_group"));
	String target_id=request.getParameter("target_id");
	String content=request.getParameter("content");
	String comment_group = request.getParameter("comment_group");
	
	String writer=(String)session.getAttribute("id");
	
	int seq=Hfood_comment_dao.getInstance().getSequence();
	
	Hfood_comment_dto dto = new Hfood_comment_dto();
	dto.setNum(seq);
	dto.setWriter(writer);
	dto.setTarget_id(target_id);
	dto.setContent(content);
	dto.setRef_group(ref_group);
	
	if(comment_group == null){
		dto.setComment_group(seq);
	} else {
		dto.setComment_group(Integer.parseInt(comment_group));
	}
	
	boolean isSuccess = Hfood_comment_dao.getInstance().insert(dto);
	
	//String cPath=request.getContextPath();
	//response.sendRedirect(cPath+"/hfood/detail.jsp?num="+ref_group);
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%if(isSuccess){ %>
	<script>
		location.href = "${pageContext.request.contextPath}/hfood/detail.jsp?num="+<%=ref_group%>;
	</script>
<%}else{ %>
	<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
    <script>
    swal({
        title: "댓글창 확인해주세요!",
        icon: "warning"
	  })
	  .then(function(){
    location.href = "${pageContext.request.contextPath}/hfood/detail.jsp?num="+<%=ref_group%>;
	  });
    </script>
<%} %>

</body>
</html>


