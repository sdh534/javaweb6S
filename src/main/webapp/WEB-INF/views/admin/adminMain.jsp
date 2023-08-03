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
						var totalPriceLabel = [];
						var totalPriceData = [];
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
						//최근 판매내역 
						$
								.ajax({
									url : "${ctp}/admin/order/allOrderList",
									method : "POST",
									success : function(vos) {
										console.log(vos);
										let str = "";
										for (let i = 0; i < vos.length; i++) {
											str = str
													+ "<tr>"
													+ "<td>"
													+ vos[i].o_date
													+ "</td>"
													+ "<td>"
													+ vos[i].o_orderCode
													+ "</td>"
													+ "<td>"
													+ vos[i].m_mid
													+ "</td>"
													+ "<td>"
													+ vos[i].totalPrice
													+ "원</td>"
													+ "<td>"
													+ vos[i].o_status
													+ "</td>"
													+ "<td><a class='btn btn-sm btn-danger' href='${ctp}/admin/'>Detail</a></td>"
													+ "</tr>";
											if (i == 5)
												break;
										}
										document.querySelector("#recentOrder")
												.insertAdjacentHTML(
														'afterbegin', str);
									}
								});
						//--------------------------------------------
						//매출 통계
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

		<!-- 문의사항 줄 Start -->
		<div class="container-fluid pt-4 px-4">
			<div class="row g-4">
				<div class="col-sm-6 col-xl-3"
					onclick='location.href="${ctp}/admin/inquiry/1to1Inquiry"'>
					<div
						class="bg-light rounded d-flex align-items-center justify-content-between p-4  pointerBig">
						<i class="fas fa-user-check fa-3x text-danger"></i>
						<div class="ms-3">
							<p class="mb-2">미답변 1:1</p>
							<h6 class="mb-0">${inqTotal}건</h6>
						</div>
					</div>
				</div>
				<div class="col-sm-6 col-xl-3"
					onclick='location.href="${ctp}/admin/inquiry/QnA"'>
					<div
						class="bg-light rounded d-flex align-items-center justify-content-between p-4  pointerBig">
						<i class="fa fa-question fa-3x text-danger"></i>
						<div class="ms-3">
							<p class="mb-2">미답변 Q&A</p>
							<h6 class="mb-0">${qnaTotal}건</h6>
						</div>
					</div>
				</div>
				<div class="col-sm-6 col-xl-3"
					onclick='location.href="${ctp}/admin/order/orderList"'>
					<div
						class="bg-light rounded d-flex align-items-center justify-content-between p-4  pointerBig">
						<i class="fa fa-chart-area fa-3x text-danger"></i>
						<div class="ms-3">
							<p class="mb-2">배송대기</p>
							<h6 class="mb-0">${deliveryTotal}건</h6>
						</div>
					</div>
				</div>
				<div class="col-sm-6 col-xl-3"
					onclick='location.href="${ctp}/admin/order/cancelList"'>
					<div
						class="bg-light rounded d-flex align-items-center justify-content-between p-4  pointerBig">
						<i class="fa fa-chart-pie fa-3x text-danger"></i>
						<div class="ms-3">
							<p class="mb-2">CS 요청</p>
							<h6 class="mb-0">${csTotal}건</h6>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- Sale & Revenue End -->


		<!-- Sales Chart Start -->
		<div class="container-fluid pt-4 px-4">
			<div class="row g-4">
				<div class="col-sm-12 col-xl-6">
					<div class="bg-light text-center rounded p-4">
						<div
							class="d-flex align-items-center justify-content-between mb-4">
							<h6 class="mb-0">카테고리별 주문 현황</h6>
							<a href="${ctp}/admin/statistics">Show All</a>
						</div>
						<canvas id="category-result" style="height: 235px; width: 470px;"></canvas>
					</div>
				</div>
				<div class="col-sm-12 col-xl-6">
					<div class="bg-light text-center rounded p-4">
						<div
							class="d-flex align-items-center justify-content-between mb-4">
							<h6 class="mb-0">월간 매출액</h6>
							<a href="${ctp}/admin/statistics">Show All</a>
						</div>
						<canvas id="totalPrice-result"
							style="height: 235px; width: 470px;"></canvas>
					</div>
				</div>
			</div>
		</div>
		<!-- Sales Chart End -->





		<!-- Recent Sales Start -->
		<div class="container-fluid pt-4 px-4">
			<div class="bg-light text-center rounded p-4">
				<div class="d-flex align-items-center justify-content-between mb-4">
					<h6 class="mb-0">최근 판매 내역</h6>
					<a href="${ctp}/admin/order/orderList">주문관리 이동</a>
				</div>
				<div class="table-responsive">
					<table
						class="table text-start align-middle table-bordered table-hover mb-0">
						<thead>
							<tr class="text-dark">
								<th scope="col">주문일자</th>
								<th scope="col">주문코드</th>
								<th scope="col">주문자ID</th>
								<th scope="col">결제금액</th>
								<th scope="col">처리상태</th>
								<th scope="col">상세</th>
							</tr>
						</thead>
						<tbody id="recentOrder">

						</tbody>
					</table>
				</div>
			</div>
		</div>
		<!-- Recent Sales End -->


		<!-- Widgets Start -->
		<!-- <div class="container-fluid pt-4 px-4">
                <div class="row g-4">
                    <div class="col-sm-12 col-md-6 col-xl-4">
                        <div class="h-100 bg-light rounded p-4">
                            <div class="d-flex align-items-center justify-content-between mb-2">
                                <h6 class="mb-0">Messages</h6>
                                <a href="">Show All</a>
                            </div>
                            <div class="d-flex align-items-center border-bottom py-3">
                                <img class="rounded-circle flex-shrink-0" src="img/user.jpg" alt="" style="width: 40px; height: 40px;">
                                <div class="w-100 ms-3">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h6 class="mb-0">Jhon Doe</h6>
                                        <small>15 minutes ago</small>
                                    </div>
                                    <span>Short message goes here...</span>
                                </div>
                            </div>
                            <div class="d-flex align-items-center border-bottom py-3">
                                <img class="rounded-circle flex-shrink-0" src="img/user.jpg" alt="" style="width: 40px; height: 40px;">
                                <div class="w-100 ms-3">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h6 class="mb-0">Jhon Doe</h6>
                                        <small>15 minutes ago</small>
                                    </div>
                                    <span>Short message goes here...</span>
                                </div>
                            </div>
                            <div class="d-flex align-items-center border-bottom py-3">
                                <img class="rounded-circle flex-shrink-0" src="img/user.jpg" alt="" style="width: 40px; height: 40px;">
                                <div class="w-100 ms-3">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h6 class="mb-0">Jhon Doe</h6>
                                        <small>15 minutes ago</small>
                                    </div>
                                    <span>Short message goes here...</span>
                                </div>
                            </div>
                            <div class="d-flex align-items-center pt-3">
                                <img class="rounded-circle flex-shrink-0" src="img/user.jpg" alt="" style="width: 40px; height: 40px;">
                                <div class="w-100 ms-3">
                                    <div class="d-flex w-100 justify-content-between">
                                        <h6 class="mb-0">Jhon Doe</h6>
                                        <small>15 minutes ago</small>
                                    </div>
                                    <span>Short message goes here...</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-12 col-md-6 col-xl-4">
                        <div class="h-100 bg-light rounded p-4">
                            <div class="d-flex align-items-center justify-content-between mb-4">
                                <h6 class="mb-0">Calender</h6>
                                <a href="">Show All</a>
                            </div>
                            <div id="calender"></div>
                        </div>
                    </div>
                    <div class="col-sm-12 col-md-6 col-xl-4">
                        <div class="h-100 bg-light rounded p-4">
                            <div class="d-flex align-items-center justify-content-between mb-4">
                                <h6 class="mb-0">To Do List</h6>
                                <a href="">Show All</a>
                            </div>
                            <div class="d-flex mb-2">
                                <input class="form-control bg-transparent" type="text" placeholder="Enter task">
                                <button type="button" class="btn btn-primary ms-2">Add</button>
                            </div>
                            <div class="d-flex align-items-center border-bottom py-2">
                                <input class="form-check-input m-0" type="checkbox">
                                <div class="w-100 ms-3">
                                    <div class="d-flex w-100 align-items-center justify-content-between">
                                        <span>Short task goes here...</span>
                                        <button class="btn btn-sm"><i class="fa fa-times"></i></button>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex align-items-center border-bottom py-2">
                                <input class="form-check-input m-0" type="checkbox">
                                <div class="w-100 ms-3">
                                    <div class="d-flex w-100 align-items-center justify-content-between">
                                        <span>Short task goes here...</span>
                                        <button class="btn btn-sm"><i class="fa fa-times"></i></button>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex align-items-center border-bottom py-2">
                                <input class="form-check-input m-0" type="checkbox" checked>
                                <div class="w-100 ms-3">
                                    <div class="d-flex w-100 align-items-center justify-content-between">
                                        <span><del>Short task goes here...</del></span>
                                        <button class="btn btn-sm text-primary"><i class="fa fa-times"></i></button>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex align-items-center border-bottom py-2">
                                <input class="form-check-input m-0" type="checkbox">
                                <div class="w-100 ms-3">
                                    <div class="d-flex w-100 align-items-center justify-content-between">
                                        <span>Short task goes here...</span>
                                        <button class="btn btn-sm"><i class="fa fa-times"></i></button>
                                    </div>
                                </div>
                            </div>
                            <div class="d-flex align-items-center pt-2">
                                <input class="form-check-input m-0" type="checkbox">
                                <div class="w-100 ms-3">
                                    <div class="d-flex w-100 align-items-center justify-content-between">
                                        <span>Short task goes here...</span>
                                        <button class="btn btn-sm"><i class="fa fa-times"></i></button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div> -->
		<!-- Widgets End -->


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