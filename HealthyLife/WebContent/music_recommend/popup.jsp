<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/music_recommend/popup.jsp</title>
<style>
	body{ padding: 100px; background: #f5f7fb;}
	.btn{ display: block; width: 200px; height: 50px; background: #4ac4f3;
	text-decoration: none; text-align: center; line-height: 50px; color: #fff;
	border-radius:50px;}
	.popup{position: absolute; left: 50%; top: 50%; z-index: 5; transform: translate(-50%,-50%);
	width: 500px; height: 500px; box-shadow: 0 0 10px rgba(0,0,0,0.5); background:#fff;
	border-radius: 5px; text-align: right; padding: 20px; box-sizing: border-box; opacity: 0; transition: all 0.5s;}
	.popup a {color: grey; text-decoration: none;}
	.popup:target {opacity: 1;}
	.popup:target + .dim {opacity: 1; z-index: 2;}
	.dim {position: fixed; left: 0; top: 0; z-index: -1; width: 100% height: 100%;
	background: rgba(0,0,0,0.6); opacity: 0; trasition: all 0.5s;}	
</style>
</head>
<body>
	<a href="#pop1" class="btn">팝업열기</a>
	<div class="popup" id="pop1">
		<a href="#a">닫기</a>
		<a href="#b">확인</a>
		<a href="#c">취소</a>
	</div>
	<div class="dim"></div>
</body>
</html>