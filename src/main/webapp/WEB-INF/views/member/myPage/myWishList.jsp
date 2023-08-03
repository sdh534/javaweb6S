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
		


		</script>
</head>

<body>

	<jsp:include page="/WEB-INF/views/include/nav.jsp" />
	<div class="container-xl position-relative bg-white d-flex p-0 mypage">

		<jsp:include page="/WEB-INF/views/member/myPage/myPageNav.jsp" />


		<!-- Sales Chart Start -->
		<div class="container-fluid pt-4 px-4">
			<div class="row g-4">
				<div class="col-sm-12 col-xl-12 mb-4">
					<div class="text-center rounded p-4">
						<div
							class="d-flex align-items-center justify-content-between mb-4 mt-2 border-bottom-design">
							<div class="d-flex mb-1">
								<h4 class="mb-0 pretendard mr-2">위시리스트</h4>
							</div>
						</div>

						<div class="table-responsive">
							<table class="table text-start align-middle table-hover mb-0">
								<thead>
									<tr class="text-dark bg-light pretendard"
										style="font-size: 14pt">
										<th scope="col">
											<!-- <div class="custom-control custom-checkbox custom-control-inline">
																	<input type="checkbox" class="custom-control-input" name="product_checkAll"
																		id="product_check" checked/> <label
																		class="custom-control-label red" for="product_check">  </label>
																	</div> -->
										</th>
										<th scope="col"></th>
										<th scope="col">상품명</th>
										<th scope="col">금액</th>
									</tr>
								</thead>
								<tbody id="recentOrder">
									<c:forEach var="vo" items="${vos}" varStatus="st">
										<tr>
											<td>
												<%-- <div class="custom-control custom-checkbox d-flex align-items-center justify-content-center" style="height:100px">
																	<input type="checkbox" class="custom-control-input" name="product_check"
																		id="product${vo.p_idx}_check" value="${vo.p_idx}"/> 
																		<label class="custom-control-label black" for="product${vo.p_idx}_check">  </label>
																	</div> --%>
											</td>
											<td class='text-left' colspan='2'><span
												class='d-flex align-items-center'> <img
													src='${ctp}/data/product/${vo.p_thumbnailIdx}' width='80px'
													class='order-image mr-2'> <span> ${vo.p_name}<br />
														<a class='text-danger'
														href='${ctp}/product/productInfo?p_idx=${vo.p_idx}'>상품상세
															<i class='fas fa-chevron-right'></i>
													</a>
												</span></span></td>
											<td>${vo.p_price}</td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>

						<!-- 블록 페이징 처리 -->
						<div class="text-center m-4">
							<ul class="pagination justify-content-center pagination-sm">
								<c:if test="${pageVO.pag > 1}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/member/myWishList?pageSize=${pageVO.pageSize}&pag=1">첫페이지</a></li>
								</c:if>
								<c:if test="${pageVO.curBlock > 0}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/member/myWishList?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}">이전블록</a></li>
								</c:if>
								<c:forEach var="i"
									begin="${pageVO.curBlock*pageVO.blockSize + 1}"
									end="${pageVO.curBlock*pageVO.blockSize + pageVO.blockSize}"
									varStatus="st">
									<c:if test="${i <= pageVO.totPage && i == pageVO.pag}">
										<li class="page-item active"><a
											class="page-link text-white bg-secondary border-secondary"
											href="javascript:nextPage(${pageVO.pageSize},${i})">${i}</a></li>
									</c:if>
									<c:if test="${i <= pageVO.totPage && i != pageVO.pag}">
										<li class="page-item"><a class="page-link text-secondary"
											href="${ctp}/member/myWishList?pageSize=${pageVO.pageSize}&pag=${i}">${i}</a></li>
									</c:if>
								</c:forEach>
								<c:if test="${pageVO.curBlock < pageVO.lastBlock}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/member/myWishList?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock+1)*pageVO.blockSize + 1}">다음블록</a></li>
								</c:if>
								<c:if test="${pageVO.pag < pageVO.totPage}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/member/myWishList?pageSize=${pageVO.pageSize}&pag=${pageVO.totPage}">마지막페이지</a></li>
								</c:if>
							</ul>
						</div>


					</div>
				</div>
			</div>
		</div>
		<!-- Content End -->


		<!-- Back to Top -->
		<a href="#" class="btn btn-lg btn-danger btn-lg-square back-to-top"><i
			class="bi bi-arrow-up"></i></a>
	</div>
	</div>

	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>

</html>