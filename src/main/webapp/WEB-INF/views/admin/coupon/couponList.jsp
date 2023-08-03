<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<head>
<meta charset="utf-8">
<title>PARADICE | 관리자 쿠폰 등록</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="" name="keywords">
<meta content="" name="description">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
</head>
<script>
	'use strict';

	function hideSearch(){
		$("#couponInsert").hide(500);
		$("#hideBtn").css('display','none');
		$("#showBtn").css('display','block');
	}
	function showSearch(){
		$("#couponInsert").show(500);
		$("#hideBtn").css('display','block');
		$("#showBtn").css('display','none');
	}

	
	
	$(document).ready(function(){
		//쿠폰 리스트 
		$("#cp_type").change(function(){
	        var ct1 = document.getElementById("cp_type").value;
	        if(ct1==0){
	          $("#ct1").show();
	          $("#ct2").hide();
	          $("#cp_price").val(0);
	          $("#cp_price").prop('readonly', false);
	        }else if(ct1==1){
	          $("#ct2").show();
	          $("#ct1").hide();
	        }else{
	          $("#ct1").show();
	          $("#cp_price").val(3000);
	          $("#cp_price").prop('readonly', true);
	          $("#ct2").hide();
	        }
	    });
		$("#m_cp_type").change(function(){
	        var m_ct1 = document.getElementById("m_cp_type").value;
	        if(m_ct1==0){
	          $("#m_ct1").show();
	          $("#m_ct2").hide();
	        }else if(m_ct1==1){
	          $("#m_ct2").show();
	          $("#m_ct1").hide();
	        }else{
	          $("#m_ct1").show();
	          $("#m_ct2").hide();
	        }
	    });
		
		$("#cp_exPeriod_none").change(function(){
			var noneCheck = document.getElementById("cp_exPeriod_none").checked;
			if(noneCheck){
				$("#cp_exPeriod").val(0);
				$("#cp_exPeriod").attr("readonly", true);
			}
			else {
				$("#cp_exPeriod").attr("readonly", false);
			}
		});
    
		$("#m_cp_exPeriod_none").change(function(){
			var noneCheck = document.getElementById("m_cp_exPeriod_none").checked;
			if(noneCheck){
				$("#m_cp_exPeriod").val(0);
				$("#m_cp_exPeriod").attr("readonly", true);
			}
			else {
				$("#m_cp_exPeriod").attr("readonly", false);
			}
		});
	});
    
	function insertCoupon(){
		couponInsert.submit();
	}
	
	function updateView(cp_idx, cp_name, cp_type, cp_price, cp_ratio, cp_minValue, cp_exPeriod, cp_useAvailable){
		$("#myModal").on("show.bs.modal", function(e){
    		$(".modal-body #m_cp_idx").val(cp_idx);
    		$(".modal-body #m_cp_name").val(cp_name);
    		$(".modal-body #m_cp_type").val(cp_type);
    		$(".modal-body #m_cp_price").val(cp_price);
    		$(".modal-body #m_cp_ratio").val(cp_ratio);
    		$(".modal-body #m_cp_minValue").val(cp_minValue);
    		$(".modal-body #m_cp_exPeriod").val(cp_exPeriod);
    		$(".modal-body #m_cp_useAvailable").val(cp_useAvailable);
    		
        let m_cp_type = document.getElementById("m_cp_type").value;
        if(m_cp_type==0){
          $("#m_ct1").show();
          $("#m_ct2").hide();
        }else if(cp_type==1){
          $("#m_ct2").show();
          $("#m_ct1").hide();
        }else{
          $("#m_ct1").show();
          $("#m_ct2").hide();
        }
    	});
	}
	
	function couponUpdate(){
		$.ajax({
			url: "${ctp}/admin/coupon/couponUpdate",
			method: "POST",
			data: {
				cp_idx : m_couponUpdate.m_cp_idx.value,
				cp_name : m_couponUpdate.m_cp_name.value,
				cp_exPeriod : m_couponUpdate.m_cp_exPeriod.value,
				cp_type : m_couponUpdate.m_cp_type.value,
				cp_price : m_couponUpdate.m_cp_price.value,
				cp_ratio : m_couponUpdate.m_cp_ratio.value,
				cp_useAvailable : m_couponUpdate.m_cp_useAvailable.value,
				cp_minValue : m_couponUpdate.m_cp_minValue.value
			},
			success: function(res){
				if(res == "1") alert("수정완료");
				location.reload();
      },
		error: function() {
			alert("전송오류");
		}
		});
	}
	
	function giveUserCoupon() {
		$.ajax({
			url: "${ctp}/admin/coupon/giveCoupon",
			method: "POST",
			data: {
				giveCoupon_level: $("#giveCoupon_level").val(),
				giveCoupon_select: $("#giveCoupon_select").val()
			},
			success: function(res) {
				if (res == "1") {
					Swal.fire({
						width:500,
					  position: 'center',
					  icon: 'success',
					  title: '정상적으로 발급 처리되었습니다.',
					  showConfirmButton: false,
					  timer: 1000
					})
				}
			},
			error: function() {
				alert("전송오류");
			}
		});
	}
</script>
<body>

	<div class="container-xxl position-relative bg-white d-flex p-0">
		<!-- Spinner Start -->
		<div id="spinner"
			class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
			<div class="spinner-border text-primary"
				style="width: 3rem; height: 3rem;" role="status">
				<span class="sr-only">Loading...</span>
			</div>
		</div>
		<!-- Spinner End -->

		<jsp:include page="/WEB-INF/views/admin/adminNav.jsp" />


		<div class="container-fluid pt-4 px-4">
			<div class="row">
				<div class="col-sm-12 col-xl-12  h-100">
					<!-- 오른쪽 카테고리 등록부분 -->
					<!-- Form Start -->
					<div class="bg-white rounded-lg p-4 mb-3">
						<h5 class="mb-2">쿠폰 등록</h5>

						<div class="table-responsive">
							<form name="couponInsert" id="couponInsert" method="post"
								action="${ctp}/admin/coupon/couponInsert">
								<table
									class="table text-start align-middle table-bordered table-hover mb-0">
									<tbody>
										<tr>
											<th scope="row">쿠폰명</th>
											<td><input type="text" class="form-control"
												name="cp_name" id="cp_name" required></td>
										</tr>
										<tr>
											<th scope="row">쿠폰타입</th>
											<td><select class="form-control" name="cp_type"
												id="cp_type">
													<option value="0">정액</option>
													<option value="1">정율</option>
													<option value="2">배송비</option>
											</select></td>
										</tr>
										<tr id="ct1">
											<th scope="row">할인가</th>
											<td>
												<div class="input-group">
													<input type="number"
														style="width: 200px; text-align: right;"
														class="form-control" name="cp_price" id="cp_price"
														value='0'> <span class="input-group-text">원</span>
												</div>
											</td>
										</tr>
										<tr id="ct2" style="display: none;">
											<th scope="row">할인비율</th>
											<td>
												<div class="input-group">
													<input type="number"
														style="width: 200px; text-align: right;"
														class="form-control" name="cp_ratio" id="cp_ratio"
														value='0'> <span class="input-group-text">%</span>
												</div>
											</td>
										</tr>
										<tr>
											<th scope="row">최소사용금액</th>
											<td>
												<div class="input-group">
													<input type="number"
														style="width: 200px; text-align: right;"
														class="form-control" name="cp_minValue" id="cp_minValue"
														value='0'> <span class="input-group-text">원</span>
												</div>
											</td>
										</tr>
										<tr>
											<th scope="row">상태</th>
											<td><select class="form-control" name="cp_useAvailable"
												id="cp_useAvailable">
													<option value="0">발급대기</option>
													<option value="1">발급가능</option>
													<option value="2">발급불가</option>
											</select></td>
										</tr>
										<tr>
											<th scope="row">유효기간</th>
											<td>
												<div class="input-group">
													<input type="number"
														style="width: 200px; text-align: right;"
														class="form-control" name="cp_exPeriod" id="cp_exPeriod"
														value='0'> <span class="input-group-text">일</span>
													<div
														class="custom-control custom-checkbox d-flex align-items-center ml-3">
														<input type="checkbox" class="custom-control-input"
															name="cp_exPeriod_none" id="cp_exPeriod_none" value="on" />
														<label class="custom-control-label black"
															for="cp_exPeriod_none">유효기간 없음</label>
													</div>
												</div> <span class="extraText">*사용자가 쿠폰을 발급받은 후 해당 쿠폰이 얼마나
													유효한지 기간을 설정합니다.</span>
											</td>
										</tr>
									</tbody>
								</table>
								<div class="row m-0 border-bottom">
									<div class="col-sm-12 col-xl-12">
										<div class="row p-4 d-flex flex-column align-items-center">
											<div class="row p-2">
												<button type="button" class="btn-black mr-2"
													onclick="insertCoupon()">
													<i class="fas fa-search"></i>&nbsp;등록
												</button>
												<button type="button" class="btn-black-outline"
													onclick="location.reload();">
													<i class="fas fa-undo"></i>&nbsp;초기화
												</button>
											</div>
										</div>
									</div>
								</div>
							</form>

							<div class="row m-0 border-bottom" id="showButton">
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
				<!-- col 종료 -->
			</div>
			<!-- 쿠폰 등록 row 종료 -->


			<!-- 쿠폰 발급 -->
			<div class="row">
				<div class="col-sm-12 col-xl-12  h-100">
					<!-- 오른쪽 카테고리 등록부분 -->
					<!-- Form Start -->
					<div class="bg-white rounded-lg p-4 mb-3">
						<h5 class="mb-2">쿠폰 일괄 발급</h5>
						<span class="extraText">*회원이 이미 동일한 쿠폰을 보유하고 있는 경우 해당 회원은
							발급 대상에서 제외됩니다.</span>
						<div class="table-responsive">
							<form name="giveCoupon" id="giveCoupon">
								<table
									class="table text-start align-middle table-bordered table-hover mb-0">
									<tbody>
										<tr>
											<th scope="row">발급 대상</th>
											<td><select class="form-control" name="giveCoupon_level"
												id="giveCoupon_level">
													<option value="0">전체 회원</option>
													<option value="1">실버 등급</option>
													<option value="2">골드 등급</option>
													<option value="3">VIP 등급</option>
													<option value="4">VVIP 등급</option>
											</select></td>
										</tr>
										<tr>
											<th scope="row">쿠폰 선택</th>
											<td>
												<div class="input-group">
													<select class="form-control" name="giveCoupon_select"
														id="giveCoupon_select">
														<c:forEach var="coupon" items="${coupons}" varStatus="st">
															<option value="${coupon.cp_idx}">${coupon.cp_name}</option>
														</c:forEach>
													</select>
												</div> <span class="extraText">*발급 가능으로 설정된 쿠폰만 선택 가능합니다.</span>
											</td>
										</tr>
									</tbody>
								</table>
								<div class="row m-0 border-bottom">
									<div class="col-sm-12 col-xl-12">
										<div class="row p-4 d-flex flex-column align-items-center">
											<div class="row p-2">
												<button type="button" class="btn-black mr-2"
													onclick="giveUserCoupon()">발급</button>
											</div>
										</div>
									</div>
								</div>
							</form>

						</div>

					</div>
				</div>
				<!-- col 종료 -->
			</div>
			<!-- 쿠폰발급 row 종료 -->

			<div class="row">
				<div class="col-sm-12 col-xl-12">
					<div class="row mb-4">
						<div class="col-sm-12 col-xl-12  h-100">
							<!-- 오른쪽 카테고리 등록부분 -->
							<!-- Form Start -->
							<div class="bg-white rounded-lg p-4 mb-3">
								<h5 class="mb-2">쿠폰 조회</h5>
								<div class="custom-input d-flex mr-3 justify-content-between">
									<div class=" d-flex">
										<form name="updateCouponSelect">
											<select class="btn border" name="updateStatus">
												<option value="">선택</option>
												<option>발급대기</option>
												<option>발급가능</option>
												<option>발급불가</option>
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
												<th scope="col">번호</th>
												<th scope="col">쿠폰이름</th>
												<th scope="col">혜택구분</th>
												<!-- 1 정액 2 정율 -->
												<th scope="col">혜택</th>
												<th scope="col" style="width: 100px">최소 <br />사용금액
												</th>
												<th scope="col" style="width: 100px">유효기간</th>
												<th scope="col" style="width: 100px">상태</th>
												<th scope="col" style="width: 100px">수정</th>
											</tr>
										</thead>
										<tbody id="couponList" class="nanumbarungothic text-center"
											style="vertical-align: middle;" class="text-center">
											<c:forEach var="vo" items="${vos}" varStatus="st">
												<tr>
													<td>${st.count}</td>
													<td>${vo.cp_name}</td>
													<td><c:if test="${vo.cp_type == 0}">정액</c:if> <c:if
															test="${vo.cp_type == 1}">정율</c:if> <c:if
															test="${vo.cp_type == 2}">배송비</c:if></td>
													<td><c:if test="${vo.cp_type == 0}">${vo.cp_price}원</c:if>
														<c:if test="${vo.cp_type == 1}">
															<fmt:formatNumber type="number" maxFractionDigits="0"
																value="${vo.cp_ratio}" />%</c:if></td>
													<td>${vo.cp_minValue}</td>
													<td>${vo.cp_exPeriod}일</td>
													<td><c:if test="${vo.cp_useAvailable == 0}">발급대기</c:if>
														<c:if test="${vo.cp_useAvailable == 1}">발급가능</c:if> <c:if
															test="${vo.cp_useAvailable == 2}">발급불가</c:if></td>
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
			<!-- 하나로 묶기 위한 row 종료 -->




			<!-- The Modal('회원 아이디' 클릭시 회원의 상세정보를 모달창에 출력한다. -->
			<div class="modal fade" id="myModal" style="width: 690px;">
				<div class="modal-dialog">
					<div class="modal-content" style="width: 600px;">

						<!-- Modal Header -->
						<div class="modal-header" style="width: 600px;">
							<h4 class="modal-title">쿠폰 수정</h4>
							<button type="button" class="close" data-dismiss="modal">&times;</button>
						</div>

						<!-- Modal body -->
						<div class="modal-body">
							<!-- Form Start -->
							<form name="m_couponUpdate">
								<div class="bg-white rounded-lg p-4 mb-3">
									<input type="hidden" name="m_cp_idx" id="m_cp_idx">
									<div class="table-responsive">
										<table
											class="table text-start align-middle table-bordered table-hover mb-0">
											<tbody>
												<tr>
													<th scope="row">쿠폰명</th>
													<td><input type="text" class="form-control"
														name="m_cp_name" id="m_cp_name" required></td>
												</tr>
												<tr>
													<th scope="row">쿠폰타입</th>
													<td><select class="form-control" name="m_cp_type"
														id="m_cp_type">
															<option value="0">정액</option>
															<option value="1">정율</option>
															<option value="2">배송비</option>
													</select></td>
												</tr>
												<tr id="m_ct1">
													<th scope="row">할인가</th>
													<td>
														<div class="input-group">
															<input type="number"
																style="width: 200px; text-align: right;"
																class="form-control" name="m_cp_price" id="m_cp_price"
																value='0'> <span class="input-group-text">원</span>
														</div>
													</td>
												</tr>
												<tr id="m_ct2" style="display: none;">
													<th scope="row">할인비율</th>
													<td>
														<div class="input-group">
															<input type="number"
																style="width: 200px; text-align: right;"
																class="form-control" name="m_cp_ratio" id="m_cp_ratio"
																value='0'> <span class="input-group-text">%</span>
														</div>
													</td>
												</tr>
												<tr>
													<th scope="row">최소사용금액</th>
													<td>
														<div class="input-group">
															<input type="number"
																style="width: 200px; text-align: right;"
																class="form-control" name="m_cp_minValue"
																id="m_cp_minValue" value='0'> <span
																class="input-group-text">원</span>
														</div>
													</td>
												</tr>
												<tr>
													<th scope="row">상태</th>
													<td><select class="form-control"
														name="m_cp_useAvailable" id="m_cp_useAvailable">
															<option value="0">발급대기</option>
															<option value="1">발급가능</option>
															<option value="2">발급불가</option>
													</select></td>
												</tr>
												<tr>
													<th scope="row">유효기간</th>
													<td>
														<div class="input-group">
															<input type="number"
																style="width: 200px; text-align: right;"
																class="form-control" name="m_cp_exPeriod"
																id="m_cp_exPeriod" value='0'> <span
																class="input-group-text">일</span>
															<div
																class="custom-control custom-checkbox d-flex align-items-center ml-3">
																<input type="checkbox" class="custom-control-input"
																	name="m_cp_exPeriod_none" id="m_cp_exPeriod_none"
																	value="on" /> <label
																	class="custom-control-label black"
																	for="m_cp_exPeriod_none">유효기간 없음</label>
															</div>
														</div> <span class="extraText">*사용자가 쿠폰을 발급받은 후 해당 쿠폰이
															얼마나 유효한지 기간을 설정합니다.</span>
													</td>
												</tr>
											</tbody>
										</table>

									</div>

								</div>
							</form>
						</div>

						<!-- Modal footer -->
						<div class="modal-footer" style="width: 600px;">
							<button type="button" class="btn-black mr-2"
								onclick="couponUpdate()">수정</button>
							<button type="button" class="btn-black-outline"
								data-dismiss="modal">닫기</button>
						</div>

					</div>
				</div>
			</div>








		</div>


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
	</div>
	<!-- Content End -->

	<!-- Back to Top -->
	<a href="#" class="btn btn-lg btn-danger btn-lg-square back-to-top"><i
		class="bi bi-arrow-up"></i></a>

</body>

