<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="nowPage" value="" />
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<head>
<meta charset="utf-8">
<title>PARADICE | 쿠폰관리</title>
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
			url : "${ctp}/admin/order/couponListSearch",
			data : {
				pay_methodList: payMethodList,
				o_statusList: o_statusList,
				o_cStatusList: o_cStatusList,
				startDate : $("#startDate").val(),
				endDate : $("#endDate").val(),
				durationCategory: couponListSearch.durationCategory.value,
				searchCategory: couponListSearch.searchCategory.value,
				searchKeyword:  couponListSearch.searchKeyword.value
			},
			success : function(res) {
			},
			error : function() {
				alert("전송오류!");
			}
		}); 
	}


	function statusChange(){
		let oi_productCodeList = "";
		let count = 0;
		for(let i=0; i<grid.getCheckedRows().length; i++){
			let oi_productCode = grid.getCheckedRows()[i].oi_productCode;
			if(oi_productCodeList.indexOf(oi_productCode)==-1){
				oi_productCodeList += oi_productCode + "/";
			}
			count++;
		}
		let updateStatus = updateStatusForm.updateStatus.value;
		if(updateStatus=="" || count==0) {
			let msg = "";
			if(updateStatus=="") msg = "변경할 상태를 선택해 주세요."
			else msg = "최소 하나 이상의 주문을 선택해 주세요."
			Swal.fire({
				width:500,
			  position: 'center',
			  icon: 'error',
			  title: msg,
			  showConfirmButton: false,
			  timer: 1000
			})
			return;
		}
		Swal.fire({
			  title: '선택하신 '+count+'개의 주문을 \n'+updateStatus+'으로 변경하시겠습니까?',
			  showDenyButton: true,
			  confirmButtonText: '확인',
			  denyButtonText: '취소',
			}).then((result) => {
			  if (result.isConfirmed) {
					$.ajax({
						type : "post",
						url : "${ctp}/admin/order/orderStatusUpdate",
						data : {
							oi_productCodeList: oi_productCodeList,
							updateStatus: updateStatus
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
									if(updateStatus == "배송준비") location.href='${ctp}/admin/order/deliveryList';
									else location.reload();
									
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
							<form name="couponListSearch">
								<div class="bg-white rounded-lg p-3 mb-3">
									<h5 class="mb-2">쿠폰 관리</h5>
									<div class="p-3">
										<div class="row border align-items-center" id="searchForm">
											<div class="col-xl-12">
												<!-- 여기서부터 묶어주기 -->
												<div id="hideSearchForm">
													<div class="row border-bottom">
														<div
															class="col-sm-2 col-xl-2 p-0 d-flex align-items-center justify-content-center"
															style="background: #eee;">
															<div>사용 상태</div>
														</div>
														<div class="col-sm-10 col-xl-10">
															<div class="row p-3 d-flex flex-column">
																<!-- 입금 완료 ~ 배송 처리 -->
																<div class="row p-2">
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="o_status" id="o_status1" value="결제대기" /> <label
																			class="custom-control-label black" for="o_status1">사용가능</label>
																	</div>
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="o_status" id="o_status2" value="결제완료" /> <label
																			class="custom-control-label black" for="o_status2">사용완료</label>
																	</div>
																</div>
															</div>
														</div>
													</div>

													<div class="row  border-bottom">
														<div
															class="col-sm-2 col-xl-2 p-0 d-flex align-items-center justify-content-center "
															style="background: #eee;">
															<div>쿠폰 타입</div>
														</div>
														<div class="col-sm-10 col-xl-10">
															<div class="row p-3 d-flex flex-column">
																<!-- 입금 완료 ~ 배송 처리 -->
																<div class="row p-2">
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="pay_method" id="pay_method_1" value="card" />
																		<label class="custom-control-label black"
																			for="pay_method_1">정액</label>
																	</div>
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="pay_method" id="pay_method_2" value="vbank" />
																		<label class="custom-control-label black"
																			for="pay_method_2">정율</label>
																	</div>
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="pay_method" id="pay_method_3" value="trans" />
																		<label class="custom-control-label black"
																			for="pay_method_3">배송비</label>
																	</div>
																</div>
															</div>
														</div>
													</div>

													<!-- 검색 -->
													<div class="row border-bottom">
														<div
															class="col-sm-2 col-xl-2 p-0 d-flex align-items-center justify-content-center "
															style="background: #eee;">
															<div>검색</div>
														</div>
														<div class="col-sm-10 col-xl-10">
															<div class="row p-3 d-flex flex-column">
																<!-- 입금 완료 ~ 배송 처리 -->
																<div class="row p-2">
																	<div class="custom-input mr-3">
																		<select class="btn border" name="searchCategory">
																			<option value="m_mid">쿠폰 이름</option>
																			<option value="m_mid">쿠폰 고유번호</option>
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
															<div class="row p-3 d-flex flex-column">
																<!-- 입금 완료 ~ 배송 처리 -->
																<div class="row p-2">
																	<div class="custom-input mr-3">
																		<select class="btn border" name="durationCategory"
																			id="durationCategory">
																			<option value="pay_date">발급일자</option>
																			<option value="o_date">사용일자</option>
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
																class="row p-3 d-flex flex-column align-items-center">
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
														<div class="row p-3 d-flex flex-column align-items-center">
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
					<div class="row mb-4">
						<div class="col-sm-12 col-xl-12  h-100">
							<!-- 오른쪽 카테고리 등록부분 -->
							<!-- Form Start -->
							<div class="bg-white rounded-lg p-4 mb-3">
								<h5 class="mb-2">쿠폰 발급 현황</h5>
								<div class="custom-input d-flex mr-3 justify-content-between">
									<div class=" d-flex">
										<form name="updateCouponSelect">
											<select class="btn border" name="updateStatus">
												<option value="">선택</option>
												<option>사용가능</option>
												<option>사용완료</option>
												<option>사용불가</option>
											</select>
										</form>
										<button type="button" class="btn-black btn-small ml-2"
											onclick="">일괄변경</button>
									</div>
									<div>
										<button type="button" class="btn-black-outline btn-small ml-2"
											onclick="">일괄삭제</button>
									</div>
								</div>
								<div class="table-responsive">
									<table
										class="table text-start align-middle table-bordered table-hover mb-0">
										<thead>
											<tr class="text-dark bg-light pretendard text-sm ">
												<th scope="col"></th>
												<th scope="col">번호</th>
												<th scope="col">아이디</th>
												<th scope="col" style="width: 100px">혜택구분</th>
												<!-- 1 정액 2 정율 -->
												<th scope="col" style="width: 100px">혜택</th>
												<th scope="col">쿠폰이름</th>
												<th scope="col" style="width: 100px">유효기간</th>
												<th scope="col" style="width: 100px">상태</th>
											</tr>
										</thead>
										<tbody id="couponList" class="nanumbarungothic text-center"
											style="vertical-align: middle;" class="text-center">
											<c:forEach var="vo" items="${vos}" varStatus="st">
												<tr>
													<td></td>
													<td>${st.count}</td>
													<td>${vo.m_mid}</td>
													<td><c:if test="${vo.cp_type == 0}">정액</c:if> <c:if
															test="${vo.cp_type == 1}">정율</c:if> <c:if
															test="${vo.cp_type == 2}">배송비</c:if></td>
													<td><c:if test="${vo.cp_type == 0}">${vo.cp_price}원</c:if>
														<c:if test="${vo.cp_type == 1}">
															<fmt:formatNumber type="number" maxFractionDigits="0"
																value="${vo.cp_ratio}" />%</c:if></td>
													<td>${vo.cp_name}</td>
													<td><c:if test="${vo.cu_status}">사용완료</c:if> <c:if
															test="${!vo.cu_status}">사용가능</c:if></td>
													<td><a href="#" class='btn btn-sm btn-danger'
														onclick="updateView(${vo.cp_idx},'${vo.cp_name}', ${vo.cp_type}, ${vo.cp_price}, ${vo.cp_ratio}, ${vo.cp_minValue}, ${vo.cp_exPeriod}, ${vo.cp_useAvailable})"
														data-toggle="modal" data-target="#myModal"> Detail</a></td>
												</tr>
											</c:forEach>
										</tbody>
									</table>
								</div>

								<!-- 블록 페이징 처리 -->
								<div class="text-center m-4">
									<ul class="pagination justify-content-center pagination-sm">
										<c:if test="${pageVO.pag > 1}">
											<li class="page-item"><a
												class="page-link text-secondary"
												href="${ctp}/admin/coupon?pageSize=${pageVO.pageSize}&pag=1">첫페이지</a></li>
										</c:if>
										<c:if test="${pageVO.curBlock > 0}">
											<li class="page-item"><a
												class="page-link text-secondary"
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
											<li class="page-item"><a
												class="page-link text-secondary"
												href="${ctp}/admin/coupon?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock+1)*pageVO.blockSize + 1}">다음블록</a></li>
										</c:if>
										<c:if test="${pageVO.pag < pageVO.totPage}">
											<li class="page-item"><a
												class="page-link text-secondary"
												href="${ctp}/admin/coupon?pageSize=${pageVO.pageSize}&pag=${pageVO.totPage}">마지막페이지</a></li>
										</c:if>
									</ul>
								</div>


							</div>
							<!-- 흰 배경 안으로 묶어줌 -->
						</div>
						<!-- col 종료 -->
					</div>

					<input type="hidden" name="index" id="index" value="${count}">
				</div>



			</div>
			<!-- 226라인 row end -->
		</div>
		<!-- 왼쪽 종료 -->


		<!-- 하나로 묶기 위한 row 종료 -->



		<!-- Footer Start -->
		<div class="container-fluid pt-4 px-4">
			<div class="bg-light rounded-top p-3">
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
	</div>
	<!-- Content End -->

	<!-- Back to Top -->
	<a href="#" class="btn btn-lg btn-danger btn-lg-square back-to-top"><i
		class="bi bi-arrow-up"></i></a>

</body>
