<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파라다이스 | 상품 검색</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<link rel="icon" href="${ctp}/images/favicon.ico">
</head>
<link rel="stylesheet" href="${ctp}/css/product.css">
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<body>
	<!-- Section-->
	<section class="py-5">
		<div class="container px-4 px-lg-5 mt-5">
			<div
				class="d-flex justify-content-between align-items-center pb-3 border-black">
				<div class="gmarketSANS">
					<h3>${title}- ${searchKeyword}</h3>
				</div>
				<div class="d-flex">
					<font color="red">검색결과 <b>${totRecCnt}</b>개
					</font>
					<div class="ml-3">
						<select class="btn p-0 h-100" name="pageNum"
							style="font-size: 11pt;">
							<option>보기</option>
							<option value="20">20개</option>
							<option value="30">30개</option>
							<option value="40">40개</option>
						</select>
					</div>
				</div>
			</div>
			<div class="text-right">
				<div class="pick_list_box">
					<ul class="pick_list ">
						<li class="custom-control custom-radio custom-control-inline ml-3">
							<input class="custom-control-input" type="radio" name="sort"
							id="sort1" value="1"
							<c:if test="${sort == 'low-price'}">checked</c:if>
							onclick="location.href='${ctp}/product/productSearch?searchKeyword=${searchKeyword}&sort=low-price'">
							<label class="custom-control-label" for="sort1">낮은가격순</label>
						</li>
						<li class="custom-control custom-radio custom-control-inline ml-3">
							<input class="custom-control-input" type="radio" name="sort"
							id="sort2" value="1"
							<c:if test="${sort == 'high-price' }">checked</c:if>
							onclick="location.href='${ctp}/product/productSearch?searchKeyword=${searchKeyword}&sort=high-price'">
							<label class="custom-control-label" for="sort2">높은가격순</label>
						</li>
						<li class="custom-control custom-radio custom-control-inline ml-3">
							<input class="custom-control-input" type="radio" name="sort"
							id="sort3" value="1"
							<c:if test="${sort == 'review'}">checked</c:if>
							onclick="location.href='${ctp}/product/productSearch?searchKeyword=${searchKeyword}&sort=review'">
							<label class="custom-control-label" for="sort3">상품평순</label>
						</li>
						<li class="custom-control custom-radio custom-control-inline ml-3">
							<input class="custom-control-input" type="radio" name="sort"
							id="sort4" value="1"
							<c:if test="${sort == '' || sort =='latest'}">checked</c:if>
							onclick="location.href='${ctp}/product/productSearch?searchKeyword=${searchKeyword}&sort=latest'">
							<label class="custom-control-label" for="sort4">등록일순</label>
						</li>
					</ul>
					<!-- //choice_num_view -->
				</div>
			</div>


			<div
				class="row gx-4 gx-lg-5 row-cols-2 row-cols-md-3 row-cols-xl-4 justify-content-center align-items-center">
				<c:forEach var="vo" items="${vos}" varStatus="st">
					<div class="col mb-3 ">
						<div class="cards pointer pointerBig"
							onclick="location.href='${ctp}/product/productInfo?p_idx=${vo.p_idx}'">
							<!-- Product image-->
							<c:set var="thumbnail" value="${fn:split(vo.p_image, '/')}" />
							<c:if test="${vo.p_amount == 0}">
								<div class="soldout">
									<span>품절</span>
								</div>
							</c:if>
							<img class="card-img-top" width="100" height="100"
								src="${ctp}/data/product/${thumbnail[0]}" alt="..." />
							<!-- Product details-->
							<div class="card-body p-2">
								<div class="row p-1">
									<c:set var="discount"
										value="${((vo.p_origPrice - vo.p_price)/vo.p_origPrice)*100}"></c:set>
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
													<fmt:formatNumber value="${vo.p_origPrice}" pattern="#,###" />
													원
												</del>
											</c:if>
										</font> &nbsp; <b><span class="pl-1"><fmt:formatNumber
													value="${vo.p_price}" pattern="#,###" />원</span></b>
									</div>
								</div>
								<div class="row p-1">
									<div class="col-sm-12 col-xl-12 product-title pr-0"
										style="font-size: 14pt;">
										<b>${vo.p_name }</b>
									</div>
								</div>
								<div class="row p-1">
									<!-- 별점 부분 -->
									<div class="col-sm-6 col-xl-6">
										<div class="ratings d-flex flex-row align-items-center pr-0">
											<div class="d-flex flex-row">
												<div class="rating">
													<div class="w-100">
														<div id="star-rating">
															★★★★★ <span id="star-rating-checked"
																class="productNum${st.index}">★★★★★</span>
														</div>
													</div>
													<script>
													$(".productNum${st.index}").css(
															"width", ${vo.p_rating*20}+"%");
												</script>
												</div>
											</div>
										</div>
									</div>
									<div
										class="col-sm-6 col-xl-6 d-flex align-items-center pl-0 pretendard"
										style="font-size: 12pt;">
										· 리뷰 <font color="red">&nbsp;${vo.p_reviewCnt}</font>
									</div>
								</div>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>

			<!-- 블록 페이징 처리 -->
			<div class="text-center m-4">
				<ul class="pagination justify-content-center pagination-sm">
					<c:if test="${pageVO.pag > 1}">
						<li class="page-item"><a class="page-link text-secondary"
							href="${ctp}/product/productSearch?searchKeyword=${searchKeyword}&pageSize=${pageVO.pageSize}&pag=1&sort=${sort}&middleCategory=${middleCategory}">첫페이지</a></li>
					</c:if>
					<c:if test="${pageVO.curBlock > 0}">
						<li class="page-item"><a class="page-link text-secondary"
							href="${ctp}/product/productSearch?searchKeyword=${searchKeyword}&pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}&sort=${sort}&middleCategory=${middleCategory}">이전블록</a></li>
					</c:if>
					<c:forEach var="i" begin="${pageVO.curBlock*pageVO.blockSize + 1}"
						end="${pageVO.curBlock*pageVO.blockSize + pageVO.blockSize}"
						varStatus="st">
						<c:if test="${i <= pageVO.totPage && i == pageVO.pag}">
							<li class="page-item active"><a
								class="page-link text-white bg-secondary border-secondary"
								href="javascript:nextPage(${pageVO.pageSize},${i})">${i}</a></li>
						</c:if>
						<c:if test="${i <= pageVO.totPage && i != pageVO.pag}">
							<li class="page-item"><a class="page-link text-secondary"
								href="${ctp}/product/productSearch?searchKeyword=${searchKeyword}&pageSize=${pageVO.pageSize}&pag=${i}&sort=${sort}&middleCategory=${middleCategory}">${i}</a></li>
						</c:if>
					</c:forEach>
					<c:if test="${pageVO.curBlock < pageVO.lastBlock}">
						<li class="page-item"><a class="page-link text-secondary"
							href="${ctp}/product/productSearch?searchKeyword=${searchKeyword}&pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock+1)*pageVO.blockSize + 1}&sort=${sort}&middleCategory=${middleCategory}">다음블록</a></li>
					</c:if>
					<c:if test="${pageVO.pag < pageVO.totPage}">
						<li class="page-item"><a class="page-link text-secondary"
							href="${ctp}/product/productSearch?searchKeyword=${searchKeyword}&pageSize=${pageVO.pageSize}&pag=${pageVO.totPage}&sort=${sort}&middleCategory=${middleCategory}">마지막페이지</a></li>
					</c:if>
				</ul>
			</div>


		</div>
	</section>

	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>