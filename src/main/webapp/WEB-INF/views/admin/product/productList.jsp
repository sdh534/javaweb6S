<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="nowPage" value="" />
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<head>
<meta charset="utf-8">
<title>PARADICE | 관리자 상품관리</title>
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
		    el.href = 'javascript:productModify('+grid.getRow(props.rowKey).p_idx+')'

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
	class LinkRenderer2 {
		  constructor(props) {
		    const el = document.createElement('a');
		 		const propsData = props.formattedValue
		  
		    el.text = propsData;
		   /*  console.log(el) */

		    el.addEventListener('mousedown', (ev) => {
		      ev.stopPropagation();
		    });
		    el.href = 'javascript:productDelete('+grid.getRow(props.rowKey).p_idx+')'

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
	    $.ajax({
	        url : "${ctp}/admin/product/allProductList",
	        method :"GET",
	        dataType : "JSON",
	        success : function(result){
	            grid.resetData(result);
	        } 
	    });
		grid = new tui.Grid({
		    el: document.getElementById("productList"),
		    scrollX: false,
		    scrollY: false,
		    minRowHeight: 80,
		    pageOptions: {  
	    	  centerAlign: true,
		    	useClient: true,
		    	initialRequest: false,
		      perPage: 10 
		    },
		    columns: [
		    		{
		    	    header: '번호',
		    	    name: 'p_idx',
		    	    align: 'center',
		    	    sortable: true,
	    	      sortingType: 'desc',
		    	    width: 50
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
			    	    header: '대분류',
			    	    name: 'c_mainCode',
			    	    align: 'center',
			    	    width: 90,
			    	    sortable: true,
			    	    filter: 'text'
			    	},
		    	  {
			    	    header: '중분류',
			    	    name: 'c_middleCode',
			    	    align: 'center',
			    	    filter: 'text',
			    	    sortable: true,
			    	    width: 90
			    	},
		    	  {
		    	    header: '상품명',
		    	    name: 'p_name',
		    	    editor: 'text',
		    	    filter: 'text',
		    	    sortable: true,
	    	      sortingType: 'desc',
		    	  },
		    	  {
		    	    header: '판매가',
		    	    name: 'p_price',
		    	    editor: 'text',
		    	    align: 'center',
		    	    width: 150,
		    	    filter: 'text',
		    	    sortable: true,
	    	      sortingType: 'desc',
		    	  },
		    	  {
			    	    header: '재고',
			    	    name: 'p_amount',
			    	    align: 'center',
			    	    width: 60,
			    	    editor: 'text',
			    	    filter: 'number',
			    	    sortable: true,
		    	      sortingType: 'desc',
			    	 },
		    	  {
			    	    header: '판매상태',
			    	    name: 'p_sellStatus',
			    	    width: 80,
			    	    align: 'center',
			    	    formatter: 'listItemText',
			    	    editor: {
				    	    type: CustomSelectEditorSellStatus,
				    	    options:{
				    	    	listItems:[
						    	    {text: '노출안함', value: 0},
						    	    {text: '정상판매', value: 1},
						    	    {text: '임시품절', value: 2}
					    	    ],
				    	    },
				    	    useViewMode : true
			    	 		},
		    	 		 validation: {
				    	    	dataType: 'number'
				    	 }
			    	},
			    	{
			    	    header: '수정',
			    	    name: 'productModify',
			    	    align: 'center',
			    	    renderer: {
			    	        type: LinkRenderer
			    	      },
			    	    width: 60
			    	 },
			    	{
			    	    header: '상세',
			    	    name: 'productDelete',
			    	    align: 'center',
			    	    renderer: {
			    	        type: LinkRenderer2
			    	      },
			    	    width: 60
			    	 }
		    ]
		});
		
		

		grid.on('beforeChange', ev => {
			  console.log("변경 전:" + ev.changes[0].value);
			});
		grid.on('afterChange', ev => {
			  /**
			    *   changes: [
			    *      // beforeChange 인 경우에는 value는 현재 값, nextValue는 변경 예정 값(수정 또는 삭제 수행 후 적용될 값)
			    *      { rowKey, columnName, value, nextValue }, ...
			    *
			    *      // afterChange 인 경우에는 value는 변경이 적용된 후 값, prevValue는 이전 셀의 값(beforeChange 의 value와 동일)
			    *      { rowKey, columnName, value, prevValue }, ...
			    *    ]
			    *  }
			    */
			  console.log("rowKey : " + ev.changes[0].rowKey); //행의 번호를 가져옴 
			  console.log("row : " + grid.getRow(ev.changes[0].rowKey)); //행의 번호를 가져옴
			  let obj = grid.getRow(ev.changes[0].rowKey);
			  console.log(JSON.stringify(obj, null, 2));
			  //이 두개를 넘긴다 ---------------------------------
			  console.log("idx 호출 :" + obj.p_idx);
			  console.log("바꾸고자 하는 열 :" + ev.changes[0].columnName);
			  //-----------------------------------------------
			  console.log("변경 후:" +  typeof(ev.changes[0].value));
			  console.log("변경 후:" +  ev.changes[0].value);
			  let msg ="";
			  let iconBtn = "";
			  //변경된 값을 확인하고 해당 값을 변경한다 
				  $.ajax({
					  type:'post',
			　　　　url: '${ctp}/admin/product/productUpdate', 
			　　　　data: {
							updateCol : ev.changes[0].columnName,
							updateVal : ev.changes[0].value + "",
							p_idx : obj.p_idx
						}, 
			　　　　success: function(res) {
					　　　if(res == "0") {
		    				msg = "상품 수정 실패!";
		    				iconBtn="error";
	    				}
		    			else {
		    				msg = "성공적으로 수정되었습니다.";
		    				iconBtn="success";
		    			}
		    			Swal.fire({
		    				width:500,
		    			  position: 'center',
		    			  icon: iconBtn,
		    			  title: msg,
		    			  showConfirmButton: false,
		    			  timer: 1200
		    			});
  						setTimeout(function(){location.reload();},1200);
			　　　　}, 
			　　　　error: function(e) {
			　　　　alert("전송오류:" + e);
	 				}
				  })
			  
			  //수정한 값이 있다면! 변경을 하자... 
			});

	}
	function productModify(idx){
		location.href='${ctp}/admin/product/productUpdate?p_idx='+idx;
	}
	function productDelete(idx){
		Swal.fire({
			  title: '해당 상품을 삭제하시겠습니까?\n 주문이 1회 이상 들어온 상품은 삭제할 수 없습니다.',
			  showDenyButton: true,
			  width:800,
			  confirmButtonColor: 'grey',
			  confirmButtonText: '확인',
			  denyButtonText: '취소',
			}).then((result) => {
			  if (result.isConfirmed) {
			    $.ajax({
			    	type: "post",
			    	data: {p_idx : idx},
						url: "${ctp}/admin/product/productDelete",
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
						else {
							Swal.fire({
								width:500,
							  position: 'center',
							  icon: 'error',
							  title: '이미 주문이 접수된 상품입니다.',
							  showConfirmButton: false,
							  timer: 1500
							})
						}
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

						<div class="col-sm-12 col-xl-12">
							<div class="bg-white rounded-lg h-100 p-4">
								<h5 class="mb-4">상품 조회</h5>
								<div class="mb-3">
									<div class="productList" id="productList"
										style="height: 100%; width: 100%;"></div>
								</div>
							</div>
						</div>

					</div>



				</div>
				<!-- 왼쪽 종료 -->


			</div>
			<!-- 하나로 묶기 위한 row 종료 -->
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

