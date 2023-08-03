<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<html>
<head>
<title>파라다이스 | 메인</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<style>
body {
	font-family: 'Pretendard-Regular';
	padding-right: 0 !important
}
</style>
<link rel="icon" href="${ctp}/images/favicon.ico">
</head>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<link rel="stylesheet" href="${ctp}/css/product.css">
<link rel="stylesheet" href="${ctp}/css/style.css">
<body>
<body>


	<!-- Start Hero Section -->
	<div class="hero">
		<div class="container">
			<div class="row justify-content-between">
				<div class="col-lg-5">
					<div class="intro-excerpt">
						<h1>
							한 번 빠져들면 <span style="display: block;">헤어 나올 수 없는</span>
						</h1>
						<p class="mb-4">친구와, 가족과 함께 즐기는 보드게임 기획전! 오늘은 보드게임 어때요?</p>
						<p>
							<a href="${ctp}/product/productList/board"
								class="btn btn-secondary mr-3">바로가기</a>
							<!-- <a href="#" class="btn btn-white-outline">둘러보기</a> -->
						</p>
					</div>
				</div>
				<div class="col-lg-7">
					<div class="hero-img-wrap">
						<%-- <img src="${ctp}/images/dice.png" class="img-fluid"> --%>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- End Hero Section -->
	<div class="container-xl">
		<!-- Start Product Section -->
		<div class="product-section">
			<div class="container">
				<div class="row">

					<!-- Start Column 1 -->
					<div class="col-md-12 col-lg-3 mb-5 mb-lg-0">
						<h2 class="mb-4 section-title">둘이서 가볍게</h2>
						<p class="mb-4">
							보드게임에서 가장 어려운 게 뭔지 아세요?<br /> 그건 바로 함께 할 최소 4명의 친구를 구하는 것! 하지만 이
							게임들은 둘이서도 즐길 수 있어요!
						</p>
						<p>
							<a href="${ctp}/product/productList/puzzle" class="btn">더보기</a>
						</p>
					</div>
					<!-- End Column 1 -->

					<!-- Start Column 2 -->
					<div class="col-12 col-md-4 col-lg-3 mb-5 mb-md-0">
						<div class="cards pointer pointerBig"
							onclick="location.href='${ctp}/product/productInfo?p_idx=${vos[1].p_idx}'">
							<!-- Product image-->
							<img class="card-img-top" width="100" height="100"
								src="${ctp}/data/product/${vos[1].p_thumbnailIdx}" alt="..." />
							<!-- Product details-->
							<div class="card-body p-2">
								<div class="row p-1">
									<c:set var="discount"
										value="${((vos[1].p_origPrice - vos[1].p_price)/vos[1].p_origPrice)*100}"></c:set>
									<div class="col-sm-3 col-xl-3  product-sale pr-0"
										style="font-size: 12pt;">
										<fmt:formatNumber type="number" maxFractionDigits="0"
											value="${discount-(discount%1)}" />
										%
									</div>
									<div class="col-sm-9 col-xl-9 text-right product-text"
										style="font-size: 12pt;">
										<font color="#bbb"> <c:if test="${discount > 0 }">
												<del>
													<fmt:formatNumber value="${vos[1].p_origPrice}"
														pattern="#,###" />
													원
												</del>
											</c:if>
										</font> &nbsp; <b><span class="pl-1"><fmt:formatNumber
													value="${vos[1].p_price}" pattern="#,###" />원</span></b>
									</div>
								</div>
								<div class="row p-1">
									<div class="col-sm-12 col-xl-12 product-title pr-0"
										style="font-size: 14pt;">
										<b>${vos[1].p_name }</b>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- End Column 2 -->

					<!-- Start Column 3 -->
					<div class="col-12 col-md-4 col-lg-3 mb-5 mb-md-0">
						<div class="cards pointer pointerBig"
							onclick="location.href='${ctp}/product/productInfo?p_idx=${vos[2].p_idx}'">
							<!-- Product image-->
							<img class="card-img-top" width="100" height="100"
								src="${ctp}/data/product/${vos[2].p_thumbnailIdx}" alt="..." />
							<!-- Product details-->
							<div class="card-body p-2">
								<div class="row p-1">
									<c:set var="discount"
										value="${((vos[2].p_origPrice - vos[2].p_price)/vos[2].p_origPrice)*100}"></c:set>
									<div class="col-sm-3 col-xl-3  product-sale pr-0"
										style="font-size: 12pt;">
										<fmt:formatNumber type="number" maxFractionDigits="0"
											value="${discount-(discount%1)}" />
										%
									</div>
									<div class="col-sm-9 col-xl-9 text-right product-text"
										style="font-size: 12pt;">
										<font color="#bbb"> <c:if test="${discount > 0 }">
												<del>
													<fmt:formatNumber value="${vos[2].p_origPrice}"
														pattern="#,###" />
													원
												</del>
											</c:if>
										</font> &nbsp; <b><span class="pl-1"><fmt:formatNumber
													value="${vos[2].p_price}" pattern="#,###" />원</span></b>
									</div>
								</div>
								<div class="row p-1">
									<div class="col-sm-12 col-xl-12 product-title pr-0"
										style="font-size: 14pt;">
										<b>${vos[2].p_name }</b>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- End Column 3 -->

					<!-- Start Column 4 -->
					<div class="col-12 col-md-4 col-lg-3 mb-5 mb-md-0">
						<div class="cards pointer pointerBig"
							onclick="location.href='${ctp}/product/productInfo?p_idx=${vos[0].p_idx}'">
							<!-- Product image-->
							<img class="card-img-top" width="100" height="100"
								src="${ctp}/data/product/${vos[0].p_thumbnailIdx}" alt="..." />
							<!-- Product details-->
							<div class="card-body p-2">
								<div class="row p-1">
									<c:set var="discount"
										value="${((vos[0].p_origPrice - vos[0].p_price)/vos[0].p_origPrice)*100}"></c:set>
									<div class="col-sm-3 col-xl-3  product-sale pr-0"
										style="font-size: 12pt;">
										<fmt:formatNumber type="number" maxFractionDigits="0"
											value="${discount-(discount%1)}" />
										%
									</div>
									<div class="col-sm-9 col-xl-9 text-right product-text"
										style="font-size: 12pt;">
										<font color="#bbb"> <c:if test="${discount > 0 }">
												<del>
													<fmt:formatNumber value="${vos[0].p_origPrice}"
														pattern="#,###" />
													원
												</del>
											</c:if>
										</font> &nbsp; <b><span class="pl-1"><fmt:formatNumber
													value="${vos[0].p_price}" pattern="#,###" />원</span></b>
									</div>
								</div>
								<div class="row p-1">
									<div class="col-sm-12 col-xl-12 product-title pr-0"
										style="font-size: 14pt;">
										<b>${vos[0].p_name }</b>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- End Column 4 -->

				</div>
			</div>
		</div>
		<!-- End Product Section -->

		<!-- Start Why Choose Us Section -->
		<div class="why-choose-section">
			<div class="container">
				<div class="row justify-content-between">
					<div class="col-lg-6">
						<h2 class="section-title">요즘 따끈한 신작!</h2>
						<p>
							셰익스피어 소네트 속 숨겨진 연인은 누구일까요? <br />다크 레이디는 런던 브릿지를 건넜을까요?<br /> 다크
							레이디, 셰익스피어 시대 런던, 그리거 400여년의 미스터리!
						</p>

						<div class="row my-5">
							<div class="col-6 col-md-6">
								<div class="feature">
									<div class="icon">
										<i class="fa fa-stopwatch fa-2x"></i>
									</div>
									<h3>소요 시간</h3>
									<p>
										혼자서도 가볍게! <br /> 한 게임 당 30분의 시간이 소요됩니다.
									</p>
								</div>
							</div>

							<div class="col-6 col-md-6">
								<div class="feature">
									<div class="icon">
										<i class="fa fa-2x fa-user"></i>
									</div>
									<h3>참여 인원</h3>
									<p>
										혼자서도 가능!<br />물론 둘이서도 즐길 수 있어요!
									</p>
								</div>
							</div>

							<div class="col-6 col-md-6">
								<div class="feature">
									<div class="icon">
										<i class="fa fa-reply-all fa-2x"></i>
									</div>
									<h3>높은 리플레이성</h3>
									<p>
										알파벳 순열을 통해 매번 다른 시나리오를 구성하고, 5단계로 난이도를 조정할 수 있습니다!<br /> 순열
										선택을 통해 한번 더 난이도를 조절할 수 있어요!
									</p>
								</div>
							</div>

							<div class="col-6 col-md-6">
								<div class="feature">
									<div class="icon">
										<i class="fa fa-book fa-2x"></i>
									</div>
									<h3>몰입도 UP</h3>
									<p>셰익스피어 소네트와 다크 레이디 후보 여인들의 이야기, 그리고 당대 런던 명소를 삽화와 함께
										소개했습니다! 총 22페이지에 달하는 스터디북으로 더욱 몰입할 수 있어요!</p>
								</div>
							</div>

						</div>
					</div>

					<div class="col-lg-5">
						<div class="img-wrap">
							<img src="${ctp}/images/home_recommend.jpg" alt="Image"
								class="img-fluid">
						</div>
					</div>

					<p>
						<a href="${ctp}/product/productInfo?p_idx=20" class="btn">더보기</a>
					</p>

				</div>
			</div>
		</div>
		<!-- End Why Choose Us Section -->

		<!-- Start We Help Section -->
		<div class="we-help-section">
			<div class="container">
				<div class="row justify-content-between">
					<div class="col-lg-6 mb-5 mb-lg-0">
						<div class="imgs-grid">
							<div class="grid grid-2">
								<img class="img-wrap-middle" src="${ctp}/images/bullets.png"
									alt="Untree.co">
							</div>
							<div class="grid grid-3">
								<img class="border-circle" src="${ctp}/images/bang.png"
									alt="Untree.co">
							</div>
						</div>
					</div>
					<div class="col-lg-6 ps-lg-5">
						<h2 class="section-title mb-4">
							서부 황야에서 벌어지는<br /> 화끈한 총격전!
						</h2>
						<p>
							2002년 발매 이후로 20년째 최고의 인기를 구가하고 있는 게임!<br />세 가지 절묘한 심리전, 상대방의 숨겨진
							정체를 파악하는 묘미, 뱅! 한 번에 울고 웃는 재미까지!
						</p>

						<ul class="list-unstyled custom-list my-4">
							<li>숨막히는 서부의 총격전! <br /> 서로 목적이 다른 총잡이들이 마을에 모였습니다.
							</li>
							<li>과연 보안관은 이들 중 악당을 골라내고 마을을 지킬 수 있을까요? 역할 카드 7장과 인물카드 16장의
								구성!</li>
							<li>쉬운 플레이 규칙으로 누구나 쉽고 빠르게 적응할 수 있어요.</li>
							<li>7인 이상의 보드게임을 원한다면, BANG!</li>
						</ul>
						<p>
							<a href="${ctp}/product/productInfo?p_idx=38" class="btn">더보기</a>
						</p>
					</div>
				</div>
			</div>
		</div>
		<!-- End We Help Section -->


		<!-- Start Blog Section -->
		<div class="blog-section">
			<div class="container">
				<div class="row mb-5">
					<div class="col-md-6">
						<h2 class="section-title">최근 리뷰가 올라온 상품</h2>
					</div>
				</div>

				<div class="row">
					<c:forEach var="vo" items="${reviewVOS}">
						<div class="col-12 col-sm-6 col-md-4 mb-4 mb-md-0">
							<div class="post-entry">
								<a href="${ctp}/product/productInfo?p_idx=${vo.p_idx}"
									class="post-thumbnail"><img
									src="${ctp}/data/product/${vo.p_thumbnailIdx}" alt="Image"
									class="img-fluid"></a>
								<div class="post-content-entry">
									<h3>
										<a href="#">${vo.review_content}</a>
									</h3>
									<div class="meta">
										<span>by <a href="#">${vo.m_mid}</a></span> <span>on <a
											href="#">${fn:substring(vo.review_date,0,16)}</a></span>
									</div>
								</div>
							</div>
						</div>
					</c:forEach>
				</div>
			</div>
		</div>
		<!-- End Blog Section -->
	</div>
	<a href="#" class="btn btn-lg btn-danger btn-lg-square back-to-top"><i
		class="bi bi-arrow-up"></i></a>

	<jsp:include page="/WEB-INF/views/include/footer.jsp" />

	<!-- <script src="js/bootstrap.bundle.min.js"></script>
		<script src="js/tiny-slider.js"></script>
		<script src="js/custom.js"></script> -->
</body>
</html>
