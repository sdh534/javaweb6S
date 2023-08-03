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
		$(document).ready(function(){
			//최근 주문내역 
			//--------------------------------------------------------------
			$("#startDate").change(function(){
				$("#startDate").css("color", "black");
			});
			$("#endDate").change(function(){
				$("#endDate").css("color", "black");
			});
			let now = new Date();	
	    document.getElementById('startDate').valueAsDate = new Date(now.setDate(now.getDate()));
	    document.getElementById('endDate').valueAsDate = new Date(now.setDate(now.getDate()));
			$("#startDate").css("color", "black");
     	$("#endDate").css("color", "black");
			//조회기간 설정
		    $("input[name='duration']").click(function(){
	        	var duration = $("input[name='duration']:checked").val();
	        	let startDate = $("#startDate").val();
	      		let day  = new Date();
	        	
	        	if(duration == "today"){
	        		document.getElementById('startDate').valueAsDate = new Date(now.setDate(now.getDate()));
	        	}
	        	else if (duration == "week"){
	        		day = new Date(day.setDate(day.getDate()-7));
	        		document.getElementById('startDate').valueAsDate = new Date(day);
	        	}
	        	else if (duration == "15day"){
	        		let day  = new Date(startDate);
	        		day = new Date(day.setDate(day.getDate()-15));
	        		document.getElementById('startDate').valueAsDate = new Date(day);
	        	}
	        	else if (duration == "1month"){
	        		let day  = new Date(startDate);
	        		day = new Date(day.setMonth(day.getMonth()-1));
	        		document.getElementById('startDate').valueAsDate = new Date(day);
	        	}
	        	else if (duration == "3month"){
	        		let day  = new Date(startDate);
	        		day = new Date(day.setMonth(day.getMonth()-3));
	        		document.getElementById('startDate').valueAsDate = new Date(day);
	        	}
	        	
	      });
		});
		
		function searchNow(){
			location.href = '${ctp}/member/myPointList?startDate='+$("#startDate").val()+'&endDate='+$("#endDate").val();
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


		<!-- Sales Chart Start -->
		<div class="container-fluid pt-4 px-4">
			<div class="row g-4">
				<div class="col-sm-12 col-xl-12 mb-4">
					<div class="text-center rounded p-4">
						<div
							class="d-flex align-items-center justify-content-between mb-4 mt-2 border-bottom-design">
							<div class="d-flex mb-1">
								<h4 class="mb-0 pretendard mr-2">적립금 조회</h4>
							</div>
						</div>

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
											<label class="btn btn-secondary"> <input type="radio"
												name="duration" id="today" autocomplete="off" value="today"
												checked> 오늘
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

						<div class="table-responsive">
							<table class="table text-start align-middle table-hover mb-0">
								<thead>
									<tr class="text-dark bg-light pretendard"
										style="font-size: 14pt">
										<th scope="col">날짜/상품코드</th>
										<th scope="col"></th>
										<th scope="col">상품명</th>
										<th scope="col">적립금액</th>
									</tr>
								</thead>
								<tbody id="recentOrder">
									<c:forEach var="vo" items="${vos}" varStatus="st">
										<c:if test="${!vo.point_status}">
											<tr>
												<td>${fn:substring(vo.point_date,0,10)}<br />${vo.oi_productCode}</td>
												<td class='text-left' colspan='2'><span
													class='d-flex align-items-center'> <img
														src='${ctp}/data/product/${vo.p_thumbnailIdx}'
														width='80px' class='order-image mr-2'> <span>
															${vo.p_name}<br /> <c:if
																test="${vo.point == 150 || vo.point == 50}">
																<a class='text-danger' href='#'>리뷰적립</a>
															</c:if> <c:if test="${vo.point != 150}">
																<a class='text-danger'
																	href='javascript:showOrder(${vo.o_idx})'>구매확정 <i
																	class='fas fa-chevron-right'></i>
																</a>
															</c:if>
													</span></span></td>
												<td>+${vo.point}</td>
											</tr>
										</c:if>
										<c:if test="${vo.point_status}">
											<tr>
												<td>${fn:substring(vo.point_date,0,10)}<br />${vo.o_orderCode}</td>
												<td class='text-right' colspan='2'><a
													class='text-danger'
													href='javascript:showOrder(${vo.o_idx})'>포인트 사용<i
														class='fas fa-chevron-right'></i>
												</a></td>
												<td>-${vo.point}</td>
											</tr>
										</c:if>

									</c:forEach>
								</tbody>
							</table>
						</div>

						<!-- 블록 페이징 처리 -->
						<div class="text-center m-4">
							<ul class="pagination justify-content-center pagination-sm">
								<c:if test="${pageVO.pag > 1}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/member/myOrderList?pageSize=${pageVO.pageSize}&pag=1">첫페이지</a></li>
								</c:if>
								<c:if test="${pageVO.curBlock > 0}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/member/myOrderList?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}">이전블록</a></li>
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
											href="${ctp}/member/myOrderList?pageSize=${pageVO.pageSize}&pag=${i}">${i}</a></li>
									</c:if>
								</c:forEach>
								<c:if test="${pageVO.curBlock < pageVO.lastBlock}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/member/myOrderList?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock+1)*pageVO.blockSize + 1}">다음블록</a></li>
								</c:if>
								<c:if test="${pageVO.pag < pageVO.totPage}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/member/myOrderList?pageSize=${pageVO.pageSize}&pag=${pageVO.totPage}">마지막페이지</a></li>
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