<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
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
			
		//-----------------팝업
		
		function showPopUp(o_idx, p_idx, oi_productCode) {
			var width = 550;
			var height = 850;
			
			//pc화면기준 가운데 정렬
			var left = (window.screen.width / 2) - (width/2);
			var top = (window.screen.height / 4) - (height/4);
			
		    	//윈도우 속성 지정
			var windowStatus = 'width='+width+', height='+height+', left='+left+', top='+top+', scrollbars=yes, status=yes, resizable=yes, titlebar=yes';
			
		    	//연결하고싶은url
		    	const url = "${ctp}/member/myPage/myOrder/reviewForm?o_idx="+o_idx+"&p_idx="+p_idx+"&oi_productCode='"+oi_productCode+"'";

			//등록된 url 및 window 속성 기준으로 팝업창을 연다.
			window.open(url, "hello popup", windowStatus);
		}
		
		function purchaseConfirm(oi_productCode, totalPrice){
			Swal.fire({
				  title: '구매확정 하시겠습니까?',
				  showDenyButton: true,
				  width:400,
				  confirmButtonColor: 'grey',
				  confirmButtonText: '확인',
				  denyButtonText: '취소',
				}).then((result) => {
				  if (result.isConfirmed) {
				    $.ajax({
				    	type: "post",
							url: "${ctp}/order/purchaseConfirm",
							data: {
								oi_productCode : oi_productCode,
								totalPrice : totalPrice
										 },
							success: function(res){
							if(res=="1"){
								Swal.fire({
									width:500,
								  position: 'center',
								  icon: 'success',
								  title: '구매확정 되었습니다!',
								  showConfirmButton: false,
								  timer: 1500
								})
								setTimeout(function(){
									location.reload();
								},1500);
							}
						}
				    });
				  }
				})
		}
		
		
		function showCancelPopUp(o_idx, p_idx, oi_productCode, pay_method, imp_uid) {
			var width = 550;
			var height = 850;
			
			var left = (window.screen.width / 2) - (width/2);
			var top = (window.screen.height / 4) - (height/4);
			
			var windowStatus = 'width='+width+', height='+height+', left='+left+', top='+top+', scrollbars=yes, status=yes, resizable=yes, titlebar=yes';
    	const url = "${ctp}/member/myPage/myOrder/cancelForm?o_idx="+o_idx
    			+"&p_idx="+p_idx+"&oi_productCode='"+oi_productCode+"'"+"&pay_method='"+pay_method+"'&imp_uid="+imp_uid;

			//등록된 url 및 window 속성 기준으로 팝업창을 연다.
			window.open(url, "hello popup", windowStatus);
		}
		
		
		function showRefundPopUp(o_idx, p_idx, oi_productCode, pay_method) {
			var width = 550;
			var height = 850;
			
			var left = (window.screen.width / 2) - (width/2);
			var top = (window.screen.height / 4) - (height/4);
			
			var windowStatus = 'width='+width+', height='+height+', left='+left+', top='+top+', scrollbars=yes, status=yes, resizable=yes, titlebar=yes';
    	const url = "${ctp}/member/myPage/myOrder/refundForm?o_idx="+o_idx
    			+"&p_idx="+p_idx+"&oi_productCode='"+oi_productCode+"'"+"&pay_method='"+pay_method+"'";

			//등록된 url 및 window 속성 기준으로 팝업창을 연다.
			window.open(url, "hello popup", windowStatus);
		}
		
		function showOrder(o_idx) {
			//창 크기 지정
			var width = 550;
			var height = 850;
			
			//pc화면기준 가운데 정렬
			var left = (window.screen.width / 2) - (width/2);
			var top = (window.screen.height / 4) - (height/4);
			
		    	//윈도우 속성 지정
			var windowStatus = 'width='+width+', height='+height+', left='+left+', top='+top+', scrollbars=yes, status=yes, resizable=yes, titlebar=yes';
			
		    	//연결하고싶은url
		    	const url = "${ctp}/member/myPage/myOrderForm?o_idx="+o_idx;

			//등록된 url 및 window 속성 기준으로 팝업창을 연다.
			window.open(url, "hello popup", windowStatus);
		}
		</script>
</head>

<body>

	<jsp:include page="/WEB-INF/views/include/nav.jsp" />
	<div class="container-xl position-relative bg-white d-flex p-0 mypage">

		<jsp:include page="/WEB-INF/views/member/myPage/myPageNav.jsp" />
		<div>
			<div class="container-fluid pt-4 px-4">
				<div class="row g-4 bg-dark rounded m-0">
					<div class="col-sm-5 col-xl-5 d-flex">
						<div class="d-flex align-items-center justify-content-between p-3">
							<div class="d-flex flex-column gmarketSans">
								<span class="text-muted" style="font-size: 12pt">${sMid}님의</span>
								<span class="text-white">회원 등급은 ${strLevel}입니다.</span>
							</div>
						</div>
					</div>
					<div class="col-sm-3 col-xl-3">
						<div
							class="d-flex flex-column align-items-center justify-content-between p-3">
							<div class="ms-3 mt-3">
								<p class="mb-2 text-grey" style="font-size: 13pt">보유 적립금</p>
							</div>
							<div class="ms-3 mt-2">
								<h2 class="mb-2 text-white">${memberVO.m_point}</h2>
							</div>
						</div>
					</div>
					<div class="col-sm-2 col-xl-2">
						<div
							class="d-flex flex-column align-items-center justify-content-between p-3">
							<div class="ms-3 mt-3">
								<p class="mb-2 text-grey" style="font-size: 13pt">보유 쿠폰</p>
							</div>
							<div class="ms-3 mt-2">
								<h2 class="mb-2 text-white">${couponCnt}</h2>
							</div>
						</div>
					</div>
					<div class="col-sm-2 col-xl-2">
						<div
							class="d-flex flex-column align-items-center justify-content-between p-3">
							<div class="ms-3 mt-3">
								<p class="mb-2 text-grey" style="font-size: 13pt">주문/배송</p>
							</div>
							<div class="ms-3 mt-2">
								<h2 class="mb-2 text-white">${orderItems }</h2>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- Sale & Revenue End -->


			<!-- Sales Chart Start -->
			<div class="container-fluid pt-4 px-4">
				<div class="row g-4">
					<div class="col-sm-12 col-xl-12 mb-4">
						<div class="text-center rounded p-4">
							<div
								class="d-flex align-items-center justify-content-between mb-4 mt-2 border-bottom-design">
								<div class="d-flex mb-1">
									<h4 class="mb-0 pretendard mr-2">최근 주문내역</h4>
									<span class="pretendard extraText pt-1">최근 30일 내에 주문하신
										내역입니다.</span>
								</div>
								<a href="${ctp}/member/myOrderList">Show All</a>
							</div>
							<!-- Recent Sales Start -->
							<div class="table-responsive">
								<table class="table text-start align-middle table-hover mb-0">
									<thead>
										<tr class="text-dark bg-light pretendard"
											style="font-size: 14pt">
											<th scope="col">날짜/주문코드</th>
											<th scope="col"></th>
											<th scope="col">상품명</th>
											<th scope="col">결제금액</th>
											<th scope="col">처리상태</th>
											<th scope="col">상세</th>
										</tr>
									</thead>
									<tbody id="recentOrder">
										<c:forEach var="vo" items="${vos}" varStatus="st">
											<tr>
												<td>${fn:substring(vo.o_date,0,10)}<br />${vo.o_orderCode}<br />
													<c:if test="${vo.cs_status == null && vo.o_status=='배송완료'}">
														<!-- 배송완료 이후 교환/반품 버튼이 떠야함 -->
														<a class='btn btn-sm btn-outline-danger'
															href='javascript:showRefundPopUp(${vo.o_idx},${vo.p_idx},"${vo.oi_productCode}","${vo.pay_method}")'>교환/반품</a>
													</c:if> <!-- 결제완료/결제 대기중에는 주문취소 버튼이 떠야함 --> <c:if
														test="${vo.cs_status == null  && (vo.o_status=='결제완료' || vo.o_status=='결제대기')}">
														<a class='btn btn-sm btn-outline-danger'
															href='javascript:showCancelPopUp(${vo.o_idx},${vo.p_idx},"${vo.oi_productCode}","${vo.pay_method}","${vo.imp_uid}")'>주문취소</a>
													</c:if>
												</td>
												<td class='text-left' colspan='2'><span
													class='d-flex align-items-center'> <img
														src='${ctp}/data/product/${vo.p_thumbnailIdx}'
														width='80px' class='order-image mr-2'> <span>
															${vo.p_name}<br /> <a class='text-danger'
															href='javascript:showOrder(${vo.o_idx})'>주문상세 <i
																class='fas fa-chevron-right'></i>
														</a>
													</span></span></td>
												<td>${vo.totalPrice}</td>
												<td><c:if test="${vo.cs_status != null}">${vo.cs_status}</c:if>
													<c:if test="${vo.cs_status == null}"> ${vo.o_status}</c:if>
												</td>
												<td width='100px'><c:if
														test="${vo.o_status=='배송완료' &&  vo.o_status != '구매확정' && vo.cs_status == null}">
														<a class='btn btn-sm btn-danger' id="purchaseConfirm"
															href='javascript:purchaseConfirm("${vo.oi_productCode}",${vo.totalPrice})'>구매확정</a>
														<br />
													</c:if> <c:if test="${vo.o_status == '구매확정' && !vo.reviewOK}">
														<a class='btn btn-sm btn-outline-secondary mt-2'
															href='javascript:showPopUp(${vo.o_idx},${vo.p_idx},"${vo.oi_productCode}")'>리뷰작성</a>
													</c:if></td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>



						</div>
					</div>
					<%-- <div class="col-sm-12 col-xl-12 mb-4">
                        <div class="bg-light text-center rounded p-4">
                            <div class="d-flex align-items-center justify-content-between mb-4">
                                <h6 class="mb-0 gmarketSans">찜한 상품</h6>
                                <a href="">Show All</a>
                            </div>
                            <canvas id="totalPrice-result"></canvas>
                        </div>
                    </div>
                    <div class="col-sm-12 col-xl-12">
                        <div class="bg-light text-center rounded p-4">
                            <div class="d-flex align-items-center justify-content-between mb-4">
                                <h6 class="mb-0 gmarketSans">작성한 리뷰</h6>
                                <a href="">Show All</a>
                            </div>
                            <canvas id="totalPrice-result"></canvas>
                        </div>
                    </div> --%>
				</div>
			</div>
			<!-- Content End -->
		</div>
	</div>
	</div>


	<!-- Back to Top -->
	<a href="#" class="btn btn-lg btn-danger btn-lg-square back-to-top"><i
		class="bi bi-arrow-up"></i></a>
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>

</html>