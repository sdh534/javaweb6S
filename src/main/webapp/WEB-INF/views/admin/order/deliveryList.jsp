<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="nowPage" value="" />
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<head>
<meta charset="utf-8">
<title>PARADICE | 관리자 카테고리 등록</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="" name="keywords">
<meta content="" name="description">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<!-- 페이지네이션 -->
<script type="text/javascript"
	src="https://uicdn.toast.com/tui.pagination/v3.4.0/tui-pagination.js"></script>
<link rel="stylesheet"
	href="https://uicdn.toast.com/tui.pagination/latest/tui-pagination.css" />
<script src="${ctp}/js/tui-grid.js"></script>
<script src="${ctp}/js/admin/productList.js"></script>
<link rel="stylesheet" href="${ctp}/css/tui-grid.css" type="text/css">
</head>
<script>
	'use strict';
	window.onload = function(){
     	let now = new Date();	
	    document.getElementById('startDate').valueAsDate = new Date(now.setDate(now.getDate()));
	    document.getElementById('endDate').valueAsDate = new Date(now.setDate(now.getDate()));
	    
    	$("input[name='duration']").click(function(){
        	var duration = $("input[name='duration']:checked").val();
        	let startDate = $("#startDate").val();
      		let day  = new Date(startDate);
        	
        	if(duration == "today"){
        		document.getElementById('startDate').valueAsDate = new Date(now.setDate(now.getDate()));
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
      });
	}
	
	
	function hideSearch(){
		$("#hideSearchForm").hide(500);
		$("#hideBtn").css('display','none');
		$("#showBtn").css('display','block');
	}
	function showSearch(){
		$("#hideSearchForm").show(500);
		$("#hideBtn").css('display','block');
		$("#showBtn").css('display','none');
	}
	
	function searchNow(){
		let pay_method = document.getElementsByName("pay_method");
		let payMethodList = "";
		for(let i=0; i<pay_method.length; i++){
			if(pay_method[i].checked == true){
				payMethodList += $("#pay_method_"+(i+1)).val() + "/";
			}
		}
		let o_status = document.getElementsByName("o_status");
		let o_statusList = "";
		for(let i=0; i<o_status.length; i++){
			if(o_status[i].checked == true){
				o_statusList += $("#o_status"+(i+1)).val() + "/";
			}
		}
		let o_cStatus = document.getElementsByName("o_cStatus");
		let o_cStatusList = "";
		for(let i=0; i<o_cStatus.length; i++){
			if(o_cStatus[i].checked == true){
				o_cStatusList += $("#o_cStatus"+(i+1)).val() + "/";
			}
		}
		console.log(o_cStatusList);
		
		$.ajax({
			type : "post",
			url : "${ctp}/admin/order/orderListSearch",
			data : {
				pay_methodList: payMethodList,
				o_statusList: o_statusList,
				o_cStatusList: o_cStatusList,
				startDate : $("#startDate").val(),
				endDate : $("#endDate").val(),
				durationCategory: orderListSearch.durationCategory.value,
				searchCategory: orderListSearch.searchCategory.value,
				searchKeyword:  orderListSearch.searchKeyword.value
			},
			success : function(res) {
			},
			error : function() {
				alert("전송오류!");
			}
		}); 
	}
	

	// 체크박스 전체 선택
	$(function(){
			$("#product_check").on('click',function(){
				//체크박스 check상태가 true라면
				if($("#product_check").is(":checked"))  
				{
					$("input[name='o_idx']").prop("checked", true);
				}
				else
				{
					$("input[name='o_idx']").prop("checked", false);
				}
			});
			//하위 항목 클릭시 전체를 선택한 경우 상단의 체크박스도 바꿔주는 코드  
			$("input[name='o_idx']").click(function() {
				var total = $("input[name='o_idx']").length;
				var checked = $("input[name='o_idx']:checked").length;
				if(total != checked) {
					$("#product_check").prop("checked", false);
				}
				else $("#product_check").prop("checked", true); 
			});
		});

	
	function orderInfo(idx){
		//location.href='${ctp}/admin/order/orderInfo?o_idx='+idx;
		
		var width = 650;
		var height = 850;
		
		//pc화면기준 가운데 정렬
		var left = (window.screen.width / 2) - (width/2);
		var top = (window.screen.height / 4) - (height/4);
		
	    	//윈도우 속성 지정
		var windowStatus = 'width='+width+', height='+height+', left='+left+', top='+top+', scrollbars=yes, status=yes, resizable=yes, titlebar=yes';
		
	    	//연결하고싶은url
	    	const url = "${ctp}/admin/order/orderInfo?o_idx="+idx;

		//등록된 url 및 window 속성 기준으로 팝업창을 연다.
		window.open(url, "hello popup", windowStatus);
	}
	
	
	function deliveryUpdate(){
		let arr = [];
		let check = document.getElementsByName("o_idx");
		let checkCount = 0;
		let deliveryComList = "";
		let deliveryIdxList = "";
		let deliveryCodeList = "";
		for(let i=0; i<check.length; i++){
			if(check[i].checked == true){
				arr.push(check[i].value); 
				deliveryIdxList += check[i].value + "/";
				deliveryComList += $("#deliveryCom"+i+" :selected").val() + "/";
		    deliveryCodeList += $("#deliveryCode"+i).val() + "/";
			}
		}
		
		console.log(deliveryComList);
		console.log(deliveryIdxList);
		console.log(deliveryCodeList);

		$.ajax({
			type : "post",
			url : "${ctp}/admin/order/deliveryUpdate",
			data : {
				deliveryComList: deliveryComList,
				deliveryIdxList: deliveryIdxList,
				deliveryCodeList: deliveryCodeList
			},
			success : function(res) {
				if(res==1){
					Swal.fire({
						width:500,
					  position: 'center',
					  icon: 'success',
					  title: '변경되었습니다.',
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
	
</script>
<body>


	<div class="container-xxl position-relative bg-white d-flex p-0">

		<jsp:include page="/WEB-INF/views/admin/adminNav.jsp" />



		<div class="container-fluid pt-4 px-4">
			<div class="row">
				<div class="col-sm-12 col-xl-12">
					<div class="row mb-4">
						<div class="col-sm-12 col-xl-12  h-100">
							<!-- 오른쪽 카테고리 등록부분 -->
							<!-- Form Start -->
							<form name="orderListSearch">
								<div class="bg-white rounded-lg p-4 mb-3">
									<h5 class="mb-2">배송 관리</h5>
									<div class="p-3">
										<div class="row border align-items-center" id="searchForm">
											<div class="col-xl-12">
												<!-- 여기서부터 묶어주기 -->
												<div id="hideSearchForm">
													<!-- 검색 -->
													<div class="row border-bottom">
														<div
															class="col-sm-2 col-xl-2 p-0 d-flex align-items-center justify-content-center "
															style="background: #eee;">
															<div>검색</div>
														</div>
														<div class="col-sm-10 col-xl-10">
															<div class="row p-4 d-flex flex-column">
																<!-- 입금 완료 ~ 배송 처리 -->
																<div class="row p-2">
																	<div class="custom-input mr-3">
																		<select class="btn border" name="searchCategory">
																			<option value="">선택</option>
																			<option value="m_mid">수취인 명</option>
																			<option value="o_orderCode">수취인 번호</option>
																			<option value="oi_productCode">주문자 명</option>
																			<option value="oi_productCode">주문자 번호</option>
																			<option value="oi_productCode">주문자 ID</option>
																			<option value="oi_productCode">주문 번호</option>
																			<option value="p_name">상품명</option>
																		</select>
																	</div>
																	<div class="custom-input">
																		<input type="text" class="textbox"
																			name="searchKeyword" id="searchKeyword"
																			placeholder="검색어를 입력하세요.">
																	</div>
																</div>
															</div>
														</div>
													</div>


													<div class="row  border-bottom">
														<div
															class="col-sm-2 col-xl-2 p-0 d-flex align-items-center justify-content-center "
															style="background: #eee;">
															<div>기간</div>
														</div>
														<div class="col-sm-10 col-xl-10">
															<div class="row p-4 d-flex flex-column">
																<!-- 입금 완료 ~ 배송 처리 -->
																<div class="row p-2">
																	<div class="custom-input mr-3">
																		<select class="btn border" name="durationCategory"
																			id="durationCategory">
																			<option value="">선택</option>
																			<option value="o_date">주문일자</option>
																			<option value="pay_date">결제일자</option>
																		</select>
																	</div>
																	<div class="custom-input">
																		<input type="date" class="textbox text-mute"
																			name="startDate" id="startDate"> - <input
																			type="date" class="textbox text-mute" name="endDate"
																			id="endDate">
																	</div>
																	<div class="ml-3 buttonList btn-group btn-group-toggle"
																		data-toggle="buttons">
																		<label class="btn btn-secondary"> <input
																			type="radio" name="duration" id="today"
																			autocomplete="off" value="today" checked> 오늘
																		</label> <label class="btn btn-secondary"> <input
																			type="radio" name="duration" id="week"
																			autocomplete="off" value="week"> 1주
																		</label> <label class="btn btn-secondary"> <input
																			type="radio" name="duration" id="15day"
																			autocomplete="off" value="15day"> 15일
																		</label> <label class="btn btn-secondary"> <input
																			type="radio" name="duration" id="1month"
																			autocomplete="off" value="1month"> 1개월
																		</label> <label class="btn btn-secondary"> <input
																			type="radio" name="duration" id="3month"
																			autocomplete="off" value="3month"> 3개월
																		</label>
																	</div>
																</div>
															</div>
														</div>
													</div>
													<!-- 버튼 -->
													<div class="row  border-bottom">
														<div class="col-sm-12 col-xl-12">
															<div
																class="row p-4 d-flex flex-column align-items-center">
																<div class="row p-2">
																	<button type="button" class="btn-black mr-2"
																		onclick="searchNow()">
																		<i class="fas fa-search"></i>&nbsp;검색
																	</button>
																	<button type="button" class="btn-black-outline"
																		onclick="location.reload();">
																		<i class="fas fa-undo"></i>&nbsp;초기화
																	</button>
																</div>
															</div>
														</div>
													</div>
												</div>
												<!-- 숨길 구간 -->
												<div class="row  border-bottom" id="showButton">
													<div class="col-sm-12 col-xl-12">
														<div class="row p-4 d-flex flex-column align-items-center">
															<div class="row p-2">
																<!-- 접히는 버튼? -->
																<button type="button" class="" onclick="hideSearch()"
																	id="hideBtn">
																	<i class="fas fa-angle-double-up fa-2x"></i>
																</button>
																<button type="button" class="" onclick="showSearch()"
																	id="showBtn" style="display: none;">
																	<i class="fas fa-angle-double-down fa-2x"></i>
																</button>
															</div>
														</div>
													</div>
												</div>
											</div>


										</div>
									</div>
								</div>
								<!-- Form End -->
							</form>
						</div>
					</div>
				</div>
				<!-- 226라인 col-sm-12 col-xl-12 end -->


				<div class="col-sm-12 col-xl-12">
					<div class="bg-white rounded-lg h-100 p-4">
						<h5 class="mb-4">상품 조회</h5>
						<div class="mb-3">
							<div class="mb-2 d-flex">
								<div class="custom-input mr-3">
									<form name="updateStatusForm">
										<select class="btn border" name="updateStatus">
											<option value="">택배사 선택</option>
											<option>CJ대한통운</option>
											<option>롯데택배</option>
											<option>우체국택배</option>
											<option>로젠택배</option>
											<option>한진택배</option>
										</select>
									</form>
								</div>
								<button type="button" class="btn-black btn-small mr-2"
									onclick="statusChange()">일괄 변경</button>
							</div>

							<div class="table-responsive">
								<form name="deliveryList">
									<table
										class="table text-start align-middle table-bordered table-hover mb-0">
										<thead>
											<tr class="text-dark bg-light pretendard text-sm ">
												<th scope="col">
													<div class="p-2 px-3 text-uppercase">
														<div
															class="custom-control custom-checkbox custom-control-inline">
															<input type="checkbox" class="custom-control-input"
																name="product_checkAll" id="product_check" /> <label
																class="custom-control-label black" for="product_check"
																style="margin-left: 10px;"> </label>
														</div>
													</div>
												</th>
												<th scope="col" width="5%">번호</th>
												<th scope="col">주문코드</th>
												<th scope="col">주문자</th>
												<!-- 1 정액 2 정율 -->
												<th scope="col" width="10%">주문일자</th>
												<th scope="col" width="10%">결제일자</th>
												<th scope="col" width="10%">택배사</th>
												<th scope="col" width="20%">운송장번호</th>
											</tr>
										</thead>
										<tbody id="couponList" class="nanumbarungothic text-center"
											style="vertical-align: middle;" class="text-center">
											<c:forEach var="vo" items="${vos}" varStatus="st">
												<tr>
													<td>
														<div class="custom-control custom-checkbox ">
															<input type="checkbox" class="custom-control-input"
																name="o_idx" id="o_idx${vo.o_idx}" value="${vo.o_idx}" />
															<label class="custom-control-label black"
																for="o_idx${vo.o_idx}" style="margin-left: 10px;"></label>
														</div>
													</td>
													<td>${st.count}</td>
													<td><a href="javascript:orderInfo(${vo.o_idx})">${vo.o_orderCode}
															<i class="fas fa-sign-out-alt icon"></i>
													</a></td>
													<td>${vo.m_mid}</td>
													<td>${fn:substring(vo.o_date,0,10)}</td>
													<td>${fn:substring(vo.pay_date,0,10)}</td>
													<td><select class="btn border" name="deliveryCom"
														id="deliveryCom${st.index}">
															<option value="">택배사 선택</option>
															<option>CJ대한통운</option>
															<option>롯데택배</option>
															<option>우체국택배</option>
															<option>로젠택배</option>
															<option>한진택배</option>
													</select></td>
													<td><input type="text" class="textbox"
														name="deliveryCode" id="deliveryCode${st.index}"></td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
									<button type="button" class="btn-black-outline btn-small mr-2"
										onclick="deliveryUpdate()">등록</button>
									<input type="hidden" name="deliveryIdxList"> <input
										type="hidden" name="deliveryComList"> <input
										type="hidden" name="deliveryCodeList">
								</form>
							</div>

							<!-- 블록 페이징 처리 -->
							<div class="text-center m-4">
								<ul class="pagination justify-content-center pagination-sm">
									<c:if test="${pageVO.pag > 1}">
										<li class="page-item"><a class="page-link text-secondary"
											href="${ctp}/admin/coupon?pageSize=${pageVO.pageSize}&pag=1">첫페이지</a></li>
									</c:if>
									<c:if test="${pageVO.curBlock > 0}">
										<li class="page-item"><a class="page-link text-secondary"
											href="${ctp}/admin/coupon?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}">이전블록</a></li>
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
											<li class="page-item"><a
												class="page-link text-secondary"
												href="${ctp}/admin/coupon?pageSize=${pageVO.pageSize}&pag=${i}">${i}</a></li>
										</c:if>
									</c:forEach>
									<c:if test="${pageVO.curBlock < pageVO.lastBlock}">
										<li class="page-item"><a class="page-link text-secondary"
											href="${ctp}/admin/coupon?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock+1)*pageVO.blockSize + 1}">다음블록</a></li>
									</c:if>
									<c:if test="${pageVO.pag < pageVO.totPage}">
										<li class="page-item"><a class="page-link text-secondary"
											href="${ctp}/admin/coupon?pageSize=${pageVO.pageSize}&pag=${pageVO.totPage}">마지막페이지</a></li>
									</c:if>
								</ul>
							</div>


						</div>
					</div>
				</div>


			</div>
			<!-- 226라인 row end -->
		</div>
		<!-- 왼쪽 종료 -->


		<!-- 하나로 묶기 위한 row 종료 -->



		<!-- Footer Start -->
		<div class="container-fluid pt-4 px-4">
			<div class="bg-light rounded-top p-4">
				<div class="row">
					<div class="col-12 col-sm-6 text-center text-sm-start">
						&copy; <a href="#">Your Site Name</a>, All Right Reserved.
					</div>
					<div class="col-12 col-sm-6 text-center text-sm-end">
						<!--/*** This template is free as long as you keep the footer authorâs credit link/attribution link/backlink. If you'd like to use the template without the footer authorâs credit link/attribution link/backlink, you can purchase the Credit Removal License from "https://htmlcodex.com/credit-removal". Thank you for your support. ***/-->
						Designed By <a href="https://htmlcodex.com">HTML Codex</a>
					</div>
				</div>
			</div>
		</div>
		<!-- Footer End -->
		<!-- Content End -->
	</div>
	<!-- Back to Top -->
	<a href="#" class="btn btn-lg btn-danger btn-lg-square back-to-top"><i
		class="bi bi-arrow-up"></i></a>

</body>
