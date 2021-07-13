<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	//로그인 상태 확인 : session 에 "id" 값 가져오기
	// id == null : 로그인 되지 않은 상태
	// id != null : 로그인 된 상태
	String id = (String)session.getAttribute("id");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/index.jsp</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>
<jsp:include page="/include/resource.jsp"></jsp:include>
<jsp:include page="/include/navbar.jsp"></jsp:include>
<style>
@import url('https://fonts.googleapis.com/css2?family=Nanum+Gothic:wght@700&display=swap');

	
	.carousel {
		width : 800px;
		margin: auto;
	}
	
	h1 {
	    text-align: center;
	    margin: 30px;
	    font-style: italic;
	    font-weight: 600;
	    font-size: 35px;
	}
	
	.member {
	font-family: 'Nanum Gothic', sans-serif;
	}
	
	.member-img {
		margin-top: 20px;
		height: 300px;
	}
	

	.member-img .memoticon {
		z-index:1;
		float: left;
		cursor: pointer;
		margin: 25px;
		position: relative;
		vertical-align: middle; 
		width: 200px;
		height: 200px;		
	}
	.member-info .info{
		float: left;
		margin: 25px;
		position: relative;
		vertical-align: middle; 
	}
	
	.member-card {
		position: relative;
		height: 200px;
	}
	
	.member-card .card{
		position: absolute;
		display: none;
		float: left;
		top: -180px;
		margin: 25px;
		height: 300px;
		width: 200px;
		border-radius: 7%;
		background-color: rgba(255, 201, 71, 0.8);
		box-shadow: 10px 10px 10px 0 #AAAAAA;
	}
	
	#sori_card{
		left: 240px;
	}
	
	#rami_card{
		left: 490px;
	}
	
	#hyeoni_card{
		left: 738px;
	}
	
	#hani_card{
		left: 995px;
	}
	.member-card .card >h4 {
		position: relative;
		text-align: center;
		top: 80px;
		
	}
	
	.member-card .card >p {
		position: relative;
		text-align: center;
		top: 120px;	
	}
	
	
</style>
</head>
<body>
	<div class="container">
		<h1>I support your health!</h1>
		<div id="carouselExampleIndicators" class="carousel slide w-75" data-bs-ride="carousel">
		  <div class="carousel-indicators">
		    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="0" class="active" aria-current="true" aria-label="Slide 1"></button>
		    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="1" aria-label="Slide 2"></button>  
		    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="2" aria-label="Slide 3"></button>  
		    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="3" aria-label="Slide 4"></button>  
		    <button type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide-to="4" aria-label="Slide 5"></button>  
		  </div>
		  <div class="carousel-inner">
		  	<div class="carousel-item">
		      <img src="image/homeW.jpg" class="d-block w-100" alt="...">
		    </div>
		    <div class="carousel-item">
		      <img src="image/video.jpg" class="d-block w-100" alt="...">
		    </div>
		    <div class="carousel-item active">
		      <img src="image/oneday.jpg" class="d-block w-100" alt="...">
		    </div>
		    <div class="carousel-item">
		      <img src="image/tomato.jpg" class="d-block w-100" alt="...">
		    </div>
		    <div class="carousel-item">
		      <img src="image/music.jpg" class="d-block w-100" alt="...">
		    </div>
		  </div>
		  <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="prev">
		    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
		    <span class="visually-hidden">Previous</span>
		  </button>
		  <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleIndicators" data-bs-slide="next">
		    <span class="carousel-control-next-icon" aria-hidden="true"></span>
		    <span class="visually-hidden">Next</span>
		  </button>
		</div>
		<div class="member">		
		<div class="member-img">
				<img class="memoticon animate__animated" id="hwani" src="image/hwani.png" />
				<img class="memoticon animate__animated" id="sori" src="image/sori.png" />
				<img class="memoticon animate__animated" id="rami" src="image/rami.png"/>
				<img class="memoticon animate__animated" id="hyeoni" src="image/hyeoni.png"/>
				<img class="memoticon animate__animated" id="hani" src="image/hani.png"/>	
		</div>
		
		<div class="member-card">
			<div class="card" id="hwani_card">
			<h4>팀장 강륜화</h4>
			<p>📍  프로젝트 총괄 및 관리</p>
			<p>💻 영상자료 페이지 <br /> 회원 가입 및 로그인 처리 </p>
			</div>
			<div class="card" id="sori_card">
			<h4>팀원 김정솔</h4>
			<p>📍  프로젝트 발표</p>
			<p>💻 추천 음악 페이지 </p>
			</div>
			<div class="card" id="rami_card">
			<h4>팀원 양우람</h4>
			<p>📍  PPT 제작</p>
			<p>💻 index 페이지 <br />건강 레시피 페이지 <br /> navbar & CSS 구성  </p>
			</div>
			<div class="card" id="hyeoni_card">
			<h4>팀원 이지현</h4>
			<p>💻 홈트 페이지 </p>
			</div>
			<div class="card" id="hani_card">
			<h4>팀원 전하은</h4>
			<p>💻  index 페이지 <br /> 원데이 클래스 페이지 </p>
			</div>
		</div>
		</div>
		</div>
<script>
	const memoticons = document.querySelectorAll(".memoticon");
	const cards = document.querySelectorAll(".card");
	//클릭할 때 애니메이션
	for(let i=0; i<memoticons.length; i++){
		memoticons[i].addEventListener("mouseover", function(){
			this.classList.add("animate__tada");
		});
		memoticons[i].addEventListener("mouseout", function(){
			this.classList.remove("animate__tada");
		});
		memoticons[i].addEventListener("click", function(){
			if(cards[i].style.display=="block"){
				cards[i].style.display="none";
			}else{
				cards[i].style.display="block";
			}
		});
		
	}
</script>
</body>

</html>