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
		width: 670px;
	}
	.content_container{
		margin-top: 20px;
	}
		
	/*가운데 정렬*/
	.container {
		margin-top: 40px;
		padding-bottom: 80px;
		width: 700px;
	}
	/* 맨 위의 제목 & 게시글 작성 버튼 */
	.WritingHeader{
		display: flex;
		justify-content: space-between;
	    align-items: center;
        border-bottom: solid 2px #1c3992;
	}
	
	/* form 을 둘러싸는 div */
	.form_wrapper div{
		margin-top: 10px;
		margin-bottom: 10px;
	}
	/* 게시글 등록 버튼 */
	.WritingHeader #submit_button{
		background-color: #1c3992;
	    border-color: #1c3992;
	    color: white;
	}
	.WritingHeader #go_back_button{
		background-color: #777777;
    	border-color: #777777;
    	color: white;
	}

	/* form select -> 색 변경 & 커서 올리면 사람 손 선택 모양 */
	#type{
		border-color: #b4c0e4;
	    cursor: pointer;
	}
	/* form-control -> 색 변경 */
	.form-control{
		border-color: #b4c0e4;
	}
	
	/* form 의 버튼 안보이게하기 */
	.form_wrapper button{
		display: none;
	}
	
	/* type 입력 : label 과 input 나란히 놓기 */
	.type_wrapper{
		display: flex;
		align-items: center;
	}
	.type_label_div label{
		margin: auto 0;
	    margin-right: 10px;
	    width: 80px;
	}
	.type_input_div{
		flex-grow: 19;
	}
	
	/* title 입력 : label 과 input 나란히 놓기 */
	.title_wrapper{
		display: flex;
		align-items: center;
	}
	.title_label_div label{
		margin: auto 0;
	    margin-right: 10px;
	    width: 80px;
	}
	.title_input_div{
		flex-grow: 19;
	}
	
	/* title 입력 : label 과 input 나란히 놓기 */
	.video_wrapper{
		display: flex;
		align-items: center;
	}
	.video_label_div label{
		margin: auto 0;
	    margin-right: 10px;
	    width: 80px;
	}
	.video_input_div{
		flex-grow: 19;
	}
	
	
</style>
</head>
<body>
	<jsp:include page="../../include/navbar.jsp">
		<jsp:param value="videos" name="thisPage"/>
	</jsp:include>
	<div class="container">
		<div class="WritingHeader">
			<div>
				<h1>게시글 수정</h1>
			</div>
			<div>
				<a class="btn" id="submit_button">수정</a>
				<a class="btn" id="go_back_button">취소</a>
			</div>
		</div>
		
		<div class="form_wrapper">
			<form action="${pageContext.request.contextPath}/videos/private/update.jsp" method="post" id="updateForm">
				<input type="hidden" name="num" value="<%=num %>" />
				<div class="type_wrapper">
					<div class="type_label_div">
						<label class="form-label" for="type">카테고리</label>
					</div>
					<div class="type_input_div">
						<select class="form-select" name="type" id="type">
				        	<option value="not-selected">카테고리를 선택해주세요.</option>
				            <option value="yoga" <%="yoga".equals(dto.getType())?"selected":"" %>>요가</option>
				            <option value="stretching" <%="stretching".equals(dto.getType())?"selected":"" %>>스트레칭</option>
				            <option value="diet" <%="diet".equals(dto.getType())?"selected":"" %>>다이어트</option>
				            <option value="rehabili" <%="rehabili".equals(dto.getType())?"selected":"" %>>재활 및 교정</option>
				        </select>
					</div>
				</div>
				<div class="title_wrapper">
					<div class="title_label_div">
						<label class="form-label" for="title">제목</label>
					</div>
					<div class="title_input_div">
						<input class="form-control" type="text" id="title" name="title" value="<%=dto.getTitle() %>" />
					</div>
				</div>
				<div class="video_wrapper">
					<div class="video_label_div">
						<label class="form-label" for="video">동영상</label>
					</div>
					<div class="video_input_div">
						<input class="form-control" type="url" id="video" name="video" value="<%=dto.getVideo()%>"/>
					</div>
				</div>
				<div>
					<textarea name="content" id="content"><%=dto.getContent() %></textarea>
				</div>
				<button type="submit">수정</button>
			</form>
		</div>
	</div>
	
	<!-- SmartEditor 에서 필요한 javascript 로딩  -->
	<script src="${pageContext.request.contextPath }/SmartEditor/js/HuskyEZCreator.js"></script>
	<script>
		document.querySelector("#go_back_button").addEventListener("click", function(e){
			let isGoBack = confirm("작성 중인 수정사항을 저장하지 않고, 이전으로 돌아가시겠습니까?");
			if(isGoBack){
				//혹시 모를 폼 제출 막기
				e.preventDefault();
				location.href = "${pageContext.request.contextPath}/videos/detail.jsp?num=<%=num %>";
			}
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
		
		//등록 버튼 -> form 내부의 submit 버튼 눌러지게 하기
		document.querySelector("#submit_button").addEventListener("click", function(){
			//form 의 submit 버튼 눌러지게 하기
			document.querySelector("#updateForm button").click();
		});
	</script>
</body>
</html>