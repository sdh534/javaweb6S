<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>PARADICE | 관리자</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="" name="keywords">
<meta content="" name="description">
<!-- Favicon -->
<link rel="icon" href="${ctp}/images/favicon.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script>
	'use strict'
	$(document)
			.ready(
					function() {
						// 카테고리별 차트
						var categoryLabel = [];
						var categoryData = [];
						var ctx1 = $("#category-result");
						$.ajax({
							url : "${ctp}/admin/getCategoryData",
							method : "POST",
							dataType : "JSON",
							success : function(vos) {
								for (let i = 0; i < vos.length; i++) {
									categoryLabel.push(vos[i].label);
									categoryData.push(vos[i].data);
								}

								var myChart1 = new Chart(ctx1, {
									type : "doughnut",
									data : {
										labels : categoryLabel,
										datasets : [ {
											label : '카테고리',
											data : categoryData,
											hoverOffset : 4
										} ]
									},
									options : {
										responsive : false
									}
								});
							}
						});
						//---------------------------------------------
						//주문 취소 교환 반품 통계 
						var refundLabel = [];
						var refundData = [];
						var ctx3 = $("#refund-result");
						$.ajax({
							url : "${ctp}/admin/refundCategory",
							method : "POST",
							dataType : "JSON",
							success : function(vos) {
								for (let i = 0; i < vos.length; i++) {
									refundLabel.push(vos[i].label);
									refundData.push(vos[i].data);
								}

								var myChart1 = new Chart(ctx3, {
									type : "pie",
									data : {
										labels : refundLabel,
										datasets : [ {
											label : '카테고리',
											data : refundData,
											hoverOffset : 4
										} ]
									},
									options : {
										responsive : false
									}
								});
							}
						});
						//---------------------------------------------
						//매출 통계
						var totalPriceLabel = [];
						var totalPriceData = [];
						$
								.ajax({
									url : "${ctp}/admin/order/monthTotalPrice",
									method : "POST",
									success : function(vos) {
										// Worldwide Sales Chart
										let ctx = $("#totalPrice-result");
										for (let i = 0; i < vos.length; i++) {
											totalPriceLabel.push(vos[i].label);
											totalPriceData.push(vos[i].data);
										}

										var myChart2 = new Chart(
												ctx,
												{
													plugins : [ ChartDataLabels ],
													type : "line",
													data : {
														labels : totalPriceLabel,
														datasets : [ {
															label : "매출액",
															data : totalPriceData,
															backgroundColor : "rgba(255, 0, 0, .4)",
															fill : true
														} ]
													},
													options : {
														responsive : false,
														tension : 0.3,
														plugins : {
															datalabels : {
																formatter : function(
																		value,
																		context) {
																	let result = value
																			.toString()
																			.replace(
																					/\B(?=(\d{3})+(?!\d))/g,
																					',');
																	return result
																			+ '원'
																}
															}
														}
													}
												});

									}
								});
						//---------------------------------------------
						//회원 구매순위
						var memberRankLabel = [];
						var memberRankData = [];
						$
								.ajax({
									url : "${ctp}/admin/memberRank",
									method : "POST",
									success : function(vos) {
										// Worldwide Sales Chart
										let ctx4 = $("#memberRank-result");
										for (let i = 0; i < vos.length; i++) {
											memberRankLabel.push(vos[i].label);
											memberRankData.push(vos[i].data);
										}

										var myChart2 = new Chart(
												ctx4,
												{
													plugins : [ ChartDataLabels ],
													type : "bar",
													data : {
														labels : memberRankLabel,
														datasets : [ {
															label : "구매총액",
															data : memberRankData,
															backgroundColor : "rgba(255, 0, 0, .4)",
															fill : true
														} ]
													}
												});

									}
								});
						//---------------------------------------------
						//등급별 회원 수 
						var memberLevelCntLabel = [];
						var memberLevelCntData = [];
						$
								.ajax({
									url : "${ctp}/admin/memberLevelCnt",
									method : "POST",
									success : function(vos) {
										// Worldwide Sales Chart
										let ctx5 = $("#memberLevel-result");
										for (let i = 0; i < vos.length; i++) {
											memberLevelCntLabel
													.push(vos[i].label);
											memberLevelCntData
													.push(vos[i].data);
										}

										var myChart2 = new Chart(
												ctx5,
												{
													plugins : [ ChartDataLabels ],
													type : "bar",
													data : {
														labels : memberLevelCntLabel,
														datasets : [ {
															label : "회원 수",
															data : memberLevelCntData,
															backgroundColor : "rgba(255, 0, 0, .4)",
															fill : true
														} ]
													}
												});

									}
								});

					});
</script>
</head>

<body>
	<div class="container-xxl position-relative bg-white d-flex p-0">
		<!-- Spinner Start -->
		<div id="spinner"
			class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
			<div class="spinner-border text-danger"
				style="width: 3rem; height: 3rem;" role="status">
				<span class="sr-only">Loading...</span>
			</div>
		</div>
		<!-- Spinner End -->

		<jsp:include page="/WEB-INF/views/admin/adminNav.jsp" />


		<!-- Sales Chart Start -->
		<div class="container-fluid pt-4 px-4">
			<div class="row g-4">
				<div class="col-sm-12 col-xl-12">
					<div class="bg-light text-center rounded p-4">
						<div
							class="d-flex align-items-center justify-content-between mb-4">
							<h6 class="mb-0">월간 매출액</h6>
						</div>
						<canvas id="totalPrice-result" style="height: 300px; width: 100%"></canvas>
					</div>
				</div>
			</div>
		</div>
		<div class="container-fluid pt-4 px-4">
			<div class="row g-4"></div>
		</div>
		<div class="container-fluid pt-4 px-4">
			<div class="row g-4">
				<div class="col-sm-12 col-xl-6">
					<div class="bg-light text-center rounded p-4">
						<div
							class="d-flex align-items-center justify-content-between mb-4">
							<h6 class="mb-0">카테고리별 주문 현황</h6>
						</div>
						<canvas id="category-result" style="height: 300px; width: 100%"></canvas>
					</div>
				</div>
				<div class="col-sm-12 col-xl-6">
					<div class="bg-light text-center rounded p-4">
						<div
							class="d-flex align-items-center justify-content-between mb-4">
							<h6 class="mb-0">주문 취소/교환/반품 사유</h6>
						</div>
						<canvas id="refund-result" style="height: 300px; width: 100%"></canvas>
					</div>
				</div>
			</div>
		</div>
		<div class="container-fluid pt-4 px-4">
			<div class="row g-4">
				<div class="col-sm-12 col-xl-6">
					<div class="bg-light text-center rounded p-4">
						<div
							class="d-flex align-items-center justify-content-between mb-4">
							<h6 class="mb-0">회원 구매 순위</h6>
						</div>
						<canvas id="memberRank-result" style="height: 235px; width: 100%"></canvas>
					</div>
				</div>
				<div class="col-sm-12 col-xl-6">
					<div class="bg-light text-center rounded p-4">
						<div
							class="d-flex align-items-center justify-content-between mb-4">
							<h6 class="mb-0">등급별 회원 수</h6>
						</div>
						<canvas id="memberLevel-result" style="height: 235px; width: 100%"></canvas>
					</div>
				</div>
			</div>
		</div>






		<!-- Footer Start -->
		<div class="container-fluid pt-4 px-4">
			<div class="bg-light rounded-top p-4">
				<div class="row">
					<div class="col-12 col-sm-6 text-center text-sm-start">
						&copy; <a href="#">Your Site Name</a>, All Right Reserved.
					</div>
					<div class="col-12 col-sm-6 text-center text-sm-end">
						<!--/*** This template is free as long as you keep the footer authorâs credit link/attribution link/backlink. If you'd like to use the template without the footer authorâs credit link/attribution link/backlink, you can purchase the Credit Removal License from "https://htmlcodex.com/credit-removal". Thank you for your support. ***/-->
						Designed By <a href="https://htmlcodex.com">HTML Codex</a> </br>
						Distributed By <a class="border-bottom"
							href="https://themewagon.com" target="_blank">ThemeWagon</a>
					</div>
				</div>
			</div>
		</div>
		<!-- Footer End -->
	</div>
	<!-- Content End -->


	<!-- Back to Top -->
	<a href="#" class="btn btn-lg btn-danger btn-lg-square back-to-top"><i
		class="bi bi-arrow-up"></i></a>
	</div>


</body>

</html>