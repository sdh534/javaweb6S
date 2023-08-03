<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<c:set var="address" value="${fn:split(memberVO.m_address, '/')}" />
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
	$(document).ready(function(){
		document.getElementById("checkPrice").value = Number(${totalPrice});
		document.getElementById('checkPriceText').innerText = Number($("#checkPrice").val()).toLocaleString('ko-KR');
		document.getElementById("totalPrice").value = Number(${totalPrice});
		document.getElementById('totalPriceText').innerText = Number($("#totalPrice").val()).toLocaleString('ko-KR');
		$("input[name='product_check']").prop("checked", true); //전체 체크를 해준다 
		checkDrivePrice(${totalPrice});
	});
	
	// 체크박스 전체 선택
	$(function(){
			$("#product_check").on('click',function(){
				//체크박스 check상태가 true라면
				if($("#product_check").is(":checked"))  
				{
					$("input[name='product_check']").prop("checked", true);
					document.getElementById("checkPrice").value = Number(${totalPrice});
					document.getElementById('checkPriceText').innerText = Number($("#checkPrice").val()).toLocaleString('ko-KR') + "원";
					checkDrivePrice(${totalPrice});
				}
				else
				{
					$("input[name='product_check']").prop("checked", false);
					document.getElementById("checkPrice").value = 0;
					document.getElementById('checkPriceText').innerText = Number($("#checkPrice").val()).toLocaleString('ko-KR')+"원";
					checkDrivePrice(0);
				}
			});
			//하위 항목 클릭시 전체를 선택한 경우 상단의 체크박스도 바꿔주는 코드  
			$("input[name='product_check']").click(function() {
				var total = $("input[name='product_check']").length;
				var checked = $("input[name='product_check']:checked").length;
				if(total != checked) {
					$("#product_check").prop("checked", false);
				}
				else $("#product_check").prop("checked", true); 
			});
		});
	
	//선택된 값을 가져옴 
	function getCheckPrice(p_idx)  {
		let temp = 0;
		let checkPrice = Number($("#checkPrice").val());
		  if($("#product"+p_idx+"_check").is(":checked"))  {
			  temp = Number(checkPrice) + Number($("#checkProduct"+p_idx).val());
		  }
		  else{
			  temp = Number(checkPrice) - Number($("#checkProduct"+p_idx).val());
		  }
		document.getElementById("checkPrice").value = temp;
	  document.getElementById('checkPriceText').innerText = Number($("#checkPrice").val()).toLocaleString('ko-KR')+"원";
		checkDrivePrice(temp);
	}
	
	function checkDrivePrice(totalPrice){
		let DrivePrice = 0;
		if(totalPrice>50000 || totalPrice==0) DrivePrice = 0;
		else DrivePrice= 3000;
		document.getElementById("drivePrice").value = DrivePrice;
		document.getElementById('drivePriceText').innerText = Number($("#drivePrice").val()).toLocaleString('ko-KR')+"원";
		document.getElementById('totalPrice').value =DrivePrice + totalPrice;
		document.getElementById('totalPriceText').innerText = Number($("#totalPrice").val()).toLocaleString('ko-KR')+"원";
	}
	
	function deleteSelect(){
		let arr = [];
		let check = document.getElementsByName("product_check");
		let checkCount = 0;
		
		for(let i=0; i<check.length; i++){
			if(check[i].checked == true){
				arr.push(check[i].value);
				checkCount++;
			}
		}
		
		if (arr.length == 0){
			Swal.fire({
				width:500,
			  position: 'center',
			  icon: 'error',
			  title: '삭제하실 상품을 선택해 주세요.',
			  showConfirmButton: false,
			  timer: 1000
			})
			return;
		}
		
		Swal.fire({
			  title: '선택하신 '+checkCount+'개 상품을\n 장바구니에서 삭제하시겠습니까?',
			  showDenyButton: true,
			  confirmButtonText: '확인',
			  denyButtonText: '취소',
			}).then((result) => {
			  if (result.isConfirmed) {
					$.ajax({
						type : "post",
						url : "${ctp}/order/cartDelete",
						data : {arr: arr},
						success : function(res) {
							if(res==1){
								Swal.fire({
									width:500,
								  position: 'center',
								  icon: 'success',
								  title: '삭제 되었습니다.',
								  showConfirmButton: false,
								  timer: 1000
								})
								setTimeout(function(){
									location.reload();
								},1000);
							}
						},
						error : function() {
							alert("전송오류!");
						}
					});
			  }
			})
	}

	function movePayment(){
		//선택 상품 주문
		let arr = [];
		let check = document.getElementsByName("product_check");
		let checkCount = 0;
		let amountList = "";
		let productList = "";
		for(let i=0; i<check.length; i++){
			if(check[i].checked == true){
				arr.push(check[i].value); 
				productList += check[i].value + "/";
				amountList += $("#od_amount"+i).val() + "/";
			}
		}
				document.getElementById("productList").value = productList;
				document.getElementById("amountList").value = amountList;
				console.log($("#productList").val());
				console.log($("#amountList").val());
		
		if (arr.length == 0){
			Swal.fire({
				width:500,
			  position: 'center',
			  icon: 'error',
			  title: '주문하실 상품을 선택해 주세요.',
			  showConfirmButton: false,
			  timer: 1000
			})
			return;
		}
		
		orderForm.submit();
		
	}
	function movePaymentAll(){
		//선택 상품 주문
		let arr = [];
		let check = document.getElementsByName("product_check");
		let checkCount = 0;
		let amountList = "";
		let productList = "";
		for(let i=0; i<check.length; i++){
				arr.push(check[i].value); 
				productList += check[i].value + "/";
				amountList += $("#od_amount"+i).val() + "/";
		}
				document.getElementById("productList").value = productList;
				document.getElementById("amountList").value = amountList;
				console.log($("#productList").val());
				console.log($("#amountList").val());
		
		
		orderForm.submit();
		
	}
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/nav.jsp" />
	<form name="orderForm" id="orderForm" method="post"
		action="${ctp}/order/orderSheet">
		<div class="container mt-4">
			<div class="px-4 px-lg-0">
				<!-- For demo purpose -->
				<div class="container py-5 text-center">
					<h3>
						<b>장바구니</b>
					</h3>
					<hr>
					<div class="row">
						<div class="col-xl-12">
							<div class="d-flex justify-content-center align-items-center">
								<div class="progresses">
									<div class="steps">
										<span><i class="fas fa-shopping-cart"></i></span>
									</div>
									<span class="line inactive"></span> <span class="step-text">장바구니</span>
									<div class="steps inactive">
										<span><i class="fa fa-won-sign"></i></span>
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
												<th scope="col"
													class="col-md-2 col-xl-2 border-0 bg-dark text-white">
													<div class="p-2 px-3 text-uppercase">
														<div
															class="custom-control custom-checkbox custom-control-inline">
															<input type="checkbox" class="custom-control-input"
																name="product_checkAll" id="product_check" checked /> <label
																class="custom-control-label red" for="product_check">
															</label>
														</div>
													</div>
												</th>
												<th scope="col"
													class="col-md-4 col-xl-4 border-0 bg-dark text-white">
													<div class="p-2 px-3 text-uppercase">상품정보</div>
												</th>
												<th scope="col"
													class="col-md-2 col-xl-2 border-0 bg-dark text-white">
													<div class="py-2 text-uppercase">수량</div>
												</th>
												<th scope="col"
													class="col-md-2 col-xl-2 border-0 bg-dark text-white">
													<div class="py-2 text-uppercase">상품금액</div>
												</th>
											</tr>
										</thead>
										<tbody>
											<c:forEach var="productVO" items="${vos}" varStatus="st">
												<tr id="row${st.index}">
													<th scope="row" class="border-0">
														<div class="p-2 px-3 text-uppercase">
															<div
																class="custom-control custom-checkbox d-flex align-items-center"
																style="height: 100px">
																<c:if test="${productVO.p_amount!=0}">
																	<input type="checkbox" class="custom-control-input"
																		name="product_check"
																		id="product${productVO.p_idx}_check"
																		value="${productVO.p_idx}"
																		onchange="getCheckPrice(${productVO.p_idx})" />
																	<label class="custom-control-label black"
																		for="product${productVO.p_idx}_check"> </label>
																	<input type="hidden"
																		id="checkProduct${productVO.p_idx}"
																		value="${productVO.p_price * productVO.od_amount}">
																	<input type="hidden" id="od_amount${st.index}"
																		value="${productVO.od_amount}">
																</c:if>
															</div>
														</div>
													</th>
													<td class="border-0 align-middle">
														<div class="p-2">
															<div class="row">
																<div class="col-xl-3">
																	<img
																		src="${ctp}/data/product/${productVO.p_thumbnailIdx}"
																		alt="" width="70" class="img-fluid rounded shadow-sm">
																</div>
																<div class="col-xl-9">
																	<div class="ml-3 d-inline-block align-middle">
																		<h6 class="mb-0">
																			<a
																				href="${ctp}/product/productInfo?p_idx=${productVO.p_idx}"
																				class="extraText">${productVO.p_name}</a>
																		</h6>
																		<span
																			class="text-muted font-weight-normal font-italic d-block">${productVO.c_mainName}-${productVO.c_middleName}</span>
																	</div>
																</div>
															</div>
														</div>
													</td>
													<c:if test="${productVO.p_amount > 0}">
														<td class="border-0 align-middle"><strong>${productVO.od_amount}</strong></td>
														<td class="border-0 align-middle"><strong><fmt:formatNumber
																	value="${productVO.p_price * productVO.od_amount}"
																	pattern="#,###" />원</strong></td>
													</c:if>
													<c:if test="${productVO.p_amount == 0}">
														<td class="border-0 align-middle"><strong>품절</strong></td>
														<td class="border-0 align-middle"><strong>품절</strong></td>
													</c:if>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>
								<!-- End -->
								<input type="hidden" id="checkPrice" value="0"> <input
									type="hidden" id="drivePrice" value="0"> <input
									type="hidden" id="totalPrice" value="0"> <input
									type="hidden" name="productList" id="productList" value="">
								<input type="hidden" name="amountList" id="amountList" value="">


								<hr>
								<div style="color: #bbb;">
									<span>※ 상품 쿠폰 및 적립금 사용은 [주문서 작성/결제]에서 적용됩니다.</span><br /> <span>※
										장바구니는 접속 종료 후 7일간만 보관됩니다. 더 오래 보관하시려면 관심상품에 담아주세요.</span><br /> <span>※
										단독 배송 상품은 다른 상품과 함께 구매하실 수 없습니다.</span>
								</div>

								<div class="col-lg-12 p-5 bg-white rounded shadow-sm mb-5">
									<div
										class="d-flex flex-row justify-content-end align-items-center">
										<div class="p-2 mr-3 d-flex flex-column align-items-center">
											<span class="text-muted">선택 상품 금액</span>
											<h4 id="checkPriceText">원</h4>
										</div>
										<span class="p-2 mr-3"><i class="fa fa-plus circle"></i></span>
										<div class="p-2 mr-3 d-flex flex-column align-items-center">
											<span class="text-muted">배송비</span>
											<h4 id="drivePriceText">원</h4>
										</div>
										<span class="p-2  mr-3"><i class="fa fa-equals circle"></i></span>
										<div class="p-2 mr-3 d-flex flex-column align-items-center">
											<span class="text-muted">총 결제금액</span>
											<h4 id="totalPriceText">원</h4>
										</div>
									</div>
								</div>
								<div class="d-flex justify-content-between">
									<a href="javascript:deleteSelect()"
										class="btn btn-outline-dark py-2 ">선택 삭제</a>
									<div>
										<a href="javascript:movePayment()"
											class="btn btn-outline-danger py-2 ">선택 상품 주문</a> <a
											href="javascript:movePaymentAll()"
											class="btn btn-danger py-2">전체 상품 주문</a>
									</div>
								</div>
							</div>
						</div>

					</div>
				</div>
			</div>
		</div>
	</form>
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>