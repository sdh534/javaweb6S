<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="${ctp}/css/order.css">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery-serialize-object/2.5.0/jquery.serialize-object.min.js"></script>
<meta charset="UTF-8">
<title>파라다이스 | 쿠폰 선택</title>
<script>
	'use strict';
	var beforeIdx = 0;
	function getRow(cu_idx){
		if(beforeIdx != cu_idx){
			$("#row"+beforeIdx).removeClass("selected");
			beforeIdx = cu_idx;
		}
		else return;
		$("#row"+cu_idx).addClass("selected");
		
		if($("#cp_type"+cu_idx).val()==0 || $("#cp_type"+cu_idx).val()==2){ //정액, 고정금액 할인
			let sales = $("#cp_price"+cu_idx).val();
			$("#salePriceText").text(sales);
			let total = $("#totalPrice").val();
			$("#totalPriceText").text(total-sales);
			$("#couponSalePrice").val(sales);
			$("#cp_type").val($("#cp_type"+cu_idx).val());
		}
		else{
			let sales = $("#cp_ratio"+cu_idx).val() * $("#totalPrice").val() * 0.01;
			$("#salePriceText").text(sales);
			let total = $("#totalPrice").val();
			$("#totalPriceText").text(total-sales);
			$("#couponSalePrice").val(sales);
			$("#cp_type").val($("#cp_type"+cu_idx).val());
		}
		
		$("#cu_idx").val(cu_idx);
	}
	
	function updateCoupon(){
		let couponSalePrice = $("#couponSalePrice").val();
		let couponTotalPrice = $("#couponTotalPrice").val() - couponSalePrice;
		let cp_type = $("#cp_type").val();
		let cu_idx = $("#cu_idx").val();
		
		$(opener.location).attr("href", "javascript:updateCouponPrice("+cp_type+","+couponSalePrice+","+couponTotalPrice+","+cu_idx+");");
		alert("쿠폰할인이 적용되었습니다.");
		window.close();
	}
</script>
</head>
<body class="popup">
	<form name="couponForm" id="couponForm">
		<div class="container-fluid pt-4 px-0">
			<div class="row">
				<div class="col-sm-12 col-xl-12">
					<div class="bg-white rounded-lg h-100">
						<h5 class="text-center gmarketSans">쿠폰 사용</h5>

						<div class="popup-border text-left">
							<div class="mt-3">
								<h4 class="p-4 m-5 border-black">
									<b>보유 쿠폰</b>
								</h4>
								<div class="ml-3 mb-3 m-5 d-flex align-middle">
									<!-- 쿠폰목록 테이블 -->
									<div class="table-responsive">
										<table class="table text-start align-middle table-hover mb-0">
											<thead>
												<tr class="text-dark bg-light pretendard"
													style="font-size: 14pt">
													<th scope="col">쿠폰번호</th>
													<th scope="col">쿠폰명</th>
													<th scope="col">할인액(율)</th>
													<th scope="col">사용제한조건</th>
													<th scope="col">유효기간</th>
												</tr>
											</thead>
											<tbody id="couponList">
												<c:forEach var="vo" items="${vos}" varStatus="st">
													<c:if test="${vo.cu_status == false}">
														<tr class="selectRow" id="row${vo.cu_idx}"
															onclick="getRow(${vo.cu_idx})">
															<td>${vo.cp_idx}</td>
															<td>${vo.cp_name}</td>
															<td><c:if test="${vo.cp_type == 1}">${vo.cp_ratio}%</c:if>
																<c:if test="${vo.cp_type == 0 || vo.cp_type == 2}">${vo.cp_price}원</c:if>
															</td>
															<td><c:if test="${vo.cp_type == 0}">정액</c:if> <c:if
																	test="${vo.cp_type == 1}">정율</c:if> <c:if
																	test="${vo.cp_type == 2}">배송비</c:if></td>
															<td class="dateText"><c:if
																	test="${vo.cp_exPeriod==0}">영구</c:if> <c:if
																	test="${vo.cp_exPeriod!=0}">
																${fn:substring(vo.cu_useDate,0,10)}	~
																${fn:substring(vo.cp_endDate,0,10)}
																</c:if></td>
														</tr>
													</c:if>
													<input type="hidden" id="cp_type${vo.cu_idx}"
														value="${vo.cp_type}">
													<input type="hidden" id="cp_ratio${vo.cu_idx}"
														value="${vo.cp_ratio}">
													<input type="hidden" id="cp_price${vo.cu_idx}"
														value="${vo.cp_price}">
												</c:forEach>
											</tbody>
										</table>
									</div>
								</div>

								<input type="hidden" id="totalPrice" value="${totalPrice}">
								<div class="popup-border p-4 text-center bg-dark text-light">
									<div class="mb-3">
										<div
											class="d-flex flex-row justify-content-center align-items-center">
											<div class="p-2 mr-3 d-flex flex-column align-items-center">
												<span class="text-muted">상품 금액</span>
												<h4 id="checkPriceText">${totalPrice}원</h4>
											</div>
											<span class="p-2 mr-3"><i
												class="fa fa-minus circle-dark"></i></span>
											<div class="p-2 mr-3 d-flex flex-column align-items-center">
												<span class="text-muted">할인 금액</span>
												<h4>
													<font color="red" id="salePriceText">0</font>원
												</h4>
											</div>
											<span class="p-2  mr-3"><i
												class="fa fa-equals circle-dark"></i></span>
											<div class="p-2 mr-3 d-flex flex-column align-items-center">
												<span class="text-muted">쿠폰 적용 금액</span>
												<h4>
													<span id="totalPriceText">0</span>원
												</h4>
											</div>
										</div>
									</div>
								</div>

								<div class="popup-border p-4 text-center">
									<div class="mb-3">
										<button type="button" class="btn-black mr-2"
											onclick="window.close();">취소</button>
										<button type="button" class="btn-black-outline"
											onclick="updateCoupon();">등록</button>
									</div>
								</div>

							</div>
						</div>
					</div>
				</div>

			</div>
		</div>


		<input type="hidden" name="couponTotalPrice" id="couponTotalPrice"
			value="${totalPrice}"> <input type="hidden" name="cu_idx"
			id="cu_idx" value="0"> <input type="hidden" name="cp_type"
			id="cp_type" value="0"> <input type="hidden"
			name="couponSalePrice" id="couponSalePrice" value="0">

	</form>
</body>



</html>
