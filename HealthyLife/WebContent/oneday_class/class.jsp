<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>/oneday_class/class.jsp</title>
<jsp:include page="/include/resource.jsp"></jsp:include>
<style>
    html,
    body {
        background-color: #f4f4ef;
    }
    
    a,
    a:hover,
    a:active {
        text-decoration: none;
        color: #525c65;
        transition: color 0.3s ease;
    }
    
    .product-card {
        position: relative;
        margin: 10px 0px;
        z-index: 1;
        display: block;
        background: #FFFFFF;
        min-width: 270px;
        height: 470px;
        box-shadow: 12px 15px 20px 0px rgba(46, 61, 73, 0.15);
        border-radius: 0.375rem;
        transition: all 0.3s ease;
    }
    
    .product-card:hover {
        box-shadow: 2px 4px 8px 0px rgba(46, 61, 73, 0.2)
    }
    
    .product-card .card-thumbnail {
        background: #000000;
        /* height: 400px; */
        overflow: hidden;
    }
    
    .product-card .card-thumbnail img {
        display: block;
        width: 120%;
        -webkit-transition: all .3s cubic-bezier(0, .5, .5, 1);
        -o-transition: all .3s cubic-bezier(0, .5, .5, 1);
        transition: all .3s cubic-bezier(0, .5, .5, 1);
    }
    
    .product-card:hover .card-thumbnail img {
        -webkit-transform: scale(1.1);
        -moz-transform: scale(1.1);
        transform: scale(1.1);
        opacity: .6;
    }
    
    .fa-send:before {
        color: #fff;
        position: absolute;
        top: 15px;
        left: 13px;
    }
    
    .product-card .card-content {
        position: absolute;
        bottom: 0;
        background: #FFFFFF;
        width: 100%;
        padding: 40px 30px;
        -webkti-box-sizing: border-box;
        -moz-box-sizing: border-box;
        box-sizing: border-box;
        -webkit-transition: all 0.3s cubic-bezier(0.37, 0.75, 0.61, 1.05) 0s;
        -moz-transition: all 0.3s cubic-bezier(0.37, 0.75, 0.61, 1.05) 0s;
        -ms-transition: all 0.3s cubic-bezier(0.37, 0.75, 0.61, 1.05) 0s;
        -o-transition: all 0.3s cubic-bezier(0.37, 0.75, 0.61, 1.05) 0s;
        transition: all 0.3s cubic-bezier(0.37, 0.75, 0.61, 1.05) 0s;
    }
    
    .product-card .card-content .send {
        position: absolute;
        top: -30px;
        right: 10px;
        height: 60px;
        width: 60px;
        background: #2252e3;
        border-radius: 50%;
        cursor: pointer;
        transition: all 1s ease;
        transition-delay: 0.3s;
        opacity: 0;
    }
    
    .card-content:hover .send {
        opacity: 1;
    }
    
    .bi{
    	position: absolute;
   		top: 8px;
        left: 10px;
    	width: 40px;
    	height: 40px;
    	color: white;
    }
    .product-card .card-content .card-title {
        margin: 0;
        padding: 0 0 10px;
        color: #333333;
        font-size: 20px;
        font-weight: 700;
        text-transform: capitalize;
    }
    
    .product-card .card-content .card-sub-title {
        margin: 0;
        padding: 0 0 20px;
        color: #197;
        font-size: 15px;
        font-weight: 400;
        text-transform: capitalize;
    }
    
    .product-card .card-content .description {
        color: #666666;
        font-size: 12px;
        line-height: 1.8em;
        display: none;
        /* height: 0px; */
    }
    
    .product-card .card-content .post-meta {
        margin: 30px 0 0;
        color: #999999;
    }
    
    .product-card .card-content .post-meta .time-stamp {
        margin: 0 80px 0 0;
    }
    
    .product-card .card-content .post-meta a {
        color: inherit;
        text-decoration: none;
    }
    
</style>
</head>
<body>
<jsp:include page="/include/navbar.jsp"></jsp:include>
<a href="private/bookingList.jsp">예약 목록 확인</a>
        <div class="product-container">
            <div class="container">
                <div class="row">
                    <div class="col-sm-4">
                        <div class="product-card">
                            <div class="card-thumbnail">
                            <video class="video" muted="">
       						<source src="https://cdn.videvo.net/videvo_files/video/free/2015-08/small_watermarked/Ao_Nang_Beach_Yoga_MP4_HDV_1080p25__TanuriX_Stock_Footage_NS_preview.webm" type="video/mp4">
      						</video>
                            </div>
                            <div class="card-content">
                                <div class="send"  data-bs-toggle="modal" data-bs-target="#exampleModal" data-class="60분 아쉬탕가">
                                    <svg xmlns="http://www.w3.org/2000/svg"  fill="currentColor" class="bi bi-journal-check" viewBox="0 0 16 16">
  										<path fill-rule="evenodd" d="M10.854 6.146a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708 0l-1.5-1.5a.5.5 0 1 1 .708-.708L7.5 8.793l2.646-2.647a.5.5 0 0 1 .708 0z"/>
  										<path d="M3 0h10a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-1h1v1a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H3a1 1 0 0 0-1 1v1H1V2a2 2 0 0 1 2-2z"/>
  										<path d="M1 5v-.5a.5.5 0 0 1 1 0V5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0V8h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0v.5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1z"/>
									</svg>
                                </div>
                                <h1 class="card-title">
								<strong>60분 아쉬탕가 요가</strong>
								</h1>
                                <h2 class="card-sub-title">
								 구라요가
								</h2>
                                <p class="description">
                                    New York, the largest city in the U.S., is an architectural marvel with plenty of historic monuments, magnificent buildings and countless dazzling skyscrapers.
                                </p>
                                <p>💵80,000<p>
                                <ul class="list-inline post-meta">
                                    <li class="card-comment">
                                        <i class="fa fa-comments"></i><a href="#"> 39 comments</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="product-card">
                            <div class="card-thumbnail">
                             <video class="video" muted="">
       							<source src="https://cdn.videvo.net/videvo_files/video/free/2018-09/small_watermarked/180905_02_08_preview.webm" type="video/mp4">
      						</video>
                            </div>
                            <div class="card-content">
                                <div class="send"  data-bs-toggle="modal" data-bs-target="#exampleModal" data-class="보드타기 클래스">
                                    <svg xmlns="http://www.w3.org/2000/svg"  fill="currentColor" class="bi bi-journal-check" viewBox="0 0 16 16">
  										<path fill-rule="evenodd" d="M10.854 6.146a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708 0l-1.5-1.5a.5.5 0 1 1 .708-.708L7.5 8.793l2.646-2.647a.5.5 0 0 1 .708 0z"/>
  										<path d="M3 0h10a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-1h1v1a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H3a1 1 0 0 0-1 1v1H1V2a2 2 0 0 1 2-2z"/>
  										<path d="M1 5v-.5a.5.5 0 0 1 1 0V5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0V8h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0v.5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1z"/>
									</svg>
                                </div>
                                <h1 class="card-title">
								보드 타기 클래스
							</h1>
                                <h2 class="card-sub-title">
								 Gurafit
							</h2>
                                <p class="description">
                                    New York, the largest city in the U.S., is an architectural marvel with plenty of historic monuments, magnificent buildings and countless dazzling skyscrapers.
                                </p>
                                <p>💵120,000</p>
                                <ul class="list-inline post-meta">                                 
                                    <li class="card-comment">
                                        <i class="fa fa-comments"></i><a href="#"> 39 comments</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="product-card">
                            <div class="card-thumbnail">
                             <video class="video" muted="">
       							<source src="https://cdn.videvo.net/videvo_files/video/free/2018-05/small_watermarked/180419_Boxing_15_10_preview.webm" type="video/mp4">
      						</video>
                            </div>
                            <div class="card-content">
                                 <div class="send"  data-bs-toggle="modal" data-bs-target="#exampleModal" data-class="1:1 PT">
                                    <svg xmlns="http://www.w3.org/2000/svg"  fill="currentColor" class="bi bi-journal-check" viewBox="0 0 16 16">
  										<path fill-rule="evenodd" d="M10.854 6.146a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708 0l-1.5-1.5a.5.5 0 1 1 .708-.708L7.5 8.793l2.646-2.647a.5.5 0 0 1 .708 0z"/>
  										<path d="M3 0h10a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-1h1v1a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H3a1 1 0 0 0-1 1v1H1V2a2 2 0 0 1 2-2z"/>
  										<path d="M1 5v-.5a.5.5 0 0 1 1 0V5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0V8h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0v.5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1z"/>
									</svg>
                                </div>
                                <h1 class="card-title">
								1:1 PT
							</h1>
                                <h2 class="card-sub-title">
								 구라블리 
							</h2>
                                <p class="description">
                                    New York, the largest city in the U.S., is an architectural marvel with plenty of historic monuments, magnificent buildings and countless dazzling skyscrapers.
                                </p>
                                <p>💵150,000</p>
                                <ul class="list-inline post-meta">                               
                                    <li class="card-comment">
                                        <i class="fa fa-comments"></i><a href="#"> 39 comments</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="product-card">
                            <div class="card-thumbnail">
							<video class="video" muted="">
       							<source src="https://cdn.videvo.net/videvo_files/video/free/2018-09/small_watermarked/180419_Boxing_05_01_preview.webm" type="video/mp4">
      						</video>
                            </div>
                            <div class="card-content">
                                 <div class="send"  data-bs-toggle="modal" data-bs-target="#exampleModal" data-class="30분 런닝">
                                    <svg xmlns="http://www.w3.org/2000/svg"  fill="currentColor" class="bi bi-journal-check" viewBox="0 0 16 16">
  										<path fill-rule="evenodd" d="M10.854 6.146a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708 0l-1.5-1.5a.5.5 0 1 1 .708-.708L7.5 8.793l2.646-2.647a.5.5 0 0 1 .708 0z"/>
  										<path d="M3 0h10a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-1h1v1a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H3a1 1 0 0 0-1 1v1H1V2a2 2 0 0 1 2-2z"/>
  										<path d="M1 5v-.5a.5.5 0 0 1 1 0V5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0V8h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0v.5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1z"/>
									</svg>
                                </div>
                                <h1 class="card-title">
								30분 런닝
								</h1>
                                <h2 class="card-sub-title">
								 구라으뜸 
								</h2>
                                <p class="description">
                                    New York, the largest city in the U.S., is an architectural marvel with plenty of historic monuments, magnificent buildings and countless dazzling skyscrapers.
                                </p>
                                <p>💵30,000</p>
                                <ul class="list-inline post-meta">
                                    <li class="card-comment">
                                        <i class="fa fa-comments"></i><a href="#"> 39 comments</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="product-card">
                            <div class="card-thumbnail">
                             <video class="video" muted="">
       							<source src="https://cdn.videvo.net/videvo_files/video/free/2021-04/small_watermarked/210329_01B_Bali_1080p_014_preview.webm" type="video/mp4">
      						</video>
                            </div>
                            <div class="card-content">
                                 <div class="send"  data-bs-toggle="modal" data-bs-target="#exampleModal" data-class="초보자를 위한 서핑">
                                    <svg xmlns="http://www.w3.org/2000/svg"  fill="currentColor" class="bi bi-journal-check" viewBox="0 0 16 16">
  										<path fill-rule="evenodd" d="M10.854 6.146a.5.5 0 0 1 0 .708l-3 3a.5.5 0 0 1-.708 0l-1.5-1.5a.5.5 0 1 1 .708-.708L7.5 8.793l2.646-2.647a.5.5 0 0 1 .708 0z"/>
  										<path d="M3 0h10a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-1h1v1a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H3a1 1 0 0 0-1 1v1H1V2a2 2 0 0 1 2-2z"/>
  										<path d="M1 5v-.5a.5.5 0 0 1 1 0V5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0V8h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0v.5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1z"/>
									</svg>
                                </div>
                                <h1 class="card-title">
								초보자를 위한 서핑
							</h1>
                                <h2 class="card-sub-title">
								 Gurara
							</h2>
                                <p class="description">
                                    New York, the largest city in the U.S., is an architectural marvel with plenty of historic monuments, magnificent buildings and countless dazzling skyscrapers.
                                </p>
                                <p>Price $62</p>
                                <ul class="list-inline post-meta">
                                    <li class="card-comment">
                                        <i class="fa fa-comments"></i><a href="#"> 39 comments</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
<!-- modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">클래스 예약하기</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
				<div class="modal-body">
					<form action="${pageContext.request.contextPath}/oneday_class/private/booking.jsp" method="get" id="submitForm">
						<div class="mb-3">
							<label for="className" class="col-form-label">클래스명</label> 
							<input type="text" class="form-control" name="className" id="className" />
						</div>
						<div class="mb-3">
							<label for="name" class="col-form-label">이름</label> 
							<input type="text" class="form-control" name="name" id="name">
						</div>
						<div class="mb-3">
							<label for="phone" class="col-form-label">번호</label>
							 <input type="text" class="form-control" name="phone" id="phone" placeholder="010-1234-5678">
						</div>
						<div class="mb-3">
							<label for="date" class="col-form-label">신청 날짜</label> 
							<input type="date" class="form-control" name="date" id="date" />
						</div>
						<div class="mb-3">
							<label for="mention" class="col-form-label">기타</label> 
							<input type="text" class="form-control" name="mention" id="mention" />
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">닫기</button>
							<button type="submit" class="btn btn-primary">예약하기</button>
						</div>
					</form>
				</div>
			</div>
  </div>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script>

classNameSend(".send");
function classNameSend(sel) {
	//댓글 수정 링크의 참조값을 배열에 담아오기 
	// sel 은  ".page-xxx  .update-link" 형식의 내용이다 
	let classNames = document.querySelectorAll(sel);
	for (let i = 0; i < classNames.length; i++) {
		
		classNames[i].addEventListener("click", function() {
			//click 이벤트가 일어난 바로 그 요소의 data-num 속성의 value 값을 읽어온다. 
			const className = this.getAttribute("data-class");
			document.querySelector("#className").value = className;
		});
		
	}
}

$(function(){
	$('.card-content').hover(function() {
	   $(this).find('.description').animate({
	     height: "toggle",
	     opacity: "toggle"
	   }, 300);
	 });
});

const videos = document.querySelectorAll(".video");
	for(let i=0; i<videos.length; i++){
		videos[i].addEventListener("mouseover",function(){
			this.play();	
		});	
		
		videos[i].addEventListener("mouseleave", function(){
			this.currentTime=0;
			this.pause();
		});
	}

</script>
</body>
</html>