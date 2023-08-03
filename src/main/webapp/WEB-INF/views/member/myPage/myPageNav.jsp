<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<link rel="icon" href="${ctp}/images/favicon.ico">
<link rel="stylesheet" href="${ctp}/css/mypage.css">
<script src="${ctp}/js/admin/admin.js"></script>
<!-- Google Web Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link
	href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700&display=swap"
	rel="stylesheet">

<script>
	
</script>

<!-- Sidebar Start -->
<div class="sidebar p-3">
	<nav class="navbar">
		<div class="navbar-nav w-100">
			<h2>
				<b><a href="${ctp}/member/myPage">마이페이지</a></b>
			</h2>
			<div class="nav-item dropdown">
				<a href="#" class="nav-link dropdown-toggle m-2 red"
					data-toggle="dropdown" id="nav-product">쇼핑정보</a>
				<div class="dropdown-menu bg-transparent border-0 show">
					<a href="${ctp}/member/myOrderList" class="dropdown-item">주문내역</a>
					<a href="${ctp}/member/myCart" class="dropdown-item">장바구니</a> <a
						href="${ctp}/member/myWishList" class="dropdown-item">위시리스트</a>
				</div>
			</div>

			<div class="nav-item dropdown">
				<a href="#" class="nav-link dropdown-toggle m-2 red"
					data-toggle="dropdown" id="nav-product">혜택관리</a>
				<div class="dropdown-menu bg-transparent border-0 show">
					<a href="${ctp}/member/myCouponList" class="dropdown-item">쿠폰</a> <a
						href="${ctp}/member/myPointList" class="dropdown-item">적립금</a>
				</div>
			</div>

			<div class="nav-item dropdown">
				<a href="#" class="nav-link dropdown-toggle m-2 red"
					data-toggle="dropdown" id="nav-product">활동관리</a>
				<div class="dropdown-menu bg-transparent border-0 show">
					<a href="${ctp}/member/myInquiryList" class="dropdown-item">1:1
						문의</a> <a href="${ctp}/member/myQnAList" class="dropdown-item">상품
						문의</a> <a href="${ctp}/member/myReviewList" class="dropdown-item">상품
						후기</a>
				</div>
			</div>


			<div class="nav-item d-block">
				<a href="#" class="nav-link dropdown-toggle m-2 red"
					data-toggle="dropdown" id="nav-product">정보관리</a>
				<div class="dropdown-menu border-0 show">
					<a href="${ctp}/member/updateInfo" class="dropdown-item">정보 수정</a>
					<a href="${ctp}/member/memberDelete" class="dropdown-item">회원
						탈퇴</a>
				</div>
			</div>

		</div>
	</nav>
</div>
<!-- Sidebar End -->


<!-- Content Start -->
<div class="content">
	<!-- Navbar Start -->