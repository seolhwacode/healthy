<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/videos/private/insert_form.jsp</title>
<jsp:include page="../../include/resource.jsp"></jsp:include>
<style>
	#content{
		height: 300px;
		width: 700px;
	}
	.content_container{
		margin-top: 20px;
	}
</style>
</head>
<body>
	<div class="container">
		<h1>게시글 작성하기</h1>
		<form action="${pageContext.request.contextPath}/videos/private/insert.jsp" method="post" id="insertForm">
			<div>
				<label class="form-label" for="type">게시판 선택</label>
		        <select class="form-control" name="type" id="type">
		            <option value="yoga">요가</option>
		            <option value="stretching">스트레칭</option>
		            <option value="diet">다이어트</option>
		            <option value="rehabili">재활 및 교정</option>
		        </select>
			</div>
			<div>
				<label class="form-label" for="title">제목</label>
				<input class="form-control" type="text" id="title" name="title" />
			</div>
			<div>
				<label class="form-label" for="video">동영상 URL</label>
				<input class="form-control" type="url" id="video" name="video" />
			</div>
			<div class="content_container">
				<%-- content 는 없을 수도 있다. --%>
				<textarea name="content" id="content"></textarea>
			</div>
			<button class="btn btn-primary" type="submit">등록</button>
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
	   	
		//폼에 submit 이벤트가 일어났을 때, 실행할 함수 등록
		document.querySelector("#insertForm").addEventListener("submit", function(e){
			// 에디터의 내용이 textarea에 적용됩니다.
			//에디터에 입력한 내용이 textarea 의 value 값이 될 수 있도록 변환한다.
			oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
			
			//textarea 이외에 입력한 내용을 여기서 검증하고
			const title = document.querySelector("#title").value;
			
			//url 형식 검사 정규식
			const reg_url = /^(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?$/
			
			//만일 폼 제출을 막고싶으면 => e.preventDefault() 을 수행해서 폼 제출을 막는다.
			//제목의 길이가 너무 짧다
			if(title.length < 5){
				//제목이 없거나, 길이가 너무 짧다
				alert("제목을 5글자 이상 입력하세요!");
				e.preventDefault();
			}
			
			<%-- url 검사는 input 에서 자동으로 해줌 -> 필요없어짐(삭제) --%>
			<%-- content 는 없을 수도 있다. --%>
		});
	</script>
	
</body>
</html>