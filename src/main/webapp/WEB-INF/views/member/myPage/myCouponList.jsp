<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>PARADICE | 마이페이지</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<!-- Favicon -->
<link rel="icon" href="${ctp}/images/favicon.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script>
	'use strict'
	$(document)
			.ready(
					function() {
						//최근 주문내역 
						//--------------------------------------------------------------
						$("#startDate").change(function() {
							$("#startDate").css("color", "black");
						});
						$("#endDate").change(function() {
							$("#endDate").css("color", "black");
						});

						//조회기간 설정
						$("input[name='duration']")
								.click(
										function() {
											var duration = $(
													"input[name='duration']:checked")
													.val();
											let startDate = $("#startDate")
													.val();
											let day = new Date(startDate);

											if (startDate == "") {
												Swal.fire({
													width : 500,
													position : 'center',
													icon : 'error',
													title : '조회할 기간을 선택해주세요.',
													showConfirmButton : false,
													timer : 1000
												})
												return;
											}

											if (duration == "today") {
												document
														.getElementById('startDate').valueAsDate = new Date(
														now.setDate(now
																.getDate()));
												document
														.getElementById('endDate').valueAsDate = new Date(
														now.setDate(now
																.getDate()));
											} else if (duration == "week") {
												day = new Date(day.setDate(day
														.getDate() + 7));
												document
														.getElementById('endDate').valueAsDate = new Date(
														day);
											} else if (duration == "15day") {
												let day = new Date(startDate);
												day = new Date(day.setDate(day
														.getDate() + 15));
												document
														.getElementById('endDate').valueAsDate = new Date(
														day);
											} else if (duration == "1month") {
												let day = new Date(startDate);
												day = new Date(day.setMonth(day
														.getMonth() + 1));
												document
														.getElementById('endDate').valueAsDate = new Date(
														day);
											} else if (duration == "3month") {
												let day = new Date(startDate);
												day = new Date(day.setMonth(day
														.getMonth() + 3));
												document
														.getElementById('endDate').valueAsDate = new Date(
														day);
											}
											$("#endDate").css("color", "black");
										});
					});
</script>
</head>

<body>

	<jsp:include page="/WEB-INF/views/include/nav.jsp" />
	<div class="container-xl position-relative bg-white d-flex p-0 mypage">

		<jsp:include page="/WEB-INF/views/member/myPage/myPageNav.jsp" />


		<!-- Sales Chart Start -->
		<div class="container-fluid pt-4 px-4">
			<div class="row g-4">
				<div class="col-sm-12 col-xl-12 mb-4">
					<div class="text-center rounded p-4">
						<div
							class="d-flex align-items-center justify-content-between mb-4 mt-2 border-bottom-design">
							<div class="d-flex mb-1">
								<h4 class="mb-0 pretendard mr-2">쿠폰</h4>
							</div>
						</div>

						<div class="col-sm-12 col-xl-12 mb-4 p-0">
							<div class="bg-light text-center rounded p-2">
								<div
									class="d-flex align-items-center justify-content-between m-3">
									<h6 class="mb-0 gmarketSans mr-2" style="font-size: 15pt;">조회기간</h6>
									<div class="custom-input">
										<input type="date" class="textbox extraText" name="startDate"
											id="startDate"> - <input type="date"
											class="textbox extraText" name="endDate" id="endDate">
										<div class="mt-3 buttonList btn-group btn-group-toggle"
											data-toggle="buttons">
											<label class="btn btn-secondary"> <input type="radio"
												name="duration" id="today" autocomplete="off" value="today"
												checked> 오늘
											</label> <label class="btn btn-secondary"> <input
												type="radio" name="duration" id="week" autocomplete="off"
												value="week"> 1주
											</label> <label class="btn btn-secondary"> <input
												type="radio" name="duration" id="15day" autocomplete="off"
												value="15day"> 15일
											</label> <label class="btn btn-secondary"> <input
												type="radio" name="duration" id="1month" autocomplete="off"
												value="1month"> 1개월
											</label> <label class="btn btn-secondary"> <input
												type="radio" name="duration" id="3month" autocomplete="off"
												value="3month"> 3개월
											</label>
										</div>
									</div>

									<button type="button" class="btn-black ml-2"
										onclick="searchNow()">
										<i class="fas fa-search"></i>&nbsp;조회
									</button>
								</div>
							</div>
						</div>

						<div class="table-responsive">
							<table class="table text-start align-middle table-hover mb-0">
								<thead>
									<tr class="text-dark bg-light pretendard"
										style="font-size: 14pt">
										<th scope="col"></th>
										<th scope="col">쿠폰명</th>
										<th scope="col" width="130px">쿠폰만료일</th>
										<th scope="col">쿠폰타입</th>
										<th scope="col">할인가/할인율</th>
										<th scope="col">쿠폰사용여부</th>
									</tr>
								</thead>
								<tbody id="couponList">
									<c:forEach var="vo" items="${vos}" varStatus="st">
										<tr>
											<td>${st.count}</td>
											<td>${vo.cp_name}</td>
											<td>${fn:substring(vo.cp_endDate,0,10)}</td>
											<td><c:if test="${vo.cp_type == 1}">정율</c:if> <c:if
													test="${vo.cp_type == 0}">정액</c:if></td>
											<td><c:if test="${vo.cp_type == 1}">${vo.cp_ratio}%</c:if>
												<c:if test="${vo.cp_type == 0}">${vo.cp_price}원</c:if></td>
											<td><c:if test="${vo.cu_status}">${fn:substring(vo.cu_useDate,0,10)}<br />
													<font color="red">사용완료</font>
												</c:if> <c:if test="${!vo.cu_status}">사용가능</c:if></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- Content End -->


		<!-- Back to Top -->
		<a href="#" class="btn btn-lg btn-danger btn-lg-square back-to-top"><i
			class="bi bi-arrow-up"></i></a>
	</div>

	</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>

</html>