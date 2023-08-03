<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>파라다이스 | 상품정보</title>
<link rel="icon" href="${ctp}/images/favicon.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script>
	'use strict';
	function changeImage(element) {
    var main_prodcut_image = document.getElementById('main_product_image');
    main_prodcut_image.src = element.src;
  }

	function buyNow(){
		cart.submit();
	}
	
	function cartNow(){
		$.ajax({
			type : "post",
			url : "${ctp}/order/orderCart",
			data : {
				m_mid: "${sMid}",
				p_idx: ${vo.p_idx},
				od_amount: $("#od_amount").val()
			},
			success : function(res) {
				if(res=="1"){
					Swal.fire({
						  title: '상품이 장바구니에 담겼습니다.\n바로 확인하시겠습니까?',
						  showDenyButton: true,
						  width:400,
						  imageUrl: "${ctp}/images/shoppingCart.png",
					    imageWidth: 100,
					    imageHeight: 100,
						  confirmButtonColor: 'grey',
						  confirmButtonText: '확인',
						  denyButtonText: '취소',
						}).then((result) => {
						  if (result.isConfirmed) {
						   location.href='${ctp}/order/orderCart';
						  }
						})
				}
				else{
				 	Swal.fire({
						  title: '로그인 후 사용하실 수 있습니다.\n로그인 창으로 이동하시겠습니까?',
						  showDenyButton: true,
						  width:400,
						  imageUrl: "${ctp}/images/loginLock.png",
					    imageWidth: 120,
					    imageHeight: 100,
						  confirmButtonColor: 'grey',
						  confirmButtonText: '확인',
						  denyButtonText: '취소',
						}).then((result) => {
						  if (result.isConfirmed) {
							  $('#loginModal').modal('show');
						  }
						}) 
						
				}
			},
			error : function() {
				alert("전송오류!");
			}
		});
	}
	
	$(document).on('click', '.number-spinner button', function () {    
		var btn = $(this),
			oldValue = btn.closest('.number-spinner').find('input').val().trim(),
			newVal = 0;
		
		if (btn.attr('data-dir') == 'up') {
			newVal = parseInt(oldValue) + 1;
		} else {
			if (oldValue > 1) {
				newVal = parseInt(oldValue) - 1;
			} else {
				newVal = 1;
			}
		}
		$("#quantity_number").text(newVal);
		let totalPrice = newVal*${vo.p_price};
		totalPrice = totalPrice.toLocaleString('ko-KR');
		$("#totalPrice").text(totalPrice+"원");
		btn.closest('.number-spinner').find('input').val(newVal);
	});
	
	$(document).ready(function(){
		$("#c_count").change(function(){
			let totalPrice = $("#od_amount").val()*${vo.p_price};
			totalPrice = totalPrice.toLocaleString('ko-KR');
			$("#quantity_number").text($("#od_amount").val());
			$("#totalPrice").text(totalPrice+"원");
		});
		$(".review-bottom").hide();
		
		$(".clickPrevent").click(function(e){
			   e.stopPropagation();
			})
		
	});
	
	
	function reviewExpand(review_idx){
		$("#review-bottom"+review_idx).toggle();
	}
	function showQnAPopUp(p_idx) {
		var width = 550;
		var height = 650;
		
		//pc화면기준 가운데 정렬
		var left = (window.screen.width / 2) - (width/2);
		var top = (window.screen.height / 4) - (height/4);
		
	    	//윈도우 속성 지정
		var windowStatus = 'width='+width+', height='+height+', left='+left+', top='+top+', scrollbars=yes, status=yes, resizable=yes, titlebar=yes';
		
	    	//연결하고싶은url
	    	const url = "${ctp}/product/productQnA?p_idx="+p_idx;

		//등록된 url 및 window 속성 기준으로 팝업창을 연다.
		window.open(url, "hello popup", windowStatus);
	}
	
	
	function secret(){
		alert("비공개 문의내역은 작성자 본인만 확인하실 수 있습니다.");
	}
	
	function likeReview(review_idx, review_thumb){
		if("${sMid}"==""){
			$('#loginModal').modal('show');
			return false;
		}
		
		$.ajax({
			type: "post",
			url: "${ctp}/product/reviewThumb",
			data: {review_idx: review_idx},
			success:function(res){
				if(res=="0") {
					Swal.fire({
						width:500,
					  position: 'center',
					  icon: 'error',
					  title: '이미 좋아요 버튼을 누르셨습니다!',
					  showConfirmButton: false,
					  timer:1000
					})
				}
				else {
					$("#reviewThumbValue"+review_idx).text(review_thumb+1);
				};
			},
			error: function(){
				alert("전송오류!");
			}
			
		});
	}
	
	

	function reviewDelete(review_idx){
		Swal.fire({
			  title: '선택하신 리뷰를 삭제하시겠습니까?',
			  showDenyButton: true,
			  confirmButtonColor: 'grey',
			  confirmButtonText: '확인',
			  denyButtonText: '취소',
			}).then((result) => {
			  if (result.isConfirmed) {
			    $.ajax({
			    	type: "post",
			    	data: {review_idx : review_idx},
						url: "${ctp}/member/reviewDelete",
						success: function(res){
						if(res=="1"){
							Swal.fire({
								width:500,
							  position: 'center',
							  icon: 'success',
							  title: '삭제 되었습니다.',
							  showConfirmButton: false,
							  timer: 1500
							})
							setTimeout(function(){location.reload();},1500);
						}
					}
			    });
			  }
			})
	}
	
	function reviewUpdate(review_idx){
		var width = 550;
		var height = 850;
		
		var left = (window.screen.width / 2) - (width/2);
		var top = (window.screen.height / 4) - (height/4);
		
		var windowStatus = 'width='+width+', height='+height+', left='+left+', top='+top+', scrollbars=yes, status=yes, resizable=yes, titlebar=yes';
	const url = "${ctp}/member/reviewUpdate?review_idx="+review_idx;

		//등록된 url 및 window 속성 기준으로 팝업창을 연다.
		window.open(url, "hello popup", windowStatus);
	}
	
	function wishlist(p_idx){
		 $.ajax({
		    	type: "post",
		    	data: {p_idx : p_idx},
					url: "${ctp}/member/wishList",
					success: function(res){
					if(res=="OK"){
						Swal.fire({
							width:500,
						  position: 'center',
						  icon: 'success',
						  title: '위시리스트에 등록되었습니다.',
						  showConfirmButton: false,
						  timer: 1500
						})
						setTimeout(function(){
							$("#toggleBtn").addClass("activeRed");
							$(".heart").addClass("activeRed");
							},1500);
					}
					else if(res=="NO"){
						Swal.fire({
							width:500,
						  position: 'center',
						  icon: 'success',
						  title: '위시리스트에서 삭제되었습니다.',
						  showConfirmButton: false,
						  timer: 1500
						})
						setTimeout(function(){
							$("#toggleBtn").removeClass("activeRed");
							$(".heart").removeClass("activeRed");
							},1500);
						
					}
					
					}
				});
	}
	
	function sortAnswer(p_idx){
		location.href="${ctp}/product/productInfo?p_idx="+p_idx+"&paging=QnA&sortAnswer="+$("#answerOK").val();
	}
	
</script>
</head>
<jsp:include page="/WEB-INF/views/include/nav.jsp" />
<link rel="stylesheet" href="${ctp}/css/product.css">
<body>

	<div class="container mt-5 mb-5">
		<div class="card">
			<div class="row g-0">
				<div class="col-md-6 border-end">
					<div class="d-flex flex-column justify-content-center">
						<c:set var="image" value="${fn:split(vo.p_image, '/')}"></c:set>
						<div class="main_image">
							<img src="${ctp}/data/product/${image[0]}"
								id="main_product_image" width="350">
						</div>
						<div class="thumbnail_images">
							<ul id="thumbnail">
								<c:forEach var="i" items="${image}" varStatus="st">
									<li><img onclick="changeImage(this)"
										src="${ctp}/data/product/${i}" width="70"></li>
								</c:forEach>
							</ul>
						</div>
					</div>
				</div>
				<div class="col-md-6">
					<div class="p-3 right-side">
						<form name="cart" method="post"
							action="${ctp}/order/orderOneSheet">
							<div class="d-flex justify-content-between align-items-center">
								<h3 class="product-title">
									<b>${vo.p_name}</b>
								</h3>
								<span class="heart <c:if test="${wishList}">activeRed</c:if>"
									onclick="wishlist(${vo.p_idx})"><i id="toggleBtn"
									class='fa fa-heart <c:if test="${wishList}">activeRed</c:if>'></i></span>
							</div>
							<div class="row">
								<div class="col-md-3 product-sale">
									<span>30%</span>
								</div>
								<div class="col-md-9 product-text">
									<font color="#bbb"><del>
											<fmt:formatNumber value="${vo.p_origPrice}" pattern="#,###" />
											원
										</del></font> <b><span class="pl-3"><fmt:formatNumber
												value="${vo.p_price}" pattern="#,###" />원</span></b>
								</div>
							</div>

							<!-- 별점 부분 -->
							<div class="ratings d-flex flex-row align-items-center">
								<div class="d-flex flex-row">
									<div class="rating">
										<div class="w-100">
											<div id="star-rating">
												★★★★★ <span id="star-rating-checked">★★★★★</span>
											</div>
										</div>
										<script>$("#star-rating-checked").css("width", ${vo.p_rating*20}+"%");</script>
									</div>
								</div>
							</div>

							<div class="card mt-3">
								<span><b>고객님을 위한 혜택!</b></span>
								<hr>
								<div class="row">
									<div class="col-xl-6 product-point">
										<c:if test="${sMid == null}">로그인 시</c:if>
										최대 적립 포인트
									</div>
									<div class="col-xl-6 product-point text-right">
										<b> <c:if test="${sMid == null}">
												<fmt:formatNumber value="${vo.p_price * 0.01 + 150}"
													pattern="#,###" />원</c:if> <c:if test="${sMid != null}">
												<fmt:formatNumber
													value="${vo.p_price * sLevelRatio * 0.01 + 150}"
													pattern="#,###" />원</c:if>
										</b> <input type="button" class="question-box" value="?">
									</div>
								</div>
								<div class="row">
									<div class="col-xl-6 product-point bright">┖&nbsp;리뷰적립</div>
									<div class="col-xl-6 text-right product-point bright">최대
										150원</div>
								</div>
							</div>

							<div class="row product-point mt-3">
								<h5 class="col-xl-12">수량</h5>
								<div class="col-sm-8 col-xl-8 align-self-center">
									<div class="input-group number-spinner">
										<span class="input-group-btn">
											<button type="button" class="btn btn-default" data-dir="dwn">
												<span class="fa fa-minus"></span>
											</button>
										</span> <input type="number" name="od_amount" id="od_amount"
											class="form-control text-center" value="1"> <span
											class="input-group-btn">
											<button type="button" class="btn btn-default" data-dir="up">
												<span class="fa fa-plus"></span>
											</button>
										</span>
									</div>
								</div>
								<div
									class="col-sm-4 col-xl-4 d-flex  align-self-center product-text">
									<h4 class="m-0 ">
										총 &nbsp;<span id="quantity_number">1</span>개
									</h4>
								</div>
							</div>
							<hr>
							<div class="row product-point mt-3">
								<div class="col-sm-6 col-xl-6 align-self-top">
									<h3 class="m-0 d-flex align-top">총 금액</h3>
								</div>
								<div
									class="col-sm-6 col-xl-6 align-self-top product-text  text-danger">
									<h3>
										<b><span id="totalPrice" class="pl-3 m-0 d-flex align-top"><fmt:formatNumber
													value="${vo.p_price}" pattern="#,###" />원</span></b>
									</h3>
								</div>
							</div>
							<input type="hidden" name="p_idx" value="${vo.p_idx}">
						</form>
						<div class="buttons d-flex flex-row mt-5 gap-3">
							<c:if test="${vo.p_amount == 0}">
								<button onclick="alert('품절된 상품은 주문하실 수 없습니다.');"
									class="col-sm-12 col-xl-12 btn btn-black">품절된 상품입니다.</button>
							</c:if>
							<c:if test="${vo.p_amount != 0}">
								<button onclick="buyNow()"
									class="col-xl-6 btn btn-outline-danger">구매하기</button>
								<button onclick="cartNow()" class="col-xl-6 btn btn-danger"
									onclick="cart()">장바구니</button>
							</c:if>
						</div>
					</div>
				</div>
			</div>
		</div>

		<div class="row">
			<div class="col-xl-12 col-md-12 text-center">
				<nav>
					<div class="nav nav-tabs nav-fill" id="nav-tab" role="tablist">
						<a
							class="nav-item nav-link <c:if test="${paging == '' }">active</c:if>"
							id="nav-home-tab" data-toggle="tab" href="#nav-home" role="tab"
							aria-controls="nav-home"
							aria-selected="<c:if test="${paging == '' }">active</c:if>">상세정보</a>

						<a
							class="nav-item nav-link <c:if test="${paging == 'review' }">active</c:if>"
							id="nav-review-tab" data-toggle="tab" href="#nav-review"
							role="tab" aria-controls="nav-review" aria-selected="false">리뷰</a>

						<a
							class="nav-item nav-link <c:if test="${paging == 'QnA' }">active</c:if>"
							id="nav-contact-tab" data-toggle="tab" href="#nav-contact"
							role="tab" aria-controls="nav-contact" aria-selected="false">Q&A</a>
					</div>
				</nav>
				<div class="tab-content py-3 px-3 px-sm-0" id="nav-tabContent">
					<div
						class="tab-pane fade<c:if test="${paging == '' }">show active</c:if>"
						id="nav-home" role="tabpanel" aria-labelledby="nav-home-tab">
						${vo.p_content}</div>
					<div
						class="tab-pane fade m-0 <c:if test="${paging == 'review' }">show active</c:if>"
						id="nav-review" role="tabpanel" aria-labelledby="nav-review-tab">
						<div class="text-left m-4">
							<h3 class="product-title">
								<b>상품리뷰</b>
							</h3>
							<p class="text-muted">
								상품을 구매하신 분들이 직접 작성해주신 리뷰입니다. 리뷰 작성시 아래 금액만큼 포인트가 적립됩니다.<br />
								텍스트 리뷰: <font color="red">50원</font> | 포토 리뷰: <font color="red">150원</font>
							</p>
						</div>


						<div class="border-red mb-4"></div>
						<div
							class="row g-4 bg-dark text-light d-flex justify-content-center text-center m-0">
							<div class="col-sm-6 col-xl-6">
								<div
									class="d-flex flex-column align-items-center justify-content-between p-3">
									<div class="ms-3 mt-3">
										<p class="mb-2 text-grey" style="font-size: 13pt">총 평점</p>
									</div>
									<div class="ms-3 mt-2">
										<div class="ratings d-flex flex-row align-items-center pr-0">
											<div class="d-flex flex-row">
												<div class="rating">
													<div class="w-100">
														<div id="star-rating" class="star-big">
															★★★★★ <span id="star-rating-checked"
																class="star-big review-nav">★★★★★</span>
														</div>
														<div class="ms-3 mt-2">
															<h2 class="mt-2 text-white d-flex justify-content-center">${vo.p_rating}<span
																	class="text-muted" style="font-size: 24pt;">/5.0</span>
															</h2>
														</div>
													</div>
													<script>
																			$(".review-nav").css("width", ${vo.p_rating*20}+"%");
																		</script>
												</div>
											</div>
										</div>

									</div>
								</div>
							</div>
							<div class="col-sm-6 col-xl-6">
								<div
									class="d-flex flex-column align-items-center justify-content-between p-3">
									<div class="ms-3 mt-3">
										<p class="mb-2 text-grey" style="font-size: 13pt">전체 리뷰수</p>
									</div>
									<div class="ms-3 mt-2">
										<i class="fas fa-comment-dots fa-3x"></i>
									</div>
									<div class="ms-3 mt-2">
										<h2 class="mb-2 text-white">${vo.p_reviewCnt}</h2>
									</div>
								</div>
							</div>
						</div>

						<c:if test="${fn:length(reviewVos) == 0}">
							<div
								class="d-flex flex-column justify-content-center align-items-center mt-5">
								<i class="far fa-times-circle fa-5x my-3"></i> <span
									class="gmarketSans">등록된 리뷰가 없습니다.</span>
							</div>
						</c:if>

						<c:forEach var="vo" items="${reviewVos}" varStatus="st">
							<div class="review">
								<div class="review-top pb-5 border-top"">
									<div class=" p-4 d-flex justify-content-between">
										<div class="left">
											<div class="profile-img-div">
												<img class="profile-img" src="${ctp}/images/${vo.m_photo}">
											</div>
											<div class="d-flex flex-column">
												<div class="profile-rating-div">
													<div class="rating">
														<div class="w-100 text-left">
															<div id="star-rating-review">
																★★★★★ <span id="star-rating-checked-review"
																	class="review-member${st.index}">★★★★★</span>
															</div>
														</div>
														<script>
															$(".review-member${st.index}").css("width", ${vo.review_rating*20}+"%");
														</script>
													</div>
												</div>
												<div class="profile-text-div">
													<div class="ml-1">${vo.m_mid}|
														${fn:substring(vo.review_date,2,10)}</div>
												</div>
											</div>
										</div>
										<!-- 우측상단 더보기/좋아요 -->
										<div class="review-more">
											<button class="review-like"
												onclick="likeReview(${vo.review_idx}, ${vo.review_thumb})">
												<i class="fas fa-heart fa-sm"></i> <span
													id="reviewThumbValue${vo.review_idx}">${vo.review_thumb}</span>
											</button>
											<c:if test="${sMid == vo.m_mid }">
												<button class="review-more" type="button" id="moreMenu"
													data-toggle="dropdown">
													<i class="fas fa-ellipsis-v"></i>
												</button>
												<ul class="dropdown-menu text-center"
													aria-labelledby="moreMenu">
													<li><button class="moreBtn"
															onclick="reviewUpdate(${vo.review_idx})">
															<i class="fas fa-pen fa-2xs"></i>&nbsp;수정
														</button></li>
													<li><button class="moreBtn"
															onclick="reviewDelete(${vo.review_idx})">
															<i class="fas fa-trash-alt fa-2xs"></i> &nbsp; 삭제
														</button></li>
												</ul>
											</c:if>
										</div>
									</div>
									<div class="text-left review-content">${vo.review_content}</div>
									<c:if test="${vo.review_photo != ''}">
										<div class="review-photo" id="review-photo${vo.review_idx}"
											onclick="reviewExpand(${vo.review_idx})">
											<c:set var="img" value="${fn:split(vo.review_photo, '/')}"></c:set>
											<c:if test="${fn:length(img) >1}">
												<div class="img-plus">+${fn:length(img)}</div>
											</c:if>
											<img src="${ctp}/data/review/${img[0]}">
										</div>
									</c:if>
								</div>
								<div class="review-bottom" id="review-bottom${vo.review_idx}">
									<c:if test="${vo.review_photo != ''}">
										<c:forEach var="image" items="${img}">
											<img class="expand-img" src="${ctp}/data/review/${image}">
										</c:forEach>
									</c:if>
								</div>
							</div>
						</c:forEach>
						<!-- 리뷰 페이징처리  -->
						<div class="text-center m-4">
							<ul class="pagination justify-content-center pagination-sm">
								<c:if test="${pageReviewVO.pag > 1}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/product/productInfo?p_idx=${vo.p_idx}&pageSize=${pageReviewVO.pageSize}&pag=1&paging=review">첫페이지</a></li>
								</c:if>
								<c:if test="${pageReviewVO.curBlock > 0}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/product/productInfo?p_idx=${vo.p_idx}&pageSize=${pageReviewVO.pageSize}&pag=${(pageReviewVO.curBlock-1)*pageReviewVO.blockSize + 1}&paging=review">이전블록</a></li>
								</c:if>
								<c:forEach var="i"
									begin="${pageReviewVO.curBlock*pageReviewVO.blockSize + 1}"
									end="${pageReviewVO.curBlock*pageReviewVO.blockSize + pageReviewVO.blockSize}"
									varStatus="st">
									<c:if
										test="${i <= pageReviewVO.totPage && i == pageReviewVO.pag}">
										<li class="page-item active"><a
											class="page-link text-white bg-secondary border-secondary"
											href="javascript:nextPage(${pageReviewVO.pageSize},${i})">${i}</a></li>
									</c:if>
									<c:if
										test="${i <= pageReviewVO.totPage && i != pageReviewVO.pag}">
										<li class="page-item"><a class="page-link text-secondary"
											href="${ctp}/product/productInfo?p_idx=${vo.p_idx}&pageSize=${pageReviewVO.pageSize}&pag=${i}&paging=review">${i}</a></li>
									</c:if>
								</c:forEach>
								<c:if test="${pageReviewVO.curBlock < pageReviewVO.lastBlock}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/product/productInfo?p_idx=${vo.p_idx}&pageSize=${pageReviewVO.pageSize}&pag=${(pageReviewVO.curBlock+1)*pageReviewVO.blockSize + 1}&paging=review">다음블록</a></li>
								</c:if>
								<c:if test="${pageReviewVO.pag < pageReviewVO.totPage}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/product/productInfo?p_idx=${vo.p_idx}&pageSize=${pageReviewVO.pageSize}&pag=${pageReviewVO.totPage}&paging=review">마지막페이지</a></li>
								</c:if>
							</ul>
						</div>





					</div>
					<div
						class="tab-pane fade <c:if test="${paging == 'QnA' }">show active</c:if>"
						id="nav-contact" role="tabpanel">
						<div class="text-left m-4">
							<h3 class="product-title">
								<b>Q&A</b>
							</h3>
							<p class="text-muted">
								구매하시려는 상품에 대해 궁금하신 점이 있으신 경우 문의해주세요.<br /> 상품 문의 외의 질문은 마이페이지 -
								<font color="red"> 1:1 문의</font>을 이용해주세요.
							</p>
							<div class="d-flex justify-content-between">
								<div>
									<c:if test="${sLevel<=4}">
										<button type="button" class="btn-black"
											onclick="showQnAPopUp(${vo.p_idx})">
											<i class="fas fa-search"></i>&nbsp;상품 Q&A 작성하기
										</button>
										<button type="button" class="btn-black-outline"
											onclick="location.href='${ctp}/member/myQnAList'">
											<i class="fas fa-search"></i>&nbsp;나의 Q&A 조회
										</button>
									</c:if>
								</div>

								<select class="btn border btn-select" name="answerOK"
									id="answerOK" onchange="sortAnswer(${vo.p_idx})">
									<option value="">답변상태</option>
									<option value="NO"
										<c:if test="${sortAnswer=='NO'}">selected</c:if>>미답변</option>
									<option value="OK"
										<c:if test="${sortAnswer=='OK'}">selected</c:if>>답변완료</option>
								</select>
							</div>
						</div>


						<!-- QnA 목록 -->
						<div class="navbar-nav">
							<nav class="navbar">
								<div class="navbar-nav w-100">
									<div class="row qna-header">
										<div class="col-2">답변상태</div>
										<div class="col-6">제목</div>
										<div class="col-2">작성자</div>
										<div class="col-2">작성일</div>
									</div>

									<c:if test="${fn:length(QnAVos) == 0}">
										<div
											class="d-flex flex-column justify-content-center align-items-center mt-5">
											<i class="far fa-times-circle fa-5x my-3"></i> <span
												class="gmarketSans">등록된 Q&A가 없습니다.</span>
										</div>
									</c:if>

									<c:forEach var="QnA" items="${QnAVos}">
										<div class="nav-item dropdown py-1">
											<div class="nav-link dropdown-toggle text-left pointer"
												aria-expanded="true"
												<c:if test="${QnA.openSw == 'OK' || QnA.m_mid == sMid}">data-toggle="dropdown"</c:if>
												<c:if test="${QnA.openSw == 'NO' && QnA.m_mid != sMid}">onclick="secret()"</c:if>
												id="nav-qna">
												<div class="row" style="font-size: 12pt;">
													<div class="col-2 text-center">
														<c:if test="${QnA.answerOK == 'NO'}">미답변</c:if>
														<c:if test="${QnA.answerOK == 'OK'}">답변완료</c:if>
													</div>
													<div class="col-6 ellipsis">
														<c:if test="${QnA.openSw == 'OK' || QnA.m_mid == sMid}">
												${QnA.qna_context} <c:if test="${QnA.openSw == 'NO'}">
																<i class="fas fa-lock"></i>
															</c:if>
														</c:if>
														<c:if test="${QnA.openSw == 'NO' && QnA.m_mid != sMid}">
															<font color="#aaa"><i class="fas fa-lock"></i>&nbsp;
																비밀글입니다.</font>
														</c:if>
													</div>
													<div class="col-2 text-center">${QnA.m_mid}</div>
													<div class="col-2 text-center">${fn:substring(QnA.qna_Date,0,10)}</div>
												</div>
											</div>
											<div
												class="dropdown-menu bg-grey w-100 border-0 py-3 clickPrevent">
												<div class="row">
													<div class="col-2"></div>
													<div class="col-6">${QnA.qna_context}</div>
													<div class="col-2 "></div>
													<div class="col-2 text-center">
														<c:if test="${sMid == QnA.m_mid }">
															<span class="badge bg-danger text-white">삭제</span> &nbsp;
												<span class="badge bg-secondary text-white">수정</span>
														</c:if>
													</div>
												</div>
												<c:if test="${QnA.answerOK == 'OK'}">
													<div class="row py-3">
														<div class="col-2"></div>
														<div class="col-6">
															└<span class="badge bg-secondary text-white">답변</span>
															${QnA.answer_context}
														</div>
														<div class="col-2 text-center">판매자</div>
														<div class="col-2 text-center">${fn:substring(QnA.answer_Date,0,10)}</div>
													</div>
												</c:if>
											</div>
										</div>
									</c:forEach>

								</div>
							</nav>
						</div>



						<!-- QnA 페이징처리  -->
						<div class="text-center m-4">
							<ul class="pagination justify-content-center pagination-sm">
								<c:if test="${pageQnAVO.pag > 1}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/product/productInfo?p_idx=${vo.p_idx}&pageSizeQnA=${pageQnAVO.pageSize}&pagQnA=1&paging=QnA">첫페이지</a></li>
								</c:if>
								<c:if test="${pageQnAVO.curBlock > 0}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/product/productInfo?p_idx=${vo.p_idx}&pageSizeQnA=${pageQnAVO.pageSize}&pagQnA=${(pageQnAVO.curBlock-1)*pageQnAVO.blockSize + 1}&paging=QnA">이전블록</a></li>
								</c:if>
								<c:forEach var="i"
									begin="${pageQnAVO.curBlock*pageQnAVO.blockSize + 1}"
									end="${pageQnAVO.curBlock*pageQnAVO.blockSize + pageQnAVO.blockSize}"
									varStatus="st">
									<c:if test="${i <= pageQnAVO.totPage && i == pageQnAVO.pag}">
										<li class="page-item active"><a
											class="page-link text-white bg-secondary border-secondary"
											href="javascript:nextPage(${pageQnAVO.pageSize},${i})">${i}</a></li>
									</c:if>
									<c:if test="${i <= pageQnAVO.totPage && i != pageQnAVO.pag}">
										<li class="page-item"><a class="page-link text-secondary"
											href="${ctp}/product/productInfo?p_idx=${vo.p_idx}&pageSizeQnA=${pageQnAVO.pageSize}&pagQnA=${i}&paging=QnA">${i}</a></li>
									</c:if>
								</c:forEach>
								<c:if test="${pageQnAVO.curBlock < pageQnAVO.lastBlock}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/product/productInfo?p_idx=${vo.p_idx}&pageSizeQnA=${pageQnAVO.pageSize}&pagQnA=${(pageQnAVO.curBlock+1)*pageQnAVO.blockSize + 1}&paging=QnA">다음블록</a></li>
								</c:if>
								<c:if test="${pageQnAVO.pag < pageQnAVO.totPage}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/product/productInfo?p_idx=${vo.p_idx}&pageSizeQnA=${pageQnAVO.pageSize}&pagQnA=${pageQnAVO.totPage}&paging=QnA">마지막페이지</a></li>
								</c:if>
							</ul>
						</div>

					</div>

				</div>
			</div>

		</div>
		<a href="#" class="btn btn-lg btn-danger btn-lg-square back-to-top"><i
			class="bi bi-arrow-up"></i></a>

		<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>