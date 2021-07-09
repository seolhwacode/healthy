<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%-- include 폴더 : jsp 에 추가할  다른 파일들 모아두기--%>
<%-- 하나의 파일만 수정하면 되기 때문에, 편리하다. --%>

<%-- bootstrap include --%>
<%-- bootstrap 5.0 css 로딩하기 --%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-+0n0xVW2eSR5OomGNYDnhzAbDsOXxcvSN1TPprVMTNDbiYZCxYbOOl7+AMvyTG2x" crossorigin="anonymous">
<%-- bootstrap 5.0 javascript 로딩하기 --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.1/dist/js/bootstrap.bundle.min.js" integrity="sha384-gtEjrD/SeCtmISkJkNUaaKMoLD0//ElJ19smozuHV6z3Iehds+3Ulb9Bn9Plx0x4" crossorigin="anonymous"></script>

<!-- 파비콘 이미지 업로드 -->
<link rel="icon" 
   href="${pageContext.request.contextPath}/image/health.png" 
   type="image/x-icon" />