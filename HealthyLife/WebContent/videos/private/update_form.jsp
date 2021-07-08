<%@page import="videos.board.dao.VideosDao"%>
<%@page import="videos.board.dto.VideosDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//GET 파라미터로 전달되는 해당 게시글의 num 읽어오기
	int num = Integer.parseInt(request.getParameter("num"));

	//해당 게시글의 데이터 읽어서 화면에 출력
	VideosDto insertDto = new VideosDto();
	insertDto.setNum(num);
	
	VideosDto dto = VideosDao.getInstance().getData(insertDto);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/videos/private/update_form.jsp</title>
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
		<h1>게시글 수정</h1>
		<form action="${pageContext.request.contextPath}/videos/private/update.jsp" method="post" id="updateForm">
			<input type="hidden" name="num" value="<%=num %>" />
			<div>
				<label class="form-label" for="title">제목</label>
				<input class="form-control" type="text" id="title" name="title" value="<%=dto.getTitle() %>" />
			</div>
			<div>
				<label class="form-label" for="video">동영상</label>
				<input class="form-control" type="url" id="video" name="video" value="<%=dto.getVideo()%>"/>
			</div>
			<div>
				<label class="form-label" for="content">내용</label>
				<textarea name="content" id="content"><%=dto.getContent() %></textarea>
			</div>
			<button class="btn btn-primary" type="submit">수정</button>
			<button class="btn btn-danger" id="goBackBtn">취소</button>
		</form>
	</div>
	
	<!-- SmartEditor 에서 필요한 javascript 로딩  -->
	<script src="${pageContext.request.contextPath }/SmartEditor/js/HuskyEZCreator.js"></script>
	<script>
		document.querySelector("#goBackBtn").addEventListener("click", function(e){
			//혹시 모를 폼 제출 막기
			e.preventDefault();
			location.href = "${pageContext.request.contextPath}/videos/detail.jsp?num=<%=num %>";
		});
		
		
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
		document.querySelector("#updateForm").addEventListener("submit", function(e){
			// 에디터의 내용이 textarea에 적용됩니다.
			//에디터에 입력한 내용이 textarea 의 value 값이 될 수 있도록 변환한다.
			oEditors.getById["content"].exec("UPDATE_CONTENTS_FIELD", []);
			
			//textarea 이외에 입력한 내용을 여기서 검증하고
			const title = document.querySelector("#title").value;
			
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