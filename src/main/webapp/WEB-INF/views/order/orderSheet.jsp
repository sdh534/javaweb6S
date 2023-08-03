<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<c:set var="address" value="${fn:split(memberVO.m_address, '/')}" />
<c:set var="address" value="${fn:split(memberVO.m_address, '/')}" />
<c:if test="${vos!=null}">
	<c:set var="totalCount" value="${fn:length(vos)}" />
</c:if>
<c:if test="${vos==null}">
	<c:set var="totalCount" value="${productVO.od_amount}" />
</c:if>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파라다이스 | 주문/결제</title>
<link rel="icon" href="${ctp}/images/favicon.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<link rel="stylesheet" href="${ctp}/css/order.css">
<script src="${ctp}/js/order.js"></script>
<!-- jQuery -->
<script type="text/javascript"
	src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<!-- iamport.payment.js -->
<script type="text/javascript"
	src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
<script>
	'use strict';

	function sameInfoCheck(){
		
		let check = document.getElementById("sameOrderUser").checked;
		console.log(check);
		if(check){
			$("#attn_name").val("${memberVO.m_name}");
			$("#attn_email").val("${memberVO.m_email}");
			$("#attn_phone").val("${memberVO.m_phone}");
			$("#sample6_postcode").val("${address[0]}");
			$("#sample6_address").val("${address[1]}");
			$("#sample6_detailAddress").val("${address[2]}");
			$("#sample6_extraAddress").val("${address[3]}");
		}
		else{
			$("#attn_name").val("");
			$("#attn_email").val("");
			$("#attn_phone").val("");
			$("#sample6_address").val("");
			$("#sample6_detailAddress").val("");
			$("#sample6_extraAddress").val("");
		}
	}
	
	var IMP = window.IMP;
    IMP.init("imp52522654");


	function requestPay() {
		if($("#attn_name").val()=="" ||
		$("#attn_email").val()=="" ||
		$("#attn_phone").val()=="" ||
		$("#sample6_postcode").val()=="" ||
		$("#sample6_address").val()=="" ||
		$("#sample6_detailAddress").val()==""){
			alert("배송지 주소를 입력해주세요.");
			orderForm.attn_name.focus();
			return;
		}
		
		if($("#pay_point").val() > ${memberVO.m_point}){
			alert("보유 금액 이상 사용은 불가능 합니다.");
			$("#pay_point").focus();
			return;
		}
		
		console.log($("#cu_idx").val());
		
		let name = "상품명";
		if("${productVO.p_name}"== '') {
			if(${totalCount}>1)name = "${vos[0].p_name}" +" 외" + ${totalCount-1} +"건";
			else 	 name = "${vos[0].p_name}";
		}
		else name = "${productVO.p_name}";
		
		let paymentMethod = $("input[name='pay_method']:checked").val();
		
		let totalPrice = orderForm.totalCouponPrice.value - orderForm.pay_point.value;
		
		IMP.request_pay({
			pg : "html5_inicis.INIpayTest",
			pay_method : paymentMethod,
			merchant_uid : "javawebS_" + new Date().getTime(),
			name : name,
			amount : totalPrice,
			buyer_email : "${memberVO.m_email}",
			buyer_name : "${memberVO.m_name}",
			buyer_tel : "${memberVO.m_phone}",
			buyer_addr : "${address[1]}",
			buyer_postcode : "${address[0]}",
		}, function(rsp) {
			if (rsp.success) {
				alert("결제가 완료되었습니다." + rsp.status + "/" + rsp.imp_uid + "/"
						+ rsp.merchant_uid + "/" + rsp.paid_amount + "/"
						+ rsp.vbank_num + "/" + rsp.vbank_name + "/");
				//여기 ajax 처리하면 되겟다
				let postcode = orderForm.postcode.value.trim();
	    	let roadAddress = orderForm.roadAddress.value.trim();
	    	let detailAddress = orderForm.detailAddress.value.trim();
	    	let extraAddress = orderForm.extraAddress.value.trim();
	    	orderForm.attn_address.value = postcode + "/" + roadAddress + "/" + detailAddress + "/" + extraAddress + "/";
	    	
	    	let data = {
	    		productList: orderForm.productList.value,
	    		amountList: orderForm.amountList.value,
					m_mid: orderForm.m_mid.value,
					od_detail: orderForm.od_detail.value,
					attn_address:  orderForm.attn_address.value,
					attn_name:  orderForm.attn_name.value,
					attn_phone:  orderForm.attn_phone.value,
					attn_email:  orderForm.attn_email.value,
					o_status: rsp.status,
					pay_point: orderForm.pay_point.value,
					pay_price: rsp.paid_amount,
					pay_method: rsp.pay_method,
					pay_vbankNumber: rsp.vbank_num,
					pay_vbankName: rsp.vbank_name,
					pay_vbankDate: rsp.vbank_date,
					pay_cardCode: rsp.card_number,
					pay_cardName: rsp.card_name,
					imp_uid: rsp.imp_uid,
					cu_idx: orderForm.cu_idx.value
			}

	    	
				$.ajax({
					type : "post",
					url : "${ctp}/order/orderOK",
					data : data,
					success : function(res) {
						location.href='${ctp}/order/orderOK?o_orderCode='+res;
					},
					error : function() {
						alert("전송오류!");
					}

				});
			} else {
				alert("결제에 실패하였습니다." + rsp.error_msg);
			}
		});
	}
	
	function point(){
		let point = $("#pay_point").val();
		
		if($("#pay_point").val() > ${memberVO.m_point}){
			alert("보유 금액 이상 사용은 불가능 합니다.");
			$("#pay_point").focus();
			return;
		}
		
		document.getElementById("pointSale").innerHTML=
			  '<div class="row">'
				+'<div class="col-xl-12  d-flex justify-content-between">'
				+'<strong><font color="#ccc">┖&nbsp;적립금 적용</font></strong>'
				+'<strong><font color="#ccc">-'+point.toLocaleString()+'원</font></strong>'
				+'</div></div>';
		if(point == ""){
			document.getElementById("pointSale").innerHTML='';
		}
		let couponPrice = $("#totalCouponPrice").val();
	  document.getElementById("totalCouponPriceText").innerHTML = '<h4><strong>'+(couponPrice - point).toLocaleString()+'원</strong></h4>';
	}
	
	function showPopUp(m_idx) {
		let totalPrice = document.getElementById("totalPrice").value;
		let drivePrice = document.getElementById("drivePrice").value;
		let totalWithDrive = parseInt(totalPrice) + parseInt(drivePrice);
		console.log(totalWithDrive);
		var width = 750;
		var height = 850;
		
		var left = (window.screen.width / 2) - (width/2);
		var top = (window.screen.height / 4) - (height/4);
		
		var windowStatus = 'width='+width+', height='+height+', left='+left+', top='+top+', scrollbars=yes, status=yes, resizable=yes, titlebar=yes';
	  //연결하고싶은url
   	const url = "${ctp}/order/couponForm?m_idx="+m_idx+"&totalPrice="+totalWithDrive;

		//등록된 url 및 window 속성 기준으로 팝업창을 연다.
		window.open(url, "hello popup", windowStatus);
	}
	
	function updateCouponPrice(cp_type, salePrice, couponPrice, cu_idx){
		$("#couponPrice").text("-"+salePrice.toLocaleString());
		
		//뷰에 보이는 가격을 변경시켜준다 
		if(cp_type ==0 || cp_type==1){
	  document.getElementById("couponSale").innerHTML=
		  '<div class="row">'
			+'<div class="col-xl-12  d-flex justify-content-between">'
			+'<strong><font color="#ccc">┖&nbsp;쿠폰할인</font></strong>'
			+'<strong><font color="#ccc">-'+salePrice.toLocaleString()+'원</font></strong>'
			+'</div></div>';
		}
		else{
			document.getElementById("driveCoupon").innerHTML=
				  '<div class="row">'
					+'<div class="col-xl-12  d-flex justify-content-between">'
					+'<strong><font color="#ccc">┖&nbsp;쿠폰할인</font></strong>'
					+'<strong><font color="#ccc">-'+salePrice.toLocaleString()+'원</font></strong>'
					+'</div></div>';
			  document.getElementById("driveText").innerHTML = '<strong>'+0+'원</strong>';
		}
		
	
	  document.getElementById("totalCouponPriceText").innerHTML = '<h4><strong>'+couponPrice.toLocaleString()+'원</strong></h4>';
		
	  //이후 실제 계산 시 필요하므로 쿠폰을 적용한 총 가격을 저장한다
	  
	  $("#totalCouponPrice").val(couponPrice);
	  $("#cu_idx").val(cu_idx);
	  console.log(cu_idx);
	  let saletotal = salePrice+Number($("#suborigtotal").val());
	  $("#totalCouponSaleText").html('<strong>-'+saletotal.toLocaleString()+'원</strong>')
	}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/nav.jsp" />
	<form name="orderForm" id="orderForm">
		<div class="container mt-4">
			<div class="px-4 px-lg-0">
				<!-- For demo purpose -->
				<div class="container py-5 text-center">
					<h3>
						<b>주문/결제</b>
					</h3>
					<hr>
					<div class="row">
						<div class="col-xl-12">
							<div class="d-flex justify-content-center align-items-center">
								<div class="progresses">
									<div class="steps">
										<span><i class="fa fa-check"></i></span>
									</div>
									<span class="line"></span> <span class="step-text">장바구니</span>
									<div class="steps">
										<span><i class="fa fa-check"></i></span>
									</div>
									<span class="line inactive"></span> <span class="step-text">주문/결제</span>
									<div class="steps inactive">
										<span><i class="fa fa-check"></i></span>
									</div>
									<span class="step-text">완료</span>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- End -->

				<div class="pb-5">
					<div class="container">
						<div class="row">
							<div class="col-lg-12 p-5 bg-white rounded shadow-sm mb-5">

								<!-- Shopping cart table -->
								<div class="table-responsive">
									<table class="table">
										<thead>
											<tr>
												<th scope="col" class="border-0 bg-dark text-white">
													<div class="p-2 px-3 text-uppercase">상품정보</div>
												</th>
												<th scope="col" class="border-0 bg-dark text-white">
													<div class="py-2 text-uppercase">수량</div>
												</th>
												<th scope="col" class="border-0 bg-dark text-white">
													<div class="py-2 text-uppercase">가격</div>
												</th>
												<th scope="col" class="border-0 bg-dark text-white">
													<div class="py-2 text-uppercase">결제금액</div>
												</th>
											</tr>
										</thead>
										<tbody>
											<c:if test="${vos == null}">
												<!-- 상품페이지-바로구매 > 단일상품 주문시 -->
												<tr>
													<th scope="row" class="border-0">
														<div class="p-2">
															<img
																src="${ctp}/data/product/${productVO.p_thumbnailIdx}"
																alt="" width="70" class="img-fluid rounded shadow-sm">
															<div class="ml-3 d-inline-block align-middle">
																<h5 class="mb-0">
																	<a href="#"
																		class="text-dark d-inline-block align-middle">${productVO.p_name}</a>
																</h5>
																<span
																	class="text-muted font-weight-normal font-italic d-block">${productVO.c_mainName}-${productVO.c_middleName}</span>
															</div>
														</div>
													</th>
													<td class="border-0 align-middle"><strong>${productVO.od_amount}</strong></td>
													<td class="border-0 align-middle"><strong><fmt:formatNumber
																value="${productVO.p_price}" pattern="#,###" />원</strong></td>
													<td class="border-0 align-middle"><strong><fmt:formatNumber
																value="${productVO.p_price * productVO.od_amount}"
																pattern="#,###" />원</strong></td>
													<c:set var="totalPrice" value="${totalPrice}"></c:set>
													<c:set var="totalOrigPrice" value="${totalOrigPrice}"></c:set>
												</tr>
											</c:if>
											<!-- 장바구니 - 선택/전체구매 > 여러상품 주문시 -->
											<c:forEach var="productVO" items="${vos}" varStatus="st">
												<tr>
													<th scope="row" class="border-0">
														<div class="p-2">
															<img
																src="${ctp}/data/product/${productVO.p_thumbnailIdx}"
																alt="" width="70" class="img-fluid rounded shadow-sm">
															<div class="ml-3 d-inline-block align-middle">
																<h5 class="mb-0">
																	<a href="#"
																		class="text-dark d-inline-block align-middle">${productVO.p_name}</a>
																</h5>
																<span
																	class="text-muted font-weight-normal font-italic d-block">${productVO.c_mainName}-${productVO.c_middleName}</span>
															</div>
														</div>
													</th>
													<td class="border-0 align-middle"><strong>${productVO.od_amount}</strong></td>
													<td class="border-0 align-middle"><strong><fmt:formatNumber
																value="${productVO.p_price}" pattern="#,###" />원</strong></td>
													<td class="border-0 align-middle"><strong><fmt:formatNumber
																value="${productVO.p_price * productVO.od_amount}"
																pattern="#,###" />원</strong></td>

												</tr>
											</c:forEach>
										</tbody>
									</table>

									<div class="col-lg-12 p-5 bg-white rounded shadow-sm mb-5">
										<div
											class="d-flex flex-row justify-content-end align-items-center">
											<div class="p-2 mr-3 d-flex flex-column align-items-center">
												<span class="text-muted">총 ${totalCount}개의 상품 금액</span>
												<h4 id="checkPriceText">
													<fmt:formatNumber value="${totalPrice}" pattern="#,###" />
													원
												</h4>
											</div>
											<span class="p-2 mr-3"><i class="fa fa-plus circle"></i></span>
											<div class="p-2 mr-3 d-flex flex-column align-items-center">
												<span class="text-muted">배송비</span>
												<h4 id="drivePriceText">${drivePrice}원</h4>
												<input type="hidden" value="${drivePrice}">
											</div>
											<span class="p-2  mr-3"><i class="fa fa-equals circle"></i></span>
											<div class="p-2 mr-3 d-flex flex-column align-items-center">
												<span class="text-muted">합계</span>
												<h4 id="totalPriceText">
													<fmt:formatNumber value="${drivePrice + totalPrice}"
														pattern="#,###" />
													원
												</h4>
											</div>
										</div>
									</div>
								</div>
								<!-- End -->
							</div>
						</div>


						<div class="row">
							<div class="col-lg-6 p-5 bg-white rounded shadow-sm mb-5">
								<div class="bg-light px-4 py-3 text-uppercase font-weight-bold">주문자
									정보</div>
								<div class="p-4">
									<p class="mb-4 text-muted">
										주문자 정보로 결제관련 정보가 제공됩니다. <br />정확한 정보로 등록되어있는지 확인해주세요.
									</p>
									<div class="row">
										<div class="col-lg-12">
											<ul class="list-unstyled mb-4">
												<li
													class="d-flex justify-content-between align-items-center py-3 border-bottom"><strong
													class="text-muted">주문하시는 분 </strong><strong>${memberVO.m_name}</strong></li>
												<li
													class="d-flex justify-content-between align-items-center py-3 border-bottom"><strong
													class="text-muted">휴대전화번호</strong><strong>${memberVO.m_phone}</strong></li>
												<li
													class="d-flex justify-content-between align-items-center py-3 "><strong
													class="text-muted">이메일</strong><strong>${memberVO.m_email}</strong></li>
											</ul>
										</div>
									</div>
								</div>
							</div>
							<div class="col-lg-6 p-5 bg-white rounded shadow-sm mb-5">
								<div class="bg-light px-4 py-3 text-uppercase font-weight-bold">배송지
									정보</div>
								<div class="p-4">
									<div class="input_field checkbox_option">
										<input type="checkbox" id="sameOrderUser" style="width: 0px;"
											onclick="sameInfoCheck()"><label for="sameOrderUser">주문자
											정보와 동일</label>
									</div>
									<div class="row">
										<div class="col-lg-12">
											<ul class="list-unstyled mb-4">
												<li
													class="d-flex justify-content-between align-items-center py-2 border-bottom">
													<strong class="text-muted">받으시는 분</strong> <strong><input
														type="text" id="attn_name" name="attn_name"
														class="form-control rounded-pill "></strong>
												</li>
												<li
													class="d-flex justify-content-between align-items-center py-2 border-bottom">
													<strong class="text-muted">휴대전화번호</strong> <strong><input
														type="text" id="attn_phone" name="attn_phone"
														class="form-control rounded-pill "></strong>
												</li>
												<li
													class="d-flex justify-content-between align-items-center py-2 ">
													<strong class="text-muted">이메일</strong> <strong><input
														type="text" id="attn_email" name="attn_email"
														class="form-control rounded-pill "></strong>
												</li>
												<li
													class="d-flex justify-content-between align-items-center py-2 ">
													<strong class="text-muted">주소</strong><input type="button"
													value="우편번호 찾기" onclick="sample6_execDaumPostcode()"
													class="btn btn-sm btn-dark rounded-pill w-50 py-2 btn-block">
												</li>
												<li
													class="d-flex justify-content-between align-items-center py-2 ">
													<strong class="text-muted">우편번호</strong> <strong><input
														type="text" id="sample6_postcode" placeholder="우편번호"
														name="postcode" class="form-control rounded-pill "></strong>
												</li>
												<li class=" py-2"><strong><input type="text"
														id="sample6_address" placeholder="도로명/건물번호"
														name="roadAddress" class="form-control rounded-pill "></strong>
												</li>
												<li class=" py-2"><strong><input type="text"
														id="sample6_detailAddress" placeholder="동/층/호"
														name="detailAddress" class="form-control rounded-pill "></strong>
												</li>
												<li class=" py-2"><strong><input type="text"
														id="sample6_extraAddress" placeholder="(상세주소)"
														name="extraAddress" class="form-control rounded-pill "></strong>
												</li>
											</ul>
										</div>
									</div>
								</div>
							</div>
						</div>

						<div class="row py-5 p-4 bg-white rounded shadow-sm">
							<div class="col-lg-6">
								<div
									class="bg-light rounded-pill px-4 py-3 text-uppercase font-weight-bold">결제수단</div>
								<div class="p-4">
									<div style="display: flex; justify-content: space-between;">
										<div class="custom-control custom-radio custom-control-inline">
											<input type="radio" class="custom-control-input"
												name="pay_method" id="card" value="card" checked /> <label
												class="custom-control-label black" for="card"> 신용카드
												결제 </label>
										</div>
										<div class="custom-control custom-radio custom-control-inline">
											<input type="radio" class="custom-control-input"
												name="pay_method" id="bank" value="vbank" /> <label
												class="custom-control-label black" for="bank"> 무통장
												입금 </label>
										</div>
										<div class="custom-control custom-radio custom-control-inline">
											<input type="radio" class="custom-control-input"
												name="pay_method" id="mail" value="payment" /> <label
												class="custom-control-label black" for="mail"> 실시간
												계좌이체 결제 </label>
										</div>
									</div>
								</div>
								<div
									class="bg-light rounded-pill px-4 py-3 text-uppercase font-weight-bold">할인
									및 포인트</div>
								<div class="p-4">
									<!-- 쿠폰 -->
									<ul class="list-unstyled mb-4">
										<li
											class="d-flex justify-content-between align-items-center py-3 border-bottom">
											<strong class="text-muted">상품/주문 쿠폰 </strong>
											<div class="d-flex w-50 align-items-center flex-row-reverse">
												<input type="button" value="쿠폰 사용"
													onclick="showPopUp(${sIdx})"
													class="btn btn-sm btn-dark rounded-pill w-50 py-2 btn-block">
												<div class="mr-2" id="couponPrice"></div>
											</div>
										</li>
										<li
											class="d-flex justify-content-between align-items-center py-3 "><strong
											class="text-muted">사용 가능 적립금</strong><strong>${memberVO.m_point}</strong></li>
										<li
											class="d-flex justify-content-between align-items-center py-3 "><strong
											class="text-muted">사용 적립금</strong> <strong><input
												type="number" id="pay_point" placeholder="0원" value="0"
												name="pay_point"
												class="form-control rounded-pill text-right"
												onchange="point()"></strong></li>
									</ul>

								</div>
								<div
									class="bg-light rounded-pill px-4 py-3 text-uppercase font-weight-bold">요청사항</div>
								<div class="p-4">
									<p class="font-italic mb-4">판매자에게 요청사항이 있을 경우 작성해주세요.</p>
									<textarea name="od_detail" cols="30" rows="2"
										class="form-control"></textarea>
								</div>
							</div>
							<div class="col-lg-6 bg-light rounded-2">
								<div class="px-4 py-3 font-weight-bold">
									<h3 class="mt-3">결제 상세</h3>
								</div>
								<div class="p-4">
									<ul class="list-unstyled mb-4">
										<li class="d-flex justify-content-between py-3 border-bottom"><strong
											class="text-muted">상품금액 </strong><strong><fmt:formatNumber
													value="${totalOrigPrice}" pattern="#,###" />원</strong></li>
										<li
											class="d-flex flex-column justify-content-between py-3 border-bottom">
											<div class="row">
												<div class="col-xl-12  d-flex justify-content-between">
													<strong class="text-muted">배송비</strong> <strong
														id="driveText"><fmt:formatNumber
															value="${drivePrice}" pattern="#,###" />원</strong>
												</div>
											</div>
											<div id="driveCoupon"></div>
										</li>
										<li
											class="d-flex py-3 flex-column justify-content-between border-bottom">
											<div class="row">
												<div class="col-xl-12  d-flex justify-content-between">
													<strong class="text-muted">할인 및 포인트</strong>
													<div id="totalCouponSaleText">
														<strong>-<fmt:formatNumber
																value="${totalOrigPrice - totalPrice}" pattern="#,###" />원
														</strong>
													</div>
												</div>
											</div>
											<div class="row">
												<div class="col-xl-12  d-flex justify-content-between">
													<strong><font color="#ccc">┖&nbsp;즉시할인</font></strong> <strong><font
														color="#ccc">-<fmt:formatNumber
																value="${totalOrigPrice - totalPrice}" pattern="#,###" />원
													</font></strong>
												</div>
											</div>
											<div id="pointSale"></div>
											<div id="couponSale"></div>
										</li>
										<li class="d-flex justify-content-between py-3"><h4>
												<strong class="text-muted">총 금액</strong>
											</h4>
											<div id="totalCouponPriceText">
												<h4>
													<strong><fmt:formatNumber
															value="${totalPrice + drivePrice}" pattern="#,###" />원</strong>
												</h4>
											</div></li>
									</ul>
									<a href="javascript:requestPay()"
										class="btn btn-dark py-2 btn-block small">결제하기</a>

									<!-- 가릴 부분 -->
									<input type="hidden" name="cu_idx" id="cu_idx" value="0" /> <input
										type="hidden" name="od_amount" value="${productVO.od_amount}" />
									<input type="hidden" name="m_mid" value="${memberVO.m_mid}" />
									<input type="hidden" name="attn_address" value="" /> <input
										type="hidden" name="totalPrice" id="totalPrice"
										value="${totalPrice}" /> <input type="hidden"
										name="drivePrice" id="drivePrice" value="${drivePrice}" />
									<!-- 쿠폰까지 적용한 "진짜" 가격 -->
									<input type="hidden" name="totalCouponPrice"
										id="totalCouponPrice" value="${totalPrice+drivePrice}" />
									<!-- 뷰에 얼마만큼 할인됐는지 표시하는 용도 -->
									<input type="hidden" name="suborigtotal" id="suborigtotal"
										value="${totalOrigPrice - totalPrice}" /> <input type="hidden"
										name="productList" id="productList" value="${productList}">
									<input type="hidden" name="amountList" id="amountList"
										value="${amountList}">


								</div>
							</div>
						</div>

					</div>
				</div>
			</div>
		</div>
	</form>
</body>
</html>