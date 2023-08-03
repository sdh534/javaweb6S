<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="nowPage" value="" />
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<head>
<meta charset="utf-8">
<title>PARADICE | 주문관리</title>
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
	var grid;
	class LinkRenderer {
		  constructor(props) {
		    const el = document.createElement('a');
		 		const propsData = props.formattedValue
		  
		    el.text = propsData;
		   /*  console.log(el) */

		    el.addEventListener('mousedown', (ev) => {
		      ev.stopPropagation();
		    });
		    el.href = 'javascript:orderModify('+grid.getRow(props.rowKey).o_idx+')'

		    this.el = el;
		    this.render(props);
		  }

		  getElement() {
		    return this.el;
		  }

		  render(props) {
		    this.el.value = String(props.value);
		  }
		}
	window.onload = function(){
		 grid = new tui.Grid({
		    el: document.getElementById("orderList"),
		    scrollX: true,
		    scrollY: false,
		    minRowHeight: 80,
		    pageOptions: {  
	    	  centerAlign: true,
		    	useClient: true,
		    	initialRequest: false,
		      perPage: 10 
		    },
		    rowHeaders: ['rowNum', 'checkbox'],
		    columns: [
		    		{
		    	    header: '주문 코드',
		    	    name: 'o_orderCode',
		    	    align: 'center',
		    	    rowSpan: true,
		    	    width: 150
		    	  },
		    	  {
			    	    header: '요청상태',
			    	    name: 'cs_status',
			    	    align: 'center',
			    	    filter: 'select',
			    	    width: 90
			    	},
			    	{
			    	    header: '요청일자',
			    	    name: 'cs_date',
			    	    align: 'center',
			    	    rowSpan: true,
			    	    width: 150
			    	},
			    	{
			    	    header: '주문자',
			    	    name: 'm_mid',
			    	    align: 'center',
			    	    width: 80
			    	},
		    	  {
		    	    header: '상품명',
		    	    name: 'p_name',
		    	    editor: 'text',
		    	    filter: 'text',
		    	    sortable: true,
	    	      sortingType: 'desc',
	    	      width: 200
		    	  },
			    	{
			    	    header: '상세',
			    	    name: 'orderModify',
			    	    align: 'center',
			    	    renderer: {
			    	        type: LinkRenderer
			    	      },
			    	    width: 60
			    	 }
		    ],
		    columnOptions: {
		        frozenCount: 2, // 3개의 컬럼을 고정하고
		        frozenBorderWidth: 2 // 고정 컬럼의 경계선 너비를 2px로 한다.
		      }
		});
		
		
	    $.ajax({
	        url : "${ctp}/admin/order/allCancelList",
	        method :"POST",
	        dataType : "JSON",
	        success : function(result){
	            grid.resetData(result);
	        } 
	    });
	    
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
	
	function orderModify(idx){
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
				durationCategory: orderListSearch.durationCategory.value
			},
			success : function(res) {
					grid.resetData(res);
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
			oi_productCodeList += oi_productCode + "/";
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
						url : "${ctp}/admin/order/orderCSUpdate",
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
									location.reload();
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
				<div class="col-sm-12 col-xl-12">
					<div class="row mb-4">
						<div class="col-sm-12 col-xl-12  h-100">
							<!-- 오른쪽 카테고리 등록부분 -->
							<!-- Form Start -->
							<form name="orderListSearch">
								<div class="bg-white rounded-lg p-3 mb-3">
									<h5 class="mb-2">환불/취소 관리</h5>
									<div class="p-3">
										<div class="row border align-items-center" id="searchForm">
											<div class="col-xl-12">
												<!-- 여기서부터 묶어주기 -->
												<div id="hideSearchForm">
													<div class="row border-bottom">
														<div
															class="col-sm-2 col-xl-2 p-0 d-flex align-items-center justify-content-center"
															style="background: #eee;">
															<div>처리상태</div>
														</div>
														<div class="col-sm-10 col-xl-10">
															<div class="row p-3 d-flex flex-column">
																<div class="row p-2 border-bottom">
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="o_cStatus" id="o_cStatus1" value="취소요청" /> <label
																			class="custom-control-label black" for="o_cStatus1">취소요청</label>
																	</div>
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="o_cStatus" id="o_cStatus2" value="취소완료" /> <label
																			class="custom-control-label black" for="o_cStatus2">취소완료</label>
																	</div>
																</div>
																<div class="row p-2 border-bottom">
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="o_cStatus" id="o_cStatus3" value="반품요청" /> <label
																			class="custom-control-label black" for="o_cStatus3">반품요청</label>
																	</div>
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="o_cStatus" id="o_cStatus4" value="반품승인" /> <label
																			class="custom-control-label black" for="o_cStatus4">반품승인</label>
																	</div>
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="o_cStatus" id="o_cStatus5" value="반품확정" /> <label
																			class="custom-control-label black" for="o_cStatus5">반품확정</label>
																	</div>
																</div>
																<div class="row p-2">
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="o_cStatus" id="o_cStatus6" value="교환요청" /> <label
																			class="custom-control-label black" for="o_cStatus6">교환요청</label>
																	</div>
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="o_cStatus" id="o_cStatus7" value="교환승인" /> <label
																			class="custom-control-label black" for="o_cStatus7">교환승인</label>
																	</div>
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="o_cStatus" id="o_cStatus8" value="교환확정" /> <label
																			class="custom-control-label black" for="o_cStatus8">교환확정</label>
																	</div>
																</div>
															</div>
														</div>
													</div>


													<!-- 검색 -->

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
					<div class="bg-white rounded-lg h-100 p-3">
						<h5 class="mb-4">상품 조회</h5>
						<div class="mb-3">
							<div class="mb-2 d-flex">
								<div class="custom-input mr-3">
									<form name="updateStatusForm">
										<select class="btn border" name="updateStatus">
											<option value="">선택</option>
											<option>반품완료</option>
											<option>교환완료</option>
										</select>
									</form>
								</div>
								<button type="button" class="btn-black btn-small mr-2"
									onclick="statusChange()">변경</button>
							</div>
							<div class="orderList" id="orderList"
								style="height: 100%; width: 100%;"></div>
						</div>
					</div>
				</div>


			</div>
			<!-- 226라인 row end -->
		</div>
		<!-- 왼쪽 종료 -->


	</div>
	<!-- 하나로 묶기 위한 row 종료 -->
	</div>



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
