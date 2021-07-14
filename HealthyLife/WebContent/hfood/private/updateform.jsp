
<%@page import="hfood.board.dto.HfoodDto"%>
<%@page import="hfood.board.dao.HfoodDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	int num=Integer.parseInt(request.getParameter("num"));
	HfoodDto dto=HfoodDao.getInstance().getData(num);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/hfood/private/updateform.jsp</title>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
<jsp:include page="../../include/resource.jsp"></jsp:include>
<style>
   #content{
   		width : 100%;
      height: 500px;
   }
   
   .container {
	  width : 800px;
	  padding : 50px;
	  font-family: 'Noto Sans KR', sans-serif;
   }
   
   p {
	    background-color: #2252e3;
	    font-size: 20px;
	    color: white;
	    width: 170px;
	    font-family: 'Noto Sans KR', sans-serif;
   }
   
   h1 {
		margin-bottom:30px;
		text-align:left;
		font-family: 'Noto Sans KR', sans-serif;
   }
   
   #title { 
 		height:50px;
 		font-size : 30px;
   }
   
   
   
</style>
</head>
<body>
<div class="container rounded-3">
	<form action="update.jsp" method="post">
	<p>
		<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="white" class="bi bi-emoji-wink" viewBox="-1 0 15 19">
		<path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
		<path d="M4.285 9.567a.5.5 0 0 1 .683.183A3.498 3.498 0 0 0 8 11.5a3.498 3.498 0 0 0 3.032-1.75.5.5 0 1 1 .866.5A4.498 4.498 0 0 1 8 12.5a4.498 4.498 0 0 1-3.898-2.25.5.5 0 0 1 .183-.683zM7 6.5C7 7.328 6.552 8 6 8s-1-.672-1-1.5S5.448 5 6 5s1 .672 1 1.5zm1.757-.437a.5.5 0 0 1 .68.194.934.934 0 0 0 .813.493c.339 0 .645-.19.813-.493a.5.5 0 1 1 .874.486A1.934 1.934 0 0 1 10.25 7.75c-.73 0-1.356-.412-1.687-1.007a.5.5 0 0 1 .194-.68z"/>
		</svg>
	HEALTHY LIFE
	</p>
   <h1>건강한 레시피 수정하기</h1>
   
	   	<input type="hidden" name="num" value="<%=num %>" />
   		<div class="mb-3">
        	<label for="writer"></label>
	        <input type="text" id="writer" value="<%=dto.getWriter() %>" disabled/>
	    </div>
	    <div class="mb-3">
	         <label for="title"></label>
	         <input type="text" name="title" id="title" value="<%=dto.getTitle()%>"/>
	   	</div>
	    <div class="mb-3">
	         <label for="content"></label>
	         <textarea name="content" id="content"><%=dto.getContent() %></textarea>
	    </div>
    	<div style="text-align:center;">
	      	<button class="btn btn-primary me-md-3" type="submit" onclick="submitContents(this)">수정하기</button>
	      	<button class="btn btn-primary me-md-3" type="reset" onclick="resetContents(this)">취소하기</button>
      	</div> 
   </form>
</div>
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
      fCreator: "createSEditor2"
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
   
   function resetContents() { //취소버튼을 누르면 content창이 reset 됩니다. 
	   
	   oEditors.getById["content"].exec("SET_IR",['']);

	      
	   }
   
   
   
   function setDefaultFont() {
      var sDefaultFont = '궁서';
      var nFontSize = 24;
      oEditors.getById["content"].setDefaultFont(sDefaultFont, nFontSize);
   }
</script>
</body>
</html>