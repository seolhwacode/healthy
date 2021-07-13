<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

<style>
	body{
		background-color: #F3ECC2;
	}
	.warning-img{
		margin: 50px auto 0;
		height: 300px;
		width: 300px;
		color: #E8505B;
	}
	.warning-msg{
		text-align: center;
		color: #064420;
		
	}

	
</style>
<title>error!</title>
</head>
<body>

<div class="warning-img animate__animated animate__swing">
<svg xmlns="http://www.w3.org/2000/svg" fill="currentColor" class="bi bi-exclamation-circle" viewBox="0 0 16 16">
  <path d="M8 15A7 7 0 1 1 8 1a7 7 0 0 1 0 14zm0 1A8 8 0 1 0 8 0a8 8 0 0 0 0 16z"/>
  <path d="M7.002 11a1 1 0 1 1 2 0 1 1 0 0 1-2 0zM7.1 4.995a.905.905 0 1 1 1.8 0l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 4.995z"/>
</svg>
</div>
<div class="warning-msg">
	<h1>접근할 수 없습니다!</h1>
	<h4>본인이 작성하지 않은 게시글은 볼 수 없어요!</h4>
	<h4><a href="bookingList.jsp">🚶‍♂️다시 돌아가기🚶‍♀️</a></h6>	
</div>
</body>
</html>