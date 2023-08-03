<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" href="${ctp}/css/admin.css">
<script src="${ctp}/js/admin/admin.js"></script>
<link rel="icon" href="${ctp}/images/favicon.ico">
<!-- Google Web Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com">
<link
	href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700&display=swap"
	rel="stylesheet">

<script>
	$(document).ready(function() {
		let sNowAdminPage = "${sNowAdminPage}";
		if (sNowAdminPage == 'main') {
			$("#nav-dash").addClass("active");
		} else if (sNowAdminPage == 'product') {
			$("#nav-product").addClass("active");
		} else if (sNowAdminPage == 'order') {
			$("#nav-order").addClass("active");
		} else if (sNowAdminPage == 'coupon') {
			$("#nav-coupon").addClass("active");
		} else if (sNowAdminPage == 'member') {
			$("#nav-member").addClass("active");
		} else if (sNowAdminPage == 'question') {
			$("#nav-question").addClass("active");
		} else if (sNowAdminPage == 'announce') {
			$("#nav-announce").addClass("active");
		} else if (sNowAdminPage == 'statics') {
			$("#nav-statics").addClass("active");
		}
	});
</script>

<!-- Sidebar Start -->
<div class="sidebar pe-4 pb-3 bg-dark">
	<nav class="navbar bg-dark navbar-light">
		<a href="${ctp}/admin/adminMain" class="navbar-brand mx-4 mb-3">
			<h3 style="color: red">
				<a href="${ctp}/">PARADICE</a>
			</h3>
		</a>
		<div class="navbar-nav w-100">
			<a href="${ctp}/admin/adminMain" class="nav-item nav-link"
				id="nav-dash"><i class="fa fa-tachometer-alt me-2"></i>대시보드</a>
			<div class="nav-item dropdown">
				<a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown"
					id="nav-product"><i class="fa fa-laptop me-2"></i>상품 관리</a>
				<div class="dropdown-menu bg-transparent border-0">
					<a href="${ctp}/admin/product/productCategory"
						class="dropdown-item">상품 카테고리 관리</a> <a
						href="${ctp}/admin/product/productInsert" class="dropdown-item">상품
						등록</a> <a href="${ctp}/admin/product/productList"
						class="dropdown-item">상품 조회/수정/삭제</a>
				</div>
			</div>

			<div class="nav-item dropdown">
				<a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown"
					id="nav-order"><i class="fa fa-th me-2"></i>주문 관리</a>
				<div class="dropdown-menu bg-transparent border-0">
					<a href="${ctp}/admin/order/orderList" class="dropdown-item">전체
						주문 조회</a> <a href="${ctp}/admin/order/cancelList"
						class="dropdown-item">교환/반품/취소 관리</a> <a
						href="${ctp}/admin/order/deliveryList" class="dropdown-item">운송장
						번호 등록</a>
				</div>
			</div>

			<div class="nav-item dropdown">
				<a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown"
					id="nav-member"><i class="fa fa-user me-2"></i>회원 관리</a>
				<div class="dropdown-menu bg-transparent border-0">
					<a href="${ctp}/admin/member/memberList" class="dropdown-item">전체
						회원 조회</a>
				</div>
			</div>

			<div class="nav-item dropdown">
				<a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown"
					id="nav-coupon"><i class="fas fa-coins"></i>쿠폰/적립금 관리</a>
				<div class="dropdown-menu bg-transparent border-0">
					<a href="${ctp}/admin/coupon" class="dropdown-item">쿠폰 조회/등록/삭제</a>
					<a href="${ctp}/admin/coupon/memberCoupon" class="dropdown-item">회원
						보유 쿠폰 조회</a>
				</div>
			</div>

			<div class="nav-item dropdown">
				<a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown"
					id="nav-question"><i class="fas fa-question"></i>문의 관리</a>
				<div class="dropdown-menu bg-transparent border-0">
					<a href="${ctp}/admin/inquiry/QnA" class="dropdown-item">Q&A
						조회/등록</a> <a href="${ctp}/admin/inquiry/1to1Inquiry"
						class="dropdown-item">1:1 문의 조회</a>
				</div>
			</div>

			<!-- 이곳에서 쇼핑몰 메인에 대해 전반적인 제품 수정이 가능 -->

			<a href="${ctp}/admin/announceList" class="nav-item nav-link"
				id="nav-announce"><i class="fa fa-pen me-2"></i>공지 등록</a>
			<!-- <a href="#" class="nav-item nav-link"><i class="fa fa-table me-2"></i>디자인 관리</a> -->
			<a href="${ctp}/admin/statistics" class="nav-item nav-link"><i
				class="fa fa-chart-bar me-2"></i>통계</a>
			<div class="nav-item dropdown">
				<a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown"
					id="nav-statics"><i class="far fa-file-alt me-2"></i>Pages</a>
				<div class="dropdown-menu bg-transparent border-0">
					<a href="signin.html" class="dropdown-item">Sign In</a> <a
						href="signup.html" class="dropdown-item">Sign Up</a> <a
						href="404.html" class="dropdown-item">404 Error</a> <a
						href="blank.html" class="dropdown-item">Blank Page</a>
				</div>
			</div>
		</div>
	</nav>
</div>
<!-- Sidebar End -->


<!-- Content Start -->
<div class="content" style="background-color: #eee;">
	<!-- Navbar Start -->
	<nav
		class="navbar navbar-expand bg-white navbar-light sticky-top px-4 py-0"
		style="display: flex; justify-content: space-between; align-itmes: center; border-bottom: 1px solid #ccc;">
		<div style="display: flex;">
			<a href="${ctp}/admin/adminMain"
				class="navbar-brand d-flex d-lg-none me-4">
				<h2 class="text-primary mb-0">
					<i class="fa fa-hashtag"></i>
				</h2>
			</a> <a href="#" class="sidebar-toggler flex-shrink-0" style="color: red">
				<i class="fa fa-bars"></i>
			</a>
		</div>
		<div class="navbar-nav align-items-center ms-auto">
			<div class="nav-item dropdown">
				<a href="#" class="nav-link dropdown-toggle" data-toggle="dropdown">
					<span class="d-none d-lg-inline-flex">Admin</span>
				</a>
				<div
					class="dropdown-menu dropdown-menu-end bg-light border-0 rounded-0 rounded-bottom m-0">
					<a href="#" class="dropdown-item">설정</a> <a href="#"
						class="dropdown-item">로그아웃</a>
				</div>
			</div>
		</div>
	</nav>
	<!-- Navbar End -->