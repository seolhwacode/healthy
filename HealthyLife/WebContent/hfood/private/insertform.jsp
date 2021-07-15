<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/hfood/private/insertform.jsp</title>
<jsp:include page="../../include/resource.jsp"></jsp:include>
<style>
 	#content{
   		width : 100%;
      height: 500px;
   }
   
   .container {
	  width : 800px;
	  padding : 50px;
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

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Noto+Sans+KR&display=swap" rel="stylesheet">
	
</head>
<body>
	<jsp:include page="../../include/navbar.jsp">
	<jsp:param value="hfood" name="thisPage"/>
	</jsp:include>
<div class="container rounded-3">
   <form action="insert.jsp" method="post" id="insertForm">
   		<p>
   		<svg xmlns="http://www.w3.org/2000/svg" width="25" height="25" fill="white" class="bi bi-emoji-wink" viewBox="-1 0 15 19">
	  		<path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
	  		<path d="M4.285 9.567a.5.5 0 0 1 .683.183A3.498 3.498 0 0 0 8 11.5a3.498 3.498 0 0 0 3.032-1.75.5.5 0 1 1 .866.5A4.498 4.498 0 0 1 8 12.5a4.498 4.498 0 0 1-3.898-2.25.5.5 0 0 1 .183-.683zM7 6.5C7 7.328 6.552 8 6 8s-1-.672-1-1.5S5.448 5 6 5s1 .672 1 1.5zm1.757-.437a.5.5 0 0 1 .68.194.934.934 0 0 0 .813.493c.339 0 .645-.19.813-.493a.5.5 0 1 1 .874.486A1.934 1.934 0 0 1 10.25 7.75c-.73 0-1.356-.412-1.687-1.007a.5.5 0 0 1 .194-.68z"/>
		</svg>
		HEALTHY LIFE
		</p>
   		<h1>건강한 레시피 공유하기</h1>
      	<div class="mb-3">         
         	<input class="form-control" type="text" name="title" id="title" placeholder="제목"/>
      	</div>
      	<div class="mb-3">
         	<textarea class="form-control"  name="content" id="content"></textarea>
      	</div>
      	<div style="text-align:center;">
   			<button class="btn btn-primary me-md-3" style="background:#2252e3;" type="submit">저장하기</button>
		</div>   
   </form>
</div>
<%--
   [ SmartEditor 를 사용하기 위한 설정 ]
   
   1. WebContent 에 SmartEditor  폴더를 복사해서 붙여 넣기
   2. WebContent 에 upload 폴더 만들어 두기
   3. WebContent/WEB-INF/lib 폴더에 
      commons-io.jar 파일과 commons-fileupload.jar 파일 붙여 넣기
   4. <textarea id="content" name="content"> 
      content 가 아래의 javascript 에서 사용 되기때문에 다른 이름으로 바꾸고 
         싶으면 javascript 에서  content 를 찾아서 모두 다른 이름으로 바꿔주면 된다. 
   5. textarea 의 크기가 SmartEditor  의 크기가 된다.
   6. 폼을 제출하고 싶으면  submitContents(this) 라는 javascript 가 
         폼 안에 있는 버튼에서 실행되면 된다.
 --%>
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

   
   function setDefaultFont() {
      var sDefaultFont = '궁서';
      var nFontSize = 24;
      oEditors.getById["content"].setDefaultFont(sDefaultFont, nFontSize);
   }
   
   //폼에 submit 이벤트가 일어났을때 실행할 함수 등록
   document.querySelector("#insertForm")
      .addEventListener("submit", function(e){
         //에디터에 입력한 내용이 textarea 의 value 값이 될수 있도록 변환한다. 
         oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
         //textarea 이외에 입력한 내용을 여기서 검증하고 
         const title=document.querySelector("#title").value;
         
         //만일 폼 제출을 막고 싶으면  
         //e.preventDefault();
         //을 수행하게 해서 폼 제출을 막아준다.
         if(title.length < 5){
            alert("제목을 5글자 이상 입력하세요!");
            e.preventDefault();
         }
         
      });
</script>
</body>
</html>


