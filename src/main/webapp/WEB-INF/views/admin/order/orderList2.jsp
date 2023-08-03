<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="nowPage" value="" />
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<head>
<meta charset="utf-8">
<title>PARADICE | 관리자 카테고리 등록</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
</head>
<script>
	'use strict';
</script>
<body>

	<div class="container-xxl position-relative bg-white d-flex p-0">
		<!-- Spinner Start -->
		<div id="spinner"
			class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
			<div class="spinner-border text-primary"
				style="width: 3rem; height: 3rem;" role="status">
				<span class="sr-only">Loading...</span>
			</div>
		</div>
		<!-- Spinner End -->

		<jsp:include page="/WEB-INF/views/admin/adminNav.jsp" />


		<div class="container-fluid pt-4 px-4">
			<div class="row">
				<div class="col-sm-12 col-xl-12">
					<div class="row mb-4">
						<div class="col-sm-12 col-xl-12  h-100">
							<!-- 오른쪽 카테고리 등록부분 -->
							<!-- Form Start -->
							<form name="mainCategoryInsertForm">
								<div class="bg-white rounded-lg p-4 mb-3">
									<h5 class="mb-2">주문 관리</h5>
									<div class="p-3">
										<div class="row border align-items-center">
											<div class="col-xl-12">
												<div class="row border-bottom">
													<div
														class="col-sm-2 col-xl-2 p-0 d-flex align-items-center justify-content-center"
														style="background: #eee;">
														<div>처리상태</div>
													</div>
													<div class="col-sm-10 col-xl-10">
														<div class="row p-4 d-flex flex-column">
															<!-- 입금 완료 ~ 배송 처리 -->
															<div class="row p-2 border-bottom">
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="search_option" id="search_option_1" value="1" />
																	<label class="custom-control-label black"
																		for="search_option_1">입금대기</label>
																</div>
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="search_option" id="search_option_2" value="2" />
																	<label class="custom-control-label black"
																		for="search_option_2">입금확인</label>
																</div>
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="search_option" id="search_option_3" value="3" />
																	<label class="custom-control-label black"
																		for="search_option_3">배송준비</label>
																</div>
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="search_option" id="search_option_4" value="4" />
																	<label class="custom-control-label black"
																		for="search_option_4">배송지연</label>
																</div>
															</div>
															<div class="row p-2 border-bottom">
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="search_option" id="search_option_5" value="5" />
																	<label class="custom-control-label black"
																		for="search_option_5">취소요청</label>
																</div>
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="search_option" id="search_option_6" value="6" />
																	<label class="custom-control-label black"
																		for="search_option_6">취소완료</label>
																</div>
															</div>
															<div class="row p-2 border-bottom">
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="search_option" id="search_option_7" value="7" />
																	<label class="custom-control-label black"
																		for="search_option_7">반품요청</label>
																</div>
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="search_option" id="search_option_8" value="8" />
																	<label class="custom-control-label black"
																		for="search_option_8">반품승인</label>
																</div>
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="search_option" id="search_option_9" value="9" />
																	<label class="custom-control-label black"
																		for="search_option_9">반품확정</label>
																</div>
															</div>
															<div class="row p-2 border-bottom">
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="search_option" id="search_option_10" value="10" />
																	<label class="custom-control-label black"
																		for="search_option_10">교환요청</label>
																</div>
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="search_option" id="search_option_11" value="11" />
																	<label class="custom-control-label black"
																		for="search_option_11">교환승인</label>
																</div>
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="search_option" id="search_option_12" value="12" />
																	<label class="custom-control-label black"
																		for="search_option_12">교환확정</label>
																</div>
															</div>
															<div class="row p-2 ">
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="search_option" id="search_option_13" value="13" />
																	<label class="custom-control-label black"
																		for="search_option_13">환불요청</label>
																</div>
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="search_option" id="search_option_14" value="14" />
																	<label class="custom-control-label black"
																		for="search_option_14">환불완료</label>
																</div>
															</div>
														</div>
													</div>
												</div>

												<div class="row  border-bottom">
													<div
														class="col-sm-2 col-xl-2 p-0 d-flex align-items-center justify-content-center "
														style="background: #eee;">
														<div>결제방법</div>
													</div>
													<div class="col-sm-10 col-xl-10">
														<div class="row p-4 d-flex flex-column">
															<!-- 입금 완료 ~ 배송 처리 -->
															<div class="row p-2">
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="pay_method" id="pay_method_1" value="1" /> <label
																		class="custom-control-label black" for="pay_method_1">카드</label>
																</div>
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="pay_method" id="pay_method_2" value="2" /> <label
																		class="custom-control-label black" for="pay_method_2">가상계좌</label>
																</div>
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="pay_method" id="pay_method_3" value="3" /> <label
																		class="custom-control-label black" for="pay_method_3">실시간
																		계좌이체</label>
																</div>
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="pay_method" id="pay_method_4" value="4" /> <label
																		class="custom-control-label black" for="pay_method_4">네이버페이</label>
																</div>
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="pay_method" id="pay_method_5" value="4" /> <label
																		class="custom-control-label black" for="pay_method_5">페이코</label>
																</div>
															</div>
														</div>
													</div>
												</div>

												<!-- 검색 -->
												<div class="row border-bottom">
													<div
														class="col-sm-2 col-xl-2 p-0 d-flex align-items-center justify-content-center "
														style="background: #eee;">
														<div>검색</div>
													</div>
													<div class="col-sm-10 col-xl-10">
														<div class="row p-4 d-flex flex-column">
															<!-- 입금 완료 ~ 배송 처리 -->
															<div class="row p-2">
																<div class="custom-input mr-3">
																	<select class="btn border">
																		<option>선택</option>
																		<option>주문자 성명</option>
																		<option>주문자 아이디</option>
																		<option>주문자 전화번호</option>
																		<option>수취인 성명</option>
																		<option>수취인 전화번호</option>
																		<option>주문 번호</option>
																		<option>상품 번호</option>
																		<option>아임포트 결제코드</option>
																	</select>
																</div>
																<div class="custom-input">
																	<input type="text" class="textbox" name="searchKeyword"
																		placeholder="검색어를 입력하세요.">
																</div>
															</div>
														</div>
													</div>
												</div>


												<div class="row  border-bottom">
													<div
														class="col-sm-2 col-xl-2 p-0 d-flex align-items-center justify-content-center "
														style="background: #eee;">
														<div>기간</div>
													</div>
													<div class="col-sm-10 col-xl-10">
														<div class="row p-4 d-flex flex-column">
															<!-- 입금 완료 ~ 배송 처리 -->
															<div class="row p-2">
																<div class="custom-input mr-3">
																	<select class="btn border">
																		<option>선택</option>
																		<option>주문일자</option>
																		<option>결제일자</option>
																		<option>배송일자</option>
																	</select>
																</div>
																<div class="custom-input">
																	<input type="date" class="textbox text-mute"
																		name="startDate"> - <input type="date"
																		class="textbox text-mute" name="endDate">
																</div>
																<div class="ml-3 buttonList btn-group btn-group-toggle"
																	data-toggle="buttons">
																	<label class="btn btn-secondary"> <input
																		type="radio" name="duration" id="today"
																		autocomplete="off" checked> 오늘
																	</label> <label class="btn btn-secondary"> <input
																		type="radio" name="duration" id="week"
																		autocomplete="off"> 1주
																	</label> <label class="btn btn-secondary"> <input
																		type="radio" name="duration" id="15day"
																		autocomplete="off"> 15일
																	</label> <label class="btn btn-secondary"> <input
																		type="radio" name="duration" id="1month"
																		autocomplete="off"> 1개월
																	</label> <label class="btn btn-secondary"> <input
																		type="radio" name="duration" id="3month"
																		autocomplete="off"> 3개월
																	</label>
																</div>
															</div>
														</div>
													</div>
												</div>
												<!-- 버튼 -->
												<div class="row  border-bottom">
													<div class="col-sm-12 col-xl-12">
														<div class="row p-4 d-flex flex-column align-items-center">
															<div class="row p-2">
																<button type="button" class="btn-black mr-2">
																	<i class="fas fa-search"></i>&nbsp;검색
																</button>
																<button type="button" class="btn-black-outline">
																	<i class="fas fa-undo"></i>&nbsp;초기화
																</button>
															</div>
														</div>
													</div>
												</div>
												<div class="row  border-bottom">
													<div class="col-sm-12 col-xl-12">
														<div class="row p-4 d-flex flex-column align-items-center">
															<div class="row p-2">
																<!-- 접히는 버튼? -->
																<button type="button" class="">
																	<i class="fas fa-angle-double-down"></i>
																</button>
															</div>
														</div>
													</div>
												</div>
											</div>


										</div>
									</div>
								</div>
								<!-- Form End -->
							</form>

						</div>
					</div>
				</div>

				<div class="col-sm-12 col-xl-12">
					<div class="bg-white rounded-lg h-100 p-4 table-group">
						<div class="row">
							<div class="col-3 border">주문번호</div>
							<div class="col-2 border">처리상태</div>
							<div class="col-2 border">주문일자</div>
							<div class="col-2 border">상품코드</div>
							<div class="col-2 border">상품이미지</div>
							<div class="col-2 border">상품명</div>
							<div class="col-2 border">결제방법</div>
							<div class="col-2 border">입금일자</div>
							<div class="col-2 border">배송비</div>
							<div class="col-2 border">택배업체</div>
							<div class="col-2 border">배송준비중일자</div>
							<div class="col-2 border">배송일자</div>
							<div class="col-2 border">배송완료일자</div>
						</div>

						<c:forEach var="vo" items="${vos}">
							<div class="row border">
								<div class="col-3">${vo.o_orderCode}</div>
								<div class="col-2">${vo.o_status}</div>
								<div class="col-2">${vo.o_date}</div>
								<div class="col-2">${vo.p_idx}</div>
								<div class="col-2">
									<img src="${ctp}/data/product/${vo.p_thumbnailIdx}"
										class="img-fluid">
								</div>
								<div class="col-2">${vo.p_name}</div>
								<div class="col-2">${vo.pay_method}</div>
								<div class="col-2">입금일자</div>
								<div class="col-2">배송비</div>
								<div class="col-2">택배업체</div>
								<div class="col-2">배송준비중일자</div>
								<div class="col-2">배송일자</div>
								<div class="col-2">배송완료일자</div>
							</div>
						</c:forEach>


					</div>
				</div>
				<!-- 왼쪽 종료 -->


			</div>
			<!-- 하나로 묶기 위한 row 종료 -->
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
						Designed By <a href="https://htmlcodex.com">HTML Codex</a>
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

</body>

