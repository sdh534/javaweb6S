<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<head>
<meta charset="utf-8">
<title>PARADICE | 취소/교환/반품 정보</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="" name="keywords">
<meta content="" name="description">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
</head>
<script>
	'use strict';
	function confirmCS() {
		if (!$("input[name='cancelSelect']").is(":checked")) {
			alert("승인/반려 여부를 선택해주세요.");
			return;
		}
		if ($("#cs_context").val() == "") {
			alert("승인/반려 사유를 입력해주세요.");
			return;
		}

		let cancelSelect = CSconfirm.cancelSelect.value;

		$.ajax({
			type : "post",
			url : "${ctp}/admin/order/orderCSconfirm",
			data : {
				cs_admin : CSconfirm.cs_admin.value,
				cancelSelect : CSconfirm.cancelSelect.value,
				oi_productCode : CSconfirm.oi_productCode.value,
				cs_idx : CSconfirm.cs_idx.value,
				refund_amount : CSconfirm.refund_amount.value
			},
			success : function(res) {
				alert("성공");
			},
			error : function() {
				alert("전송오류!");
			}

		});
	}

	function cancel() {
		if ($("#cs_context").val() != "") {
			let con = confirm("입력하신 정보가 저장되지 않습니다. 정말 다음에 작성하시겠습니까?");
			if (con)
				window.close();
		} else
			window.close();
	}

	$(document).ready(function() {
		const textarea = document.getElementById("cs_admin");
		const charCount = document.getElementById("charCount");
		//글자수 제한
		textarea.addEventListener("keyup", function() {
			const text = textarea.value;
			const count = text.length;

			if (count > 500) {
				this.value = text.substring(0, 500);
			}
			charCount.textContent = count + "/500";
		});
	});
</script>
<body>

	<div class="container-xxl position-relative bg-white d-flex p-0">

		<jsp:include page="/WEB-INF/views/admin/adminNav.jsp" />


		<div class="container-fluid pt-4 px-4">

			<div class="row">
				<div class="col-sm-12 col-xl-12  h-100">
					<!-- Form Start -->
					<div class="bg-white rounded-lg p-4 mb-3">
						<h5 class="mb-2">주문 정보</h5>

						<div class="table-responsive">
							<table class="table text-start align-middle table-bordered mb-0">
								<tbody class="cancelTable">
									<tr>
										<th scope="row" width="20%" class="bg-light">주문상태</th>
										<td width="30%">${vo.o_status}</td>
										<th scope="row" class="bg-light">주문자</th>
										<td width="30%">${vo.m_mid}</td>
									</tr>
									<tr>
										<th scope="row" class="bg-light">주문일시</th>
										<td width="30%">${fn:substring(vo.o_date,0,19)}</td>
										<th scope="row" class="bg-light">주문번호</th>
										<td width="30%">${vo.o_orderCode}</td>
									</tr>
									<tr>
										<th scope="row" class="bg-light">결제수단</th>
										<td width="30%"><c:if test="${vo.pay_method == 'card'}">신용카드</c:if>
											<c:if test="${vo.pay_method == 'vbank'}">무통장 입금</c:if> <c:if
												test="${vo.pay_method == 'bank'}">실시간 계좌이체</c:if></td>
										<th scope="row" class="bg-light">결제상세</th>
										<td width="30%"><c:if test="${vo.pay_method == 'card'}">${vo.pay_cardCode}</c:if>
											<c:if test="${vo.pay_method == 'vbank'}">${vo.pay_vbankNumber}</c:if>
											<c:if test="${vo.pay_method == 'bank'}">${vo.pay_bankCode}</c:if>
										</td>
									</tr>
									<tr>
										<th scope="row" class="bg-light">결제완료일시</th>
										<td>${fn:substring(vo.pay_date,0,19)}</td>
										<th scope="row" class="bg-light">결제금액</th>
										<td>${vo.pay_price}원</td>
									</tr>
								</tbody>
							</table>
						</div>

					</div>
				</div>
				<!-- col 종료 -->
			</div>
			<!-- 주문정보 row 종료 -->

			<div class="row">
				<div class="col-sm-12 col-xl-12  h-100">
					<!-- Form Start -->
					<div class="bg-white rounded-lg p-4 mb-3">
						<h5 class="mb-2">상품 정보</h5>

						<div class="table-responsive">
							<table class="table text-start align-middle table-bordered mb-0">
								<tbody class="cancelTable">
									<c:forEach var="productVO" items="${productVOS}" varStatus="st">
										<tr>
											<th scope="row" class="bg-light">상품 이미지</th>
											<td><img
												src="${ctp}/data/product/${productVO.p_thumbnailIdx}"
												width="150px"></td>
											<th scope="row" class="bg-light">상품명</th>
											<td>${productVO.p_name}</td>
										</tr>
										<tr>
											<th scope="row" class="bg-light">상품가격</th>
											<td colspan=3>${productVO.p_price}</td>
										</tr>
										<tr>
											<th scope="row" class="bg-light">상태</th>
											<td colspan=3><font color="red">${productVO.cs_status}</font></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>

					</div>
				</div>
				<!-- col 종료 -->
			</div>
			<!-- 주문정보 row 종료 -->


			<div class="row">
				<div class="col-sm-12 col-xl-12  h-100">
					<!-- 오른쪽 카테고리 등록부분 -->
					<!-- Form Start -->
					<div class="bg-white rounded-lg p-4 mb-3">
						<h5 class="mb-2">배송 정보</h5>

						<div class="table-responsive">
							<table class="table text-start align-middle table-bordered mb-0">
								<tbody class="cancelTable">
									<tr>
										<th scope="row" width="20%" class="bg-light">수취인 명</th>
										<td width="30%">${vo.attn_name}</td>
										<th scope="row" class="bg-light">수취인 전화번호</th>
										<td width="30%">${vo.attn_phone}</td>
									</tr>
									<tr>
										<th scope="row" class="bg-light">수취인 이메일</th>
										<td colspan=3>${vo.attn_email}</td>
									</tr>
									<tr>
										<th scope="row" class="bg-light">수취인 주소</th>
										<c:set var="address" value="${fn:split(vo.attn_address, '/')}"></c:set>
										<td colspan=3>${address[1]}${address[2]} ${address[3]}
											(${address[0]})</td>
									</tr>
									<tr>
										<th scope="row" class="bg-light">운송사 명</th>
										<td colspan=3>${vo.deliveryCom}</td>
									</tr>
									<tr>
										<th scope="row" class="bg-light">운송장 번호</th>
										<td colspan=3>${vo.deliveryCode}</td>
									</tr>
								</tbody>
							</table>

						</div>

					</div>
				</div>
				<!-- col 종료 -->
			</div>
			<!-- 배송정보 row 종료 -->



			<c:if test="${vo.cs_context != NULL}">
				<div class="row">
					<div class="col-sm-12 col-xl-12  h-100">
						<!-- 오른쪽 카테고리 등록부분 -->
						<!-- Form Start -->
						<div class="bg-white rounded-lg p-4 mb-3">
							<h5 class="mb-2">취소 정보</h5>

							<div class="table-responsive">
								<table class="table text-start align-middle table-bordered mb-0">
									<tbody class="cancelTable">
										<tr>
											<th scope="row" width="20%" class="bg-light">취소상태</th>
											<td width="30%"><font color="red">${vo.cs_status}</font></td>
											<th scope="row" class="bg-light">주문자</th>
											<td width="30%">${vo.m_mid}</td>
										</tr>
										<tr>
											<th scope="row" class="bg-light">주문일시</th>
											<td width="30%">${fn:substring(vo.o_date,0,19)}</td>
											<th scope="row" class="bg-light">주문상품번호</th>
											<td width="30%">${vo.oi_productCode}</td>
										</tr>
										<tr id="ct1">
											<th scope="row" class="bg-light">취소 접수일시</th>
											<td width="30%">${fn:substring(vo.cs_date,0,19)}</td>
											<th scope="row" class="bg-light">취소 사유</th>
											<td width="30%">${vo.cs_category}</td>
										</tr>
										<tr>
											<th scope="row" class="bg-light">환불 완료일시</th>
											<td colspan="3"><c:if test="${vo.refund_date == null}">환불 완료시 자동완성</c:if>
												<c:if test="${vo.refund_date != null}">${vo.refund_date}</c:if>
											</td>
										</tr>
									</tbody>
								</table>
								<table class="table text-start align-middle table-bordered mt-3">
									<tbody class="cancelTable">
										<tr>
											<th scope="row" class="bg-light">취소사유 상세</th>
											<td width="80%">${vo.cs_context}</td>
										</tr>
										<tr>
											<th scope="row" class="bg-light">첨부 이미지</th>
											<td width="80%"><c:if test="${vo.cs_img != ''}">
													<img src='${ctp}/data/review/${vo.cs_img}'>
												</c:if></td>
										</tr>
									</tbody>
								</table>
								<table class="table text-start align-middle table-bordered mt-3">
									<tbody class="cancelTable">
										<tr>
											<th scope="row" class="bg-light">적립금</th>
											<td width="80%">${vo.pay_point}</td>
										</tr>
										<tr>
											<th scope="row" class="bg-light">쿠폰 사용내역</th>
											<td width="80%">${vo.cu_idx}</td>
										</tr>
										<tr>
											<th scope="row" class="bg-light">환불수단</th>
											<td width="80%">${vo.pay_method}</td>
										</tr>
									</tbody>
								</table>

							</div>

						</div>
					</div>
					<!-- col 종료 -->
				</div>
				<!-- 쿠폰 등록 row 종료 -->

				<div class="row">
					<div class="col-sm-12 col-xl-12  h-100">
						<div class="bg-white rounded-lg p-4 mb-3">
							<h5 class="mb-2">환불 정보</h5>

							<div class="table-responsive">
								<table class="table text-start align-middle table-bordered mt-3">
									<tbody class="cancelTable">
										<tr>
											<th scope="row" class="bg-light">결제 금액</th>
											<td width="80%">${vo.pay_price}</td>
										</tr>
										<tr>
											<th scope="row" class="bg-light">총 상품 금액</th>
											<td width="80%">${refundPrice}</td>
										</tr>
										<tr>
											<th scope="row" class="bg-light">쿠폰/적립금<br /> 차감금액
											</th>
											<td width="80%">${salePrice}</td>
										</tr>
										<tr>
											<th scope="row" class="bg-light">배송비 차감<br /> 금액
											</th>
											<td width="80%">${drivePrice}</td>
										</tr>
										<tr>
											<th scope="row" class="bg-light">환불금액</th>
											<td width="80%"><font color="red"><b>${refundPrice}</b></font>
												<!-- 단순변심일 경우 배송비 추가해야함 --></td>
										</tr>
									</tbody>
								</table>

							</div>
							<span><font color="red"><i class="fas fa-check"></i>환불
									책정 기준 안내</font></span> <br />
							<table class="table text-start align-middle table-bordered mt-3">
								<tbody class="cancelTable">
									<tr>
										<th scope="row" class="bg-light">총 결제금액 <br /> &lt;
											50,000
										</th>
										<td width="80%">반품 배송비 3,000 차감</td>
									</tr>
									<tr>
										<th scope="row" class="bg-light">총 결제금액 <br /> &gt;=
											50,000
										</th>
										<td class="p-0">
											<table class="w-100">
												<tr>
													<td class="bg-light">환불 후 잔금<br /> &lt;= 50,000
													</td>
													<td width="80%">반품 배송비 6,000 차감</td>
												</tr>
												<tr>
													<td class="bg-light">환불 후 잔금<br /> &gt; 50,000
													</td>
													<td width="80%">반품 배송비 3,000 차감</td>
												</tr>
											</table>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<!-- col 종료 -->
				</div>
				<!-- 쿠폰 등록 row 종료 -->

				<form name="CSconfirm">
					<!-- 쿠폰 발급 -->
					<div class="row">
						<div class="col-sm-12 col-xl-12  h-100">
							<!-- 오른쪽 카테고리 등록부분 -->
							<div class="bg-white rounded-lg p-4 mb-3">
								<h5 class="mb-2">승인 여부</h5>

								<div class="d-flex justify-content-center mt-3">
									<div
										class="mr-3 custom-control custom-radio custom-control-inline ">
										<input class="custom-control-input" type="radio"
											name="cancelSelect" id="sort1" value="승인"
											<c:if test="${vo.cs_admin != null}"> checked disabled</c:if>>
										<label class="custom-control-label" for="sort1">승인</label>
									</div>
									<div class="custom-control custom-radio custom-control-inline ">
										<input class="custom-control-input" type="radio"
											name="cancelSelect" id="sort2" value="반려"
											<c:if test="${vo.cs_admin != null}"> checked disabled</c:if>>
										<label class="custom-control-label" for="sort2">반려</label>
									</div>
								</div>
								<div>
									<div class="textarea-container">
										<table
											class="table text-start align-middle table-bordered mt-3">
											<tbody class="cancelTable">
												<tr>
													<th scope="row" class="bg-light">승인/반려 사유</th>
													<td width="80%"><textarea name="cs_admin"
															id="cs_admin" class="textbox w-100"
															style="height: 100px;" placeholder=""
															<c:if test="${vo.cs_admin != null}">disabled</c:if>><c:if
																test="${vo.cs_admin != null}">${fn:trim(vo.cs_admin)}</c:if></textarea>
														<p id="charCount">0/500</p></td>
												</tr>
											</tbody>
										</table>

									</div>
								</div>

								<c:if test="${vo.cs_admin == null}">
									<div class="row m-0 border-bottom">
										<div class="col-sm-12 col-xl-12">
											<div class="row p-4 d-flex flex-column align-items-center">
												<div class="row p-2">
													<button type="button" class="btn-black mr-2"
														onclick="confirmCS()">
														<i class="fas fa-search"></i>&nbsp;등록
													</button>
													<button type="button" class="btn-black-outline"
														onclick="location.reload();">
														<i class="fas fa-undo"></i>&nbsp;초기화
													</button>
												</div>
											</div>
										</div>
									</div>
								</c:if>
							</div>
						</div>
						<!-- col 종료 -->

					</div>

					<input type="hidden" name="oi_productCode"
						value="${vo.oi_productCode}"> <input type="hidden"
						name="imp_uid" value="${vo.imp_uid}"> <input
						type="hidden" name="pay_price" value="${vo.pay_price}"> <input
						type="hidden" name="pay_method" value="${vo.pay_method}">
					<input type="hidden" name="cs_idx" value="${vo.cs_idx}"> <input
						type="hidden" name="refund_bank" value="${vo.refund_bank}">
					<input type="hidden" name="refund_amount"
						value="${refundPrice - salePrice}">
				</form>
				<!-- 쿠폰발급 row 종료 -->
			</c:if>


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

