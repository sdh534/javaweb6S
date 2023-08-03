<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="${ctp}/css/mypage.css">
<link rel="stylesheet" href="${ctp}/css/admin.css">
<link rel="stylesheet" href="${ctp}/css/product.css">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery-serialize-object/2.5.0/jquery.serialize-object.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
	'use strict';
</script>
</head>
<body class="popup">

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
									<th scope="row" class="bg-light">총 결제금액 <br /> &lt; 50,000
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
												<td width="80%"><textarea name="cs_admin" id="cs_admin"
														class="textbox w-100" style="height: 100px;"
														placeholder=""
														<c:if test="${vo.cs_admin != null}">disabled</c:if>><c:if
															test="${vo.cs_admin != null}">${fn:trim(vo.cs_admin)}</c:if></textarea>
													<p id="charCount">0/500</p></td>
											</tr>
										</tbody>
									</table>

								</div>
							</div>

						</div>
					</div>
					<!-- col 종료 -->

				</div>

				<input type="hidden" name="oi_productCode"
					value="${vo.oi_productCode}"> <input type="hidden"
					name="imp_uid" value="${vo.imp_uid}"> <input type="hidden"
					name="pay_price" value="${vo.pay_price}"> <input
					type="hidden" name="pay_method" value="${vo.pay_method}">
				<input type="hidden" name="cs_idx" value="${vo.cs_idx}"> <input
					type="hidden" name="refund_bank" value="${vo.refund_bank}">
				<input type="hidden" name="refund_amount"
					value="${refundPrice - salePrice}">
			</form>
			<!-- 쿠폰발급 row 종료 -->
		</c:if>


	</div>


</body>


</html>
