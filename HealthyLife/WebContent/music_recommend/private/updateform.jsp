<%@page import="music.rmd.dao.MRDao"%>
<%@page import="music.rmd.dto.MRDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	int num=Integer.parseInt(request.getParameter("num"));
   MRDto dto=MRDao.getInstance().getData(num);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Black+Han+Sans&family=Nanum+Gothic&display=swap" rel="stylesheet">
<title>/music_recommend/private/updateform.jsp</title>
<jsp:include page="../../include/resource.jsp"></jsp:include>
<style>
   #content{
      height: 300px;
		
   }
   h1{
   	font-family: 'Black Han Sans', sans-serif;
   	margin-bottom:20px !important;
		text-align: center;
   }
   div{
   font-family: 'Nanum Gothic', sans-serif;
   font-size: large;
   }
</style>
</head>
<body>
<jsp:include page="/include/navbar.jsp">
	<jsp:param value="music_recommend" name="thisPage"/>
</jsp:include>
<div class="container">
   <h1 class="text-primary">게시글 수정</h1>
   <form action="update.jsp" method="post" id="updateForm">
      <input type="hidden" name="num" value="<%=num %>" />
      <div class="text-primary">
         <label for="writer">작성자</label>
         <input type="text" id="writer" value="<%=dto.getWriter() %>" disabled/>
      </div>
      <div class="text-primary">
         <label class="form-label" for="title">제목</label>
         <input class="form-control" type="text" name="title" id="title" value="<%=dto.getTitle()%>"/>
      </div>
      <div class="text-primary">
         <label class="form-label" for="content">내용</label>
         <textarea class="form-control" name="content" id="content"><%=dto.getContent() %></textarea>
      </div>
      <div class="text-primary">
         <label class="form-label" for="music">음악 주소</label>
         <textarea class="form-control" name="music" id="music"><%=dto.getMusic() %></textarea>
      </div>
      <button class="btn btn-primary" type="submit" onclick="submitContents(this);">수정확인</button>
      <button class="btn btn-primary" type="reset">취소</button>
   </form>
</div>
<!-- SmartEditor 에서 필요한 javascript 로딩  -->
<script src="${pageContext.request.contextPath }/SmartEditor/js/HuskyEZCreator.js"></script>
<script>
   var oEditors = [];
   
   //추가 글꼴 목록
   //var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];
   
   nhn.husky.EZCreator.createInIFrame({
      oAppRef: oEditors,
      elPlaceHolder: "content",
      sSkinURI: "${pageContext.request.contextPath}/SmartEditor/SmartEditor2Skin.html",   
      htParams : {
         bUseToolbar : true,            // 툴바 사용 여부 (true:사용/ false:사용하지 않음)
         bUseVerticalResizer : true,      // 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
         bUseModeChanger : true,         // 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
         //aAdditionalFontList : aAdditionalFontSet,      // 추가 글꼴 목록
         fOnBeforeUnload : function(){
            //alert("완료!");
         }
      }, //boolean
      fOnAppLoad : function(){
         //예제 코드
         //oEditors.getById["ir1"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
      },

   });
   
   function pasteHTML() {
      var sHTML = "<span style='color:#FF0000;'>이미지도 같은 방식으로 삽입합니다.<\/span>";
      oEditors.getById["content"].exec("PASTE_HTML", [sHTML]);
   }
   
   function showHTML() {
      var sHTML = oEditors.getById["content"].getIR();
      alert(sHTML);
   }
      
   function submitContents(elClickedObj) {
      oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);   // 에디터의 내용이 textarea에 적용됩니다.
      
      // 에디터의 내용에 대한 값 검증은 이곳에서 document.getElementById("content").value를 이용해서 처리하면 됩니다.
      
      try {
         elClickedObj.form.submit();
      } catch(e) {}
   }
   
   function setDefaultFont() {
      var sDefaultFont = '궁서';
      var nFontSize = 24;
      oEditors.getById["content"].setDefaultFont(sDefaultFont, nFontSize);
   }
   
   document.querySelector("#updateForm").addEventListener("reset", function(e){
		let isReset = confirm("작성 중인 글을 취소하시겠습니까?");
		if(isReset){
			//혹시 모를 폼 제출 막기
			e.preventDefault();
			//리스트 페이지로 돌아가기
			location.href = "${pageContext.request.contextPath}/music_recommend/list.jsp";
		}
		
	});
</script>
</body>
</html>