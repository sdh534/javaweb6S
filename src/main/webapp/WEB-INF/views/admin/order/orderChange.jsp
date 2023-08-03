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
		    el.href = 'javascript:orderModify('+grid.getRow(props.rowKey).oi_proudctCode+')'

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
			    	    header: '처리상태',
			    	    name: 'o_status',
			    	    align: 'center',
			    	    filter: 'select',
			    	    width: 90,
			    	    formatter: 'listItemText',
			    	    editor: {
				    	    type: 'select',
				    	    options:{
				    	    	listItems:[
						    	    {text: '결제대기', value: '결제대기'},
						    	    {text: '결제완료', value: '결제완료'},
						    	    {text: '배송준비', value: '배송준비'},
						    	    {text: '배송지연', value: '배송지연'},
						    	    {text: '배송완료', value: '배송완료'},
						    	    {text: '주문취소', value: '주문취소'}
					    	    ],
				    	    }
			    	 		}
			    	},
			    	{
			    	    header: '주문일자',
			    	    name: 'o_date',
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
			    	    header: '상품 사진',
			    	    name: 'p_thumbnailIdx',
			    	    renderer: {
			                type: CustomRenderer,
			                options: {
			                	
			                }
			              },
			    	    width: 80
			    	},
		    	  {
		    	    header: '상품명',
		    	    name: 'p_name',
		    	    editor: 'text',
		    	    filter: 'text',
		    	    sortable: true,
	    	      sortingType: 'desc',
	    	      width: 100
		    	  },
		    	  {
			    	    header: '총 결제금액',
			    	    name: 'pay_price',
			    	    align: 'center',
			    	    width: 150,
			    	    filter: 'number',
			    	    sortable: true,
			    	    rowSpan: true,
		    	      sortingType: 'desc',
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
		    ]
		    /* columnOptions: {
		        frozenCount: 2, // 3개의 컬럼을 고정하고
		        frozenBorderWidth: 2 // 고정 컬럼의 경계선 너비를 2px로 한다.
		      } */
		});
		
		
	    $.ajax({
	        url : "${ctp}/admin/order/allOrderChangeList",
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
					grid.resetData(res);
			},
			error : function() {
				alert("전송오류!");
			}
		}); 
	}

	function orderModify(idx){
   	location.href = '${ctp}/admin/order/orderInfo?o_idx='+idx;
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
							<form name="orderListSearch">
								<div class="bg-white rounded-lg p-3 mb-3">
									<h5 class="mb-2">주문 관리</h5>
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
																<!-- 입금 완료 ~ 배송 처리 -->
																<div class="row p-2 ">
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="o_status" id="o_status1" value="결제대기" /> <label
																			class="custom-control-label black" for="o_status1">결제대기</label>
																	</div>
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="o_status" id="o_status2" value="결제완료" /> <label
																			class="custom-control-label black" for="o_status2">결제완료</label>
																	</div>
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="o_status" id="o_status3" value="주문취소" /> <label
																			class="custom-control-label black" for="o_status3">주문취소</label>
																	</div>
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="o_status" id="o_status4" value="배송준비" /> <label
																			class="custom-control-label black" for="o_status4">배송준비</label>
																	</div>
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="o_status" id="o_status5" value="배송중" /> <label
																			class="custom-control-label black" for="o_status5">배송중</label>
																	</div>
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="o_status" id="o_status6" value="배송지연" /> <label
																			class="custom-control-label black" for="o_status6">배송지연</label>
																	</div>
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="o_status" id="o_status7" value="배송완료" /> <label
																			class="custom-control-label black" for="o_status7">배송완료</label>
																	</div>
																</div>
															</div>
														</div>
													</div>

													<div class="row  border-bottom">
														<div
															class="col-sm-2 col-xl-2 p-0 d-flex align-items-center justify-content-center "
															style="background: #eee;">
															<div>결제방법</div>
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
																			for="pay_method_1">카드</label>
																	</div>
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="pay_method" id="pay_method_2" value="vbank" />
																		<label class="custom-control-label black"
																			for="pay_method_2">가상계좌</label>
																	</div>
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="pay_method" id="pay_method_3" value="trans" />
																		<label class="custom-control-label black"
																			for="pay_method_3">실시간 계좌이체</label>
																	</div>
																	<div
																		class="custom-control custom-checkbox d-flex align-items-center mr-3">
																		<input type="checkbox" class="custom-control-input"
																			name="pay_method" id="pay_method_4" value="phone" />
																		<label class="custom-control-label black"
																			for="pay_method_4">휴대폰</label>
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
																			<option value="">선택</option>
																			<option value="m_mid">주문자 아이디</option>
																			<option value="o_orderCode">주문 번호</option>
																			<option value="oi_productCode">결제 번호</option>
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
											<option>결제완료</option>
											<option>배송준비</option>
											<option>배송중</option>
											<option>배송지연</option>
											<option>배송완료</option>
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
