<%@ page language="java" contentType="text/html; charset=utf-8"	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" href="${ctp}/css/nav.css">
<link rel="icon" href="${ctp}/images/favicon.ico">
<script>
	'use strict';
	// Scrolling Effect
			$('.back-to-top').click(function() {
				$('html, body').animate({ scrollTop: 0 }, 1500, 'easeInOutExpo');
				return false;
			});

		$(document).ready(function(){
			$("#toggleOpenBtn").on("mouseover", function(){
				$('#nav-category2').css('display', 'block');
				$('#nav-category2').css('transition','0.3s');
			});
			$("#nav-category2").on("mouseleave", function(){
				$('#nav-category2').css('display', 'none');
				$('#nav-category2').css('transition','0.3s');
			});
			
		});
		$(".menu-icon").on("click", function() {
			$("nav ul").toggleClass("showing");
		});
	$(window).on("scroll", function() {
		if ($(window).scrollTop()) {
			$('nav ul').css('color','white');
			$('.logo').css('color','white');
			$('#nav-category').css('transform','translateY(-30px)');
			$('#nav-category').css('background','black');
			$('#nav-category').css('transition','0.3s');
			$('#nav-category2').css('transform','translateY(-30px)');
			$('#nav-category2').css('background','black');
			$(".searchBox").addClass("boxblack");
		}

		else {
			$('nav ul').css('color','black');
			$('.logo').css('color','black');
			$('#nav-category').css('transform','translateY(0px)');
			$('#nav-category').css('background','white');
			$('#nav-category').css('border-bottom','1px solid #aaa');
			$('#nav-category').css('transition','0.3s');
			$('#nav-category2').css('transform','translateY(0px)');
			$('#nav-category2').css('transition','0.3s');
			$('#nav-category2').css('background','white');
			$(".searchBox").removeClass("boxblack");
		}
	});
	
	function openBtn(){
		$('#nav-category2').css('display', 'block');
		$('#nav-category2').css('transition','0.3s');
	}
	
	//로그아웃
	function logout(){
			Swal.fire({
				  title: '로그아웃 하시겠습니까?',
				  showDenyButton: true,
				  confirmButtonColor: 'grey',
				  confirmButtonText: '확인',
				  denyButtonText: '취소',
				}).then((result) => {
				  if (result.isConfirmed) {
				    $.ajax({
				    	type: "post",
							url: "${ctp}/member/memberLogout",
							success: function(res){
							if(res=="1"){
								Swal.fire({
									width:500,
								  position: 'center',
								  icon: 'success',
								  title: '로그아웃 되었습니다!',
								  showConfirmButton: false,
								  timer: 1500
								})
								setTimeout(function(){location.href="${ctp}/";},1500);
							}
						}
				    });
				  }
				})
		}
	
	function enterkey(){
		if(window.event.keyCode == 13){
			location.href = '${ctp}/product/productSearch?searchKeyword='+$("#search").val();
		}
	}
	
</script>
<jsp:include page="/WEB-INF/views/member/memberLogin.jsp" />
<div class="wrapper" id="wrap">
	<header>
		<nav id="nav-category">
		<div class="container">
		<div id="nav-top">
			<ul id="nav-top-ul" style="height:30px; line-height: 0px;">
				<!-- 관리자 전용 메뉴 -->
				<c:if test="${sLevel == 0}">
					<li><a href="${ctp}/admin/adminMain"><font color="red">관리자</font></a></li>
				</c:if>
				<c:if test="${empty sLevel}">
				<!-- 비회원 전용 메뉴 -->
					<li><a data-toggle="modal" data-target="#loginModal" >로그인</a></li>
					<li><a href="${ctp}/member/memberJoinTerm">회원가입</a></li>
				</c:if>
				<!-- 회원 전용 메뉴 -->
				<c:if test="${!empty sLevel}">
					<li><a href="javascript:logout()">로그아웃</a></li>
					<li><a href="${ctp}/member/myPage">마이 페이지</a></li>
					<li><a href="${ctp}/order/orderCart">
					장바구니
					<font color="red">
					(<c:if test="${cartCnt == null}">0</c:if><c:if test="${cartCnt != null}">${cartCnt}</c:if>)
					</font></a></li>
				</c:if>
			</ul>
		</div></div>
		<div class="container">
			<div class="logo">
				<a href="${ctp}/">PARA<font color="red">DICE</font></a>
			</div>
			<div class="nav-menu">
			<div>
				<div>
				<ul id="nav-menu-ul">
					<li class="nav-li" id="toggleOpenBtn" onmouseover="openBtn()"><i class="fas fa-bars"></i>전체</li>
					<li class="nav-li"><a href="${ctp}/product/productList?mainCode=A">보드게임</a></li>
					<li class="nav-li"><a href="${ctp}/product/productList?mainCode=C">퍼즐</a></li>
					<li class="nav-li"><a href="${ctp}/product/productList?mainCode=D">전략</a></li>
					<li class="nav-li"><a href="${ctp}/notice">공지사항</a></li>
				</ul>
				
				<div class="pb-2 search">
					<i class="fas fa-search searchBtn"></i>
					<input type="text" id="search" name="search" onkeyup="enterkey()" class="searchbox rounded-pill" placeholder="검색어 입력">
				</div>
				</div>
			</div>
			</div></div>
		</nav>
		
		<nav id="nav-category2">
		<div class="container">
			<div class="nav-menu">
			<div id="cateogry">
			<c:forEach var="main" items="${mainCategory}"> 
				<ul id="nav-menu-ul">
					<li class="nav-li border-bottom font-16"><b>${main.c_mainName}</b></li>
					<c:forEach var="middle" items="${middleCategory}">
					<c:if test="${middle.c_mainCode ==  main.c_mainCode}">
						<li class="nav-li"><a href="${ctp}/product/productList?mainCode=${main.c_mainCode}&middleCode=${middle.c_middleCode}">${middle.c_middleName}</a></li>
					</c:if>
					</c:forEach>
					
				</ul>
			</c:forEach>
				
				</div>
			</div>
			</div>
		</nav>
		
		
	</header>
</div>

