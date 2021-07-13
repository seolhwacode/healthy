<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/videos/private/insert_form.jsp</title>
<jsp:include page="../../include/resource.jsp"></jsp:include>
<script src="https://unpkg.com/sweetalert/dist/sweetalert.min.js"></script>
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
		padding-bottom: 50px;
		width: 700px;
		margin-top: 100px;
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
	/* 뒤로가기 버튼 */
	.WritingHeader #goback_button{
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
</style>
</head>
<body>
	<jsp:include page="../../include/navbar.jsp">
		<jsp:param value="videos" name="thisPage"/>
	</jsp:include>
	<div class="container">
		<div class="WritingHeader">
			<div>
				<h1 class="title">게시글 작성하기</h1>
			</div>
			<div>
				<a class="btn" id="submit_button">등록</a>
				<a class="btn" id="goback_button">취소</a>
			</div>
		</div>
		
		<div class="form_wrapper">
			<form action="${pageContext.request.contextPath}/videos/private/insert.jsp" method="post" id="insertForm">
				<div>
			        <select class="form-select" name="type" id="type">
			        	<option value="not-selected">카테고리를 선택해주세요.</option>
			            <option value="yoga">요가</option>
			            <option value="stretching">스트레칭</option>
			            <option value="diet">다이어트</option>
			            <option value="rehabili">재활 및 교정</option>
			        </select>
				</div>
				<div>
					<input class="form-control" type="text" id="title" name="title" placeholder="제목을 입력해 주세요." />
				</div>
				<div>
					<input class="form-control" type="url" id="video" name="video" placeholder="url : youtube 공유 주소 또는 상단의 주소 입력"/>
				</div>
				<div class="content_container">
					<%-- content 는 없을 수도 있다. --%>
					<textarea class="form-control" name="content" id="content"></textarea>
				</div>
				<button type="submit"></button>
			</form>
		</div>
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
			const type = document.querySelector("#type").value;
			const url = document.querySelector("#video").value;
			
			//url 빈칸 검사
			if(url == ""){
				//alert("동영상 url을 입력해주세요!");
				swal({
				  	title: "동영상 url을 입력해주세요!",
				  	icon: "warning",
				});
				e.preventDefault();
			}
			
			//만일 폼 제출을 막고싶으면 => e.preventDefault() 을 수행해서 폼 제출을 막는다.
			//제목의 길이가 너무 짧다
			if(title.length < 3){
				//제목이 없거나, 길이가 너무 짧다
				//alert("제목을 3글자 이상 입력하세요!");
				swal({
				  	title: "제목을 3글자 이상 입력하세요!",
				  	icon: "warning",
				});
				e.preventDefault();
			}
			
			//타입 선택이 없음 -> 선택해주세요!
			if(type == "not-selected"){
				//alert("게시판을 선택해주세요!");
				swal({
				  	title: "게시판을 선택해주세요!",
				  	icon: "warning",
				});
				e.preventDefault();
			}
			
			<%-- url 가용성 검사는 input 에서 자동으로 해줌 -> 필요없어짐(삭제) --%>
			<%-- content 는 없을 수도 있다. --%>
		});
		
		//등록 버튼 -> form 의 submit 버튼 click 되게 하기
		document.querySelector("#submit_button").addEventListener("click", function(){
			document.querySelector("#insertForm button").click();
		});
		
		//취소 버튼 -> 이전 페이지로 돌아간다.
		document.querySelector("#goback_button").addEventListener("click", function(e){
			//let isGoBack = confirm("작성 중인 글을 지우고 이전으로 돌아가시겠습니까?");
			swal({
			  	title: "변경사항이 저장되지 않았습니다.",
			  	text: `작성 중인 수정사항을 저장하지 않고,
			  		이전으로 돌아가시겠습니까?`,
			  	icon: "warning",
			  	buttons: true,
			  	dangerMode: true
			})
			.then(function(isGoBack){
				if(isGoBack){
					//혹시 모를 폼 제출 막기
					e.preventDefault();
					//리스트 페이지로 돌아가기
					location.href = "${pageContext.request.contextPath}/videos/list.jsp";
				}
			});
			/* if(isGoBack){
				//혹시 모를 폼 제출 막기
				e.preventDefault();
				//리스트 페이지로 돌아가기
				location.href = "${pageContext.request.contextPath}/videos/list.jsp";
			} */
			//취소 -> 아무 일도 없음
		});
	</script>
	
</body>
</html>