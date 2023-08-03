<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<head>
<meta charset="utf-8">
<title>PARADICE | 관리자 카테고리 등록</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="" name="keywords">
<meta content="" name="description">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
</head>
<script>
	'use strict';
	
	function addMainCategory(){
		let c_mainCode = mainCategoryInsertForm.c_mainCode.value.trim().toUpperCase();
		let c_mainName = mainCategoryInsertForm.c_mainName.value.trim();
		let msg="";
		let iconBtn="";
		
		if(c_mainCode =="" || c_mainName == ""){
			Swal.fire({
				width:500,
			  position: 'center',
			  icon: 'error',
			  title: '대분류 코드(명)을 입력하세요.',
			  showConfirmButton: false,
			  timer: 1500
			})
			if(c_mainCode =="") mainCategoryInsertForm.c_mainCode.focus();
			else mainCategoryInsertForm.c_mainName.focus();
		}
		
		else{
			$.ajax({
				type : "post",
	    		url  : "${ctp}/admin/product/categoryMainInsert",
	    		data : {
	    			c_mainCode : c_mainCode,
	    			c_mainName : c_mainName
	    		},
	    		success:function(res) {
	    			if(res == "0") {
	    				msg = "이미 대분류가 등록되어 있습니다.\n확인하시고 다시 입력하세요";
	    				iconBtn="error";
	    			}
	    			else {
	    				msg = "대분류가 등록되었습니다.";
	    				iconBtn="success";
	    			}
	    			
	    			Swal.fire({
	    				width:500,
	    			  position: 'center',
	    			  icon: iconBtn,
	    			  title: msg,
	    			  showConfirmButton: false,
	    			  timer: 1500
	    			})
	    			setTimeout(function(){location.reload();},1500);
	    		},
	    		
	  			error: function() {
	  				alert("전송오류!");
	  			}
			});
			
		}
	}
	
	
	function addMiddleCategory(){
		let c_mainCode = middleCategoryInsertForm.c_mainCode.value.trim().toUpperCase();
		let c_middleCode = middleCategoryInsertForm.c_middleCode.value.trim();
		let c_middleName = middleCategoryInsertForm.c_middleName.value.trim();
		let msg="중분류 코드(명)을 입력하세요.";
		let iconBtn="";
		
		if(c_middleCode =="" || c_middleName == "" || c_mainCode == ""){
			if(c_mainCode =="") {
				middleCategoryInsertForm.c_mainCode.focus();
				msg = "대분류 코드를 선택하세요.";
			}
			Swal.fire({
				width:500,
			  position: 'center',
			  icon: 'error',
			  title: msg,
			  showConfirmButton: false,
			  timer: 1500
			})
			if (c_middleCode == "") middleCategoryInsertForm.c_middleCode.focus();
			else middleCategoryInsertForm.c_middleName.focus();
		}
		
		else{
			$.ajax({
					type : "post",
	    		url  : "${ctp}/admin/product/categoryMiddleInsert",
	    		data : {
	    			c_mainCode : c_mainCode,
	    			c_middleCode : c_middleCode,
	    			c_middleName : c_middleName
	    		},
	    		success:function(res) {
	    			if(res == "0") {
	    				msg = "이미 중분류가 등록되어 있습니다.\n확인하시고 다시 입력하세요";
	    				iconBtn="error";
	    			}
	    			else {
	    				msg = "중분류가 등록되었습니다.";
	    				iconBtn="success";
	    			}
	    			
	    			Swal.fire({
	    				width:500,
	    			  position: 'center',
	    			  icon: iconBtn,
	    			  title: msg,
	    			  showConfirmButton: false,
	    			  timer: 1500
	    			})
	    			setTimeout(function(){location.reload();},1500);
	    		},
	    		
	  			error: function() {
	  				alert("전송오류!");
	  			}
			});
			
		}
	}
	
	function middleDelete(c_middleCode){
		Swal.fire({
			  title: '해당 중분류를 삭제하시겠습니까?',
			  showDenyButton: true,
			  confirmButtonText: '확인',
			  denyButtonText: '취소',
			}).then((result) => {
			  if (result.isConfirmed) {
			    $.ajax({
			    	type: "post",
						url: "${ctp}/admin/product/middleDelete",
						data: {c_middleCode: c_middleCode},
						success: function(res){
						if(res==1){
							Swal.fire({
								width:500,
							  position: 'center',
							  icon: 'success',
							  title: '삭제 되었습니다.',
							  showConfirmButton: false,
							  timer: 1000
							})
							setTimeout(function(){location.reload();},1000);
						}
						else{
							Swal.fire({
								width:500,
							  position: 'center',
							  icon: 'error',
							  title: '이미 상품이 등록 되어있는 분류입니다.',
							  showConfirmButton: false,
							  timer: 1000
							})
						}
					}
			    });
			  }
			})
	}
	
	function mainDelete(c_mainCode){
		Swal.fire({
				width:600,
			  title: '대분류 삭제 시 하위 중분류와 상품이 모두 삭제됩니다.\n그래도 삭제하시겠습니까?',
			  showDenyButton: true,
			  confirmButtonText: '확인',
			  denyButtonText: '취소',
			}).then((result) => {
			  if (result.isConfirmed) {
			    $.ajax({
			    	type: "post",
						url: "${ctp}/admin/product/mainDelete",
						data: {c_mainCode: c_mainCode},
						success: function(res){
						if(res==1){
							Swal.fire({
								width:500,
							  position: 'center',
							  icon: 'success',
							  title: '삭제 되었습니다.',
							  showConfirmButton: false,
							  timer: 1000
							})
							setTimeout(function(){location.reload();},1000);
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

						<div class="col-sm-6 col-xl-4 mb-3">
							<div class="bg-white rounded-lg h-100 p-4">
								<h5 class="mb-4">카테고리 목록</h5>
								<div class="mb-3">
									<div class="categoryList">
										<c:forEach var="mainCategory" items="${mainCategoryVos}"
											varStatus="st">
											<div>
												<button class="btn category-title" type="button"
													data-toggle="collapse"
													data-target="#mainCategory${st.index}"
													aria-expanded="false"
													aria-controls="mainCategory${st.index}">
													${mainCategory.c_mainCode} &nbsp;
													${mainCategory.c_mainName}</button>
												<input type="button" class="btn text-danger transBtn"
													value="삭제" style="float: right;"
													onclick="mainDelete('${mainCategory.c_mainCode}')">
												<div class="collapse show" id="mainCategory${st.index}">
													<ul class="list-group middleList">
														<c:forEach var="middleCategory"
															items="${middleCategoryVos}">
															<c:if
																test="${middleCategory.c_mainCode == mainCategory.c_mainCode}">
																<li class="list-group-item list-group-item-action">
																	<font color="red">${middleCategory.c_middleCode}</font>
																	&nbsp; ${middleCategory.c_middleName} <a
																	href="javascript:middleDelete(${middleCategory.c_middleCode})"
																	style="float: right;"><i class="fa-solid fa-trash"></i></a>
																</li>
															</c:if>
														</c:forEach>
													</ul>
												</div>
											</div>
										</c:forEach>
									</div>
								</div>
								<div class="mb-3"></div>
							</div>
						</div>

						<div class="col-sm-6 col-xl-8  h-100">
							<!-- 오른쪽 카테고리 등록부분 -->
							<!-- Form Start -->
							<form name="mainCategoryInsertForm">
								<div class="bg-white rounded-lg p-4 mb-3">
									<h5 class="mb-2">대분류 등록</h5>
									<div class="row">
										<div class="col-sm-6 col-xl-3">
											<input class="form-control admin-input" type="text"
												name="c_mainCode" id="c_mainCode" placeholder="대분류 코드"
												maxlength=1>
										</div>
										<div class="col-sm-6 col-xl-9">
											<input class="form-control admin-input" type="text"
												name="c_mainName" id="c_mainName" placeholder="대분류 명">
										</div>
										<span class="col-sm-6 col-xl-12 mb-3" style="color: #ccc;">대분류
											코드는 영대문자 한 글자로 구성되어야 합니다. (A, B, C, D...)</span>
										<div class="col-sm-6 col-xl-12">
											<input type="button" class="btn btn-round btn-danger mb-3"
												value="대분류 추가" style="float: right;"
												onclick="addMainCategory();">
										</div>
									</div>
								</div>

								<!-- Form End -->
							</form>
							<!-- 오른쪽 카테고리 등록부분2 -->
							<form name="middleCategoryInsertForm">
								<div class="bg-white rounded-lg p-3 mb-3">
									<h5 class="mb-2">중분류 등록</h5>
									<div class="row">
										<div class="col-sm-6 col-xl-4">
											<select name="c_mainCode"
												class="btn admin-input form-control">
												<option value="">중분류 선택</option>
												<c:forEach var="mainCategory" items="${mainCategoryVos}"
													varStatus="st">
													<option value="${mainCategory.c_mainCode}">${mainCategory.c_mainName}</option>
												</c:forEach>
											</select>
										</div>
										<div class="col-sm-6 col-xl-3">
											<input class="form-control admin-input" type="text"
												name="c_middleCode" id="c_middleCode" placeholder="중분류 코드"
												maxlength=2>
										</div>
										<div class="col-sm-6 col-xl-5">
											<input class="form-control admin-input" type="text"
												name="c_middleName" id="c_middleName" placeholder="중분류 명">
										</div>
										<span class="col-sm-6 col-xl-12 mb-3" style="color: #ccc;">중분류
											코드는 숫자 두 글자로 구성되어야 합니다. (01, 02, 03...)</span>
										<div class="col-sm-6 col-xl-12">
											<input type="button" class="btn btn-round btn-danger mb-3"
												value="중분류 추가" style="float: right;"
												onclick="addMiddleCategory();">
										</div>
									</div>
								</div>
								<!-- Form End -->
							</form>

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

