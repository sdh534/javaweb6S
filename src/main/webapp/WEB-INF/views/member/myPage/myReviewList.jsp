<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
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
		$(document).ready(function(){
			//--------------------------------------------------------------
			$("#startDate").change(function(){
				$("#startDate").css("color", "black");
			});
			$("#endDate").change(function(){
				$("#endDate").css("color", "black");
			});
			
			$(".review-bottom").hide();
			
			//조회기간 설정
			$("input[name='duration']").click(function(){
	        	var duration = $("input[name='duration']:checked").val();
	        	let startDate = $("#startDate").val();
	      		let day  = new Date(startDate);
	      		
	      		if(startDate == "") {
	      			Swal.fire({
	    				width:500,
	    			  position: 'center',
	    			  icon: 'error',
	    			  title: '조회할 기간을 선택해주세요.',
	    			  showConfirmButton: false,
	    			  timer: 1000
	    			})
	    			 return;
	      		}
	      		
	        	if(duration == "today"){
	        		document.getElementById('startDate').valueAsDate = new Date(now.setDate(now.getDate()));
	        		document.getElementById('endDate').valueAsDate =  new Date(now.setDate(now.getDate()));
	        	}
	        	else if (duration == "week"){
	        		day = new Date(day.setDate(day.getDate()+7));
	        		document.getElementById('endDate').valueAsDate = new Date(day);
	        	}
	        	else if (duration == "15day"){
	        		let day  = new Date(startDate);
	        		day = new Date(day.setDate(day.getDate()+15));
	        		document.getElementById('endDate').valueAsDate = new Date(day);
	        	}
	        	else if (duration == "1month"){
	        		let day  = new Date(startDate);
	        		day = new Date(day.setMonth(day.getMonth()+1));
	        		document.getElementById('endDate').valueAsDate = new Date(day);
	        	}
	        	else if (duration == "3month"){
	        		let day  = new Date(startDate);
	        		day = new Date(day.setMonth(day.getMonth()+3));
	        		document.getElementById('endDate').valueAsDate = new Date(day);
	        	}
				$("#endDate").css("color", "black");
	      });
		});
		
		
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
		
		
		function reviewExpand(review_idx){
			$("#review-bottom"+review_idx).toggle();
		}
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
								<h4 class="mb-0 pretendard mr-2">작성한 리뷰</h4>
							</div>
						</div>
						<form name="reviewSearch" method="get"
							action="${ctp}/member/myReviewSearch">
							<div class="col-sm-12 col-xl-12 mb-4 p-0">
								<div class="bg-light text-center rounded p-2">
									<div
										class="d-flex align-items-center justify-content-between m-3">
										<h6 class="mb-0 gmarketSans mr-2" style="font-size: 15pt;">조회기간</h6>
										<div class="custom-input">
											<input type="date" class="textbox extraText" name="startDate"
												id="startDate"> - <input type="date"
												class="textbox extraText" name="endDate" id="endDate">
											<div class="mt-3 buttonList btn-group btn-group-toggle"
												data-toggle="buttons">
												<label class="btn btn-secondary"> <input
													type="radio" name="duration" id="today" autocomplete="off"
													value="today" checked> 오늘
												</label> <label class="btn btn-secondary"> <input
													type="radio" name="duration" id="week" autocomplete="off"
													value="week"> 1주
												</label> <label class="btn btn-secondary"> <input
													type="radio" name="duration" id="15day" autocomplete="off"
													value="15day"> 15일
												</label> <label class="btn btn-secondary"> <input
													type="radio" name="duration" id="1month" autocomplete="off"
													value="1month"> 1개월
												</label> <label class="btn btn-secondary"> <input
													type="radio" name="duration" id="3month" autocomplete="off"
													value="3month"> 3개월
												</label>
											</div>
										</div>

										<button type="button" class="btn-black ml-2"
											onclick="searchNow()">
											<i class="fas fa-search"></i>&nbsp;조회
										</button>
									</div>
								</div>
							</div>
						</form>
						<!-- 리뷰목록 조회 -->

						<c:if test="${fn:length(reviewVos) == 0}">
							<div
								class="d-flex flex-column justify-content-center align-items-center mt-5">
								<i class="far fa-times-circle fa-5x my-3"></i> <span
									class="gmarketSans">등록된 리뷰가 없습니다.</span>
							</div>
						</c:if>

						<c:forEach var="vo" items="${reviewVos}" varStatus="st">
							<div class="review">
								<div class="review-top pb-5 border-top"
									onclick="reviewExpand(${vo.review_idx})">
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
											<button class="review-like">
												<i class="fas fa-heart fa-sm"></i> ${vo.review_thumb}
											</button>
											<button class="review-more" type="button" id="moreMenu"
												data-toggle="dropdown">
												<i class="fas fa-ellipsis-v"></i>
											</button>
											<ul class="dropdown-menu text-center"
												aria-labelledby="moreMenu">
												<c:if test="${sMid == vo.m_mid }">
													<li><button class="moreBtn"
															onclick="reviewUpdate(${vo.review_idx})">
															<i class="fas fa-pen fa-2xs"></i>&nbsp;수정
														</button></li>
													<li><button class="moreBtn"
															onclick="reviewDelete(${vo.review_idx})">
															<i class="fas fa-trash-alt fa-2xs"></i> &nbsp; 삭제
														</button></li>
												</c:if>
												<c:if test="${sMid != vo.m_mid }">
													<li><button class="moreBtn" onclick="">
															<i class="fas fa-ban fa-2xs"></i> &nbsp; 신고
														</button></li>
												</c:if>
											</ul>
										</div>
									</div>
									<div class="text-left review-content">${vo.review_content}</div>
									<c:if test="${vo.review_photo != ''}">
										<div class="review-photo" id="review-photo${vo.review_idx}">
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