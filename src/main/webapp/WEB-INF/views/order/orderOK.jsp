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
<script src="${ctp}/js/order.js"></script>
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
</script>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/nav.jsp" />
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
								<span class="line"></span> <span class="step-text">주문/결제</span>
								<div class="steps ">
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
				<div class="container text-center">
					<div class="row clearfix">
						<div class="text-center mt-4" style="width: 100%">
							<div class="mt-4">
								<h2>주문이 정상적으로 완료되었습니다.</h2>
							</div>
							<div class="row mt-5">
								<div class="col-lg-3"></div>
								<div class="col-lg-6 bg-light rounded-2">
									<div class="p-4">
										<ul class="list-unstyled mb-4">
											<li class="d-flex justify-content-between py-3 border-bottom">
												<strong class="text-muted">주문번호 </strong> <strong>${vo.o_orderCode}</strong>
											</li>
											<li
												class="d-flex justify-content-between py-3 border-bottom ">
												<strong class="text-muted">배송지 정보</strong> <c:set var="addr"
													value="${fn:split(vo.attn_address, '/')}"></c:set> <strong
												class="text-right">${addr[1]}<br /> ${addr[2]} <c:if
														test="${addr[3]!=''}">(${addr[3]}) </c:if>
											</strong>
											</li>
											<li
												class="d-flex justify-content-between py-3 border-bottom ">
												<strong class="text-muted">결제 정보</strong> <strong
												class="text-right"> <c:if
														test="${vo.pay_method == 'card' }">
													카드결제<br />
													${vo.pay_cardName}<br />
													${vo.pay_cardCode}
													</c:if> <c:if test="${vo.pay_method == 'vbank' }">
													무통장입금<br />
													${vo.pay_vbankName}<br />
													${vo.pay_vbankNumber}<br />
													${vo.pay_vbankDate}까지<br />
													</c:if>
											</strong>
											</li>
										</ul>
										<a href="${ctp}/" class="btn btn-dark py-2 btn-block small">쇼핑
											계속하기</a>
									</div>
								</div>
								<div class="col-lg-3"></div>
							</div>



						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>