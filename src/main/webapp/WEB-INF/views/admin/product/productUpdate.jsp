<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<c:set var="idx" value="${fn:split(vo.p_image, '/')}" />
<c:set var="info" value="${fn:split(vo.p_info, '/')}" />
<head>
<meta charset="utf-8">
<title>PARADICE | 관리자 상품 수정</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="" name="keywords">
<meta content="" name="description">
<script src="${ctp}/ckeditor/ckeditor.js"></script>
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="${ctp}/js/admin/productUpdate.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery-serialize-object/2.5.0/jquery.serialize-object.min.js"></script>
<script>
 		$(document).ready(function(){
 			let c_mainCode = $("select[name=c_mainCode]").val();
 			$.ajax({
 				type : "post",
 	    		url  : "${ctp}/admin/product/categoryMiddleGet",
 	    		data : {c_mainCode : c_mainCode},
 	    		success: function(vos){
 						let str = '';
 						str = '<option>중분류 선택</option>';
 						for(let i=0; i<vos.length; i++){
 							if(vos[i].c_middleCode == ${vo.c_middleCode}) str += '<option value="'+vos[i].c_middleCode+'" selected>'+vos[i].c_middleName+'</option>'
 							else str += '<option value="'+vos[i].c_middleCode+'">'+vos[i].c_middleName+'</option>'
 						}
 	    			
 	    			$("#c_middleCode").html(str);
 					},
 					error : function() {
 		    			alert("전송오류!");
 		    		}
 			});
 		});
 		
		//대분류 동적 셀렉트 
 		function mainSelect(){
 			let c_mainCode = $("select[name=c_mainCode]").val();
 			$.ajax({
 				type : "post",
 	    		url  : "${ctp}/admin/product/categoryMiddleGet",
 	    		data : {c_mainCode : c_mainCode},
 	    		success: function(vos){
 						let str = '';
 						str = '<option>중분류 선택</option>';
 						for(let i=0; i<vos.length; i++){
 							str += '<option value="'+vos[i].c_middleCode+'">'+vos[i].c_middleName+'</option>'
 						}
 	    			
 	    			$("#c_middleCode").html(str);
 					},
 					error : function() {
 		    			alert("전송오류!");
 		    		}
 			});
 		}
	 		
	 		function addProduct(){
	 			//$('#productInsert')[0]
	 			var formData = new FormData();
	 			let p_image= '';
	 			for(let i=0; i<uploadFiles.length; i++){
	 				formData.append('files',uploadFiles[i])
	 			}
	 			formData.delete('p_image_upload');
	 			formData.delete('p_info_playPersonMin');
	 			formData.delete('p_info_playPersonMax');
	 			formData.delete('p_info_playAge');
	 			formData.delete('p_info_playTime');
	 			updateAllMessageForms();
	 			
	 			let p_info_playPersonMin = productInsert.p_info_playPersonMin.value;
	    	let p_info_playPersonMax = productInsert.p_info_playPersonMax.value;
	    	let p_info_playAge = productInsert.p_info_playAge.value;
	    	let p_info_playTime = productInsert.p_info_playTime.value;
	    	productInsert.p_info.value = p_info_playPersonMin + "/" + p_info_playPersonMax + "/" + p_info_playAge + "/" + p_info_playTime + "/";
				
	    	let images = document.querySelectorAll(".previewImages");
	    	let imgsrc = '';
	    	for(let i=0; i<images.length; i++){
	    		imgsrc += images[i].src.substring(images[i].src.indexOf("product/")+8,images[i].src.length) + "/";
	    	}
	    	console.log(imgsrc);
	    	productInsert.p_image.value = imgsrc;
	    	 
	 			var vo = $('#productInsert').serializeObject();
	 			formData.append('vo', new Blob([JSON.stringify(vo)] , {type: "application/json"}));
	 			for (var value of formData.values()) {
	 				  console.log(value);
	 				}
	 			$.ajax({
						type:'post',
			　　　　enctype:"multipart/form-data",   // 업로드를 위한 필수 파라미터
			　　　　url: '${ctp}/admin/product/productUpdateAll', 
			　　　　data: formData, 
			　　　　processData: false,    // 업로드를 위한 필수 파라미터
			　　　　contentType: false,    // 업로드를 위한 필수 파라미터
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
	    			  timer: 1500
	    			});
					setTimeout(function(){location.reload();},1500);
			　　　　}, 
			　　　　error: function(e) {
			　　　　alert("전송오류:" + e);
			}
		}); 
	 			
	 		}
	 		

	 	 	function thumbnailSelect(image){
		 		document.getElementById("preview").src = image; //e.target.result가 이미지의 주소를 담고 있음 
		 		$("#preview").addClass("w-100 h-100");
	 			$(".message").html("");
	 		}
	 		
	 		function origthumbnailSelect(image){
	 				console.log(image);
	 				document.getElementById("preview").src = "${ctp}/data/product/"+image;
	 		}
	 		
	 		$(document).ready(function(){
	 			if("${idx[0]}"!=null && "${idx[0]}"!="") {
	 				document.getElementById("preview").src = "${ctp}/data/product/${vo.p_thumbnailIdx}"; //e.target.result가 이미지의 주소를 담고 있음 	
		 			$("#preview").addClass("w-100 h-100");
		 			$(".message").html("");
	 			}
	 		});
 		</script>
</head>

<body>
	<div class="container-xxl position-relative bg-white d-flex p-0">
		<!-- Spinner Start -->
		<form id="productInsert" enctype="multipart/form-data">
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

				<!-- Form Start -->
				<div class="row">
					<div class="col-sm-12 col-xl-9">
						<div class="row mb-4">

							<div class="col-sm-6 col-xl-5">
								<div class="bg-white rounded-lg h-100 p-4">
									<h5 class="mb-4">이미지 등록</h5>
									<div class="mb-3">
										<div class="upload-box">
											<div id="drop-file" class="drag-file">
												<img
													src="https://img.icons8.com/pastel-glyph/2x/image-file.png"
													alt="파일 아이콘" class="image" id="preview">
												<p class="message">Drag files to upload</p>
											</div>
										</div>
									</div>
									<div class="mb-3">
										<label class="file-label" for="p_image_upload">Choose
											File</label> <input class="d-none" id="p_image_upload"
											name="p_image_upload" multiple type="file">
									</div>
								</div>
							</div>

							<div class="col-sm-6 col-xl-7">
								<div class="bg-white rounded-lg h-100 p-4">
									<div class="mb-3">
										<h5 class="mb-2">상품 명</h5>
										<input class="form-control admin-input" type="text"
											name="p_name" id="p_name" value="${vo.p_name}"> <span
											style="color: #ccc;">상품 명은 30글자를 초과할 수 없습니다.</span>
									</div>
									<div class="mb-3">
										<h5>가격</h5>

										<div class="row mb-3">
											<div class="col-sm-6 col-xl-6">
												<span>판매가(KRW)</span>
												<div class="input-group">
													<div class="input-group-prepend">
														<span class="input-group-text admin-input">KRW</span> <input
															class="form-control admin-input" type="number"
															name="p_price" id="p_price" value="${vo.p_price}">
													</div>
												</div>
											</div>

											<div class="col-sm-6 col-xl-6">
												<span>정상가(KRW)</span>
												<div class="input-group">
													<div class="input-group-prepend">
														<span class="input-group-text admin-input">KRW</span> <input
															class="form-control admin-input" type="number"
															name="p_origPrice" id="p_origPrice"
															value="${vo.p_origPrice}">
													</div>
												</div>
											</div>
										</div>

										<h5>보유 재고</h5>

										<div class="row mb-3">
											<div class="col-sm-6 col-xl-12">
												<div class="input-group">
													<div class="input-group-prepend">
														<span class="input-group-text admin-input">수량</span> <input
															class="form-control admin-input" type="number"
															name="p_amount" id="p_amount" value="${vo.p_amount}">
													</div>
												</div>
											</div>
										</div>

										<h5>판매 상태</h5>

										<div class="row col-xl-12">
											<div
												class="custom-control custom-radio custom-control-inline">
												<input class="custom-control-input " type="radio"
													name="p_sellStatus" id="p_sellNow0" value="0"
													<c:if test="${vo.p_sellStatus==0}">checked</c:if>>
												<label class="custom-control-label" for="p_sellNow0">노출안함</label>
											</div>
											<div
												class="custom-control custom-radio custom-control-inline ml-3">
												<input class="custom-control-input" type="radio"
													name="p_sellStatus" id="p_sellNow1" value="1"
													<c:if test="${vo.p_sellStatus==1}">checked</c:if>>
												<label class="custom-control-label" for="p_sellNow1">정상판매</label>
											</div>
											<div
												class="custom-control custom-radio custom-control-inline ml-3">
												<input class="custom-control-input" type="radio"
													name="p_sellStatus" id="p_sellNow2" value="2"
													<c:if test="${vo.p_sellStatus==2}">checked</c:if>>
												<label class="custom-control-label" for="p_sellNow2">임시품절</label>
											</div>
										</div>

									</div>
								</div>
							</div>
						</div>


						<!-- 업로드 이미지 프리뷰 구역 -->
						<div class="row mb-3">
							<div class="col-sm-12 col-xl-12">
								<div class="bg-white rounded-lg h-100 p-4">
									<h5 class="mb-4 pb-3">이미지 미리보기</h5>
									<div class="mb-3 d-flex flex-wrap" id="imagesPreview"
										style="overflow: auto;">

										<c:if
											test="${fn:trim(vo.p_image) != '' && vo.p_image != null }">
											<c:forEach var="i" items="${idx}" varStatus="st">
												<div class="previewImage" id="preview${st.index}">
													<div class="previewDelete"
														onclick="previewDelete(${st.index})">
														<i class="fas fa-lg fa-times"></i>
													</div>
													<input type="radio" class="noRadio" name="p_thumbnailIdx"
														value="${idx[st.index]}" id="thumbnail${st.index}"
														<c:if test="${vo.p_thumbnailIdx == idx[st.index]}">checked</c:if>>
													<label class="thumbnailLabel"
														id="thumbnailLabel${st.index}" for="thumbnail${st.index}"
														onclick="origthumbnailSelect('${idx[st.index]}')">
														<img src="${ctp}/data/product/${i}"
														id="previewImage${st.index}" class="previewImages">
													</label>
												</div>
											</c:forEach>
										</c:if>
									</div>
								</div>
							</div>
						</div>


						<div class="row mb-3">
							<div class="col-sm-12 col-xl-12">
								<div class="bg-white rounded-lg h-100 p-4">
									<h5 class="mb-4">상세 설명</h5>
									<div class="mb-3">
										<textarea name="p_content" id="CKEDITOR" class="form-control"
											required> ${vo.p_content}</textarea>
										<script>
										 CKEDITOR.replace("p_content",{
									        	height:300,
									        	enterMode: CKEDITOR.ENTER_BR, // 엔터키를 <br> 로 적용함.
									        	shiftEnterMode: CKEDITOR.ENTER_P,  // 쉬프트 +  엔터를 <p> 로 적용함.
									        	filebrowserUploadUrl:"${ctp}/ckeditor/imageUpload",	/* 파일(이미지) 업로드시 매핑경로 */
									        	uploadUrl : "${ctp}/ckeditor/imageUpload"		/* 여러개의 그림파일을 드래그&드롭해서 올리기 */
									        });
										</script>
									</div>
								</div>
							</div>
						</div>



					</div>
					<!-- 왼쪽 종료 -->

					<div class="col-sm-12 col-xl-3" id="rightPart">
						<div class="bg-white rounded-lg h-100 p-4">
							<h5 class="mb-4">상품 정보</h5>
							<div class="row mb-3 col-xl-12 d-flex flex-column">
								<div>
									<span><font color="red">최소</font> 사용인원</span> <select
										class="btn" id="p_info_playPersonMin">
										<c:forEach var="i" begin="1" end="9" step="1">
											<option <c:if test="${info[0]==i}">selected</c:if>>${i}</option>
										</c:forEach>
									</select>인
								</div>
								<div>
									<span><font color="red">최대</font> 사용인원</span> <select
										class="btn" id="p_info_playPersonMax">
										<c:forEach var="i" begin="1" end="9" step="1">
											<option <c:if test="${info[1]==i}">selected</c:if>>${i}</option>
										</c:forEach>
									</select>인
								</div>
								<div style="display: flex; align-items: center;">
									사용 연령 <input class="col-sm-1 col-xl-4 mr-2 ml-2 admin-input"
										type="number" name="p_info_playAge" id="p_info_playAge"
										value="${info[2]}">세
								</div>
								<div
									style="display: flex; align-items: center; white-space: nowrap;">
									소요 시간 <select class="btn" id="p_info_playTime">
										<c:forEach var="i" begin="5" end="60" step="5">
											<option>${i}</option>
										</c:forEach>
									</select>분
								</div>
							</div>
							<hr>
							<h5 class="mb-4">카테고리</h5>
							<div class="row m-0">
								<div class="mb-3 w-100">
									<select name="c_mainCode" class="btn admin-input form-control"
										onchange="mainSelect()">
										<option value="">대분류 선택</option>
										<c:forEach var="mainCategory" items="${mainCategoryVos}"
											varStatus="st">
											<option value="${mainCategory.c_mainCode}"
												<c:if test="${mainCategory.c_mainCode == vo.c_mainCode}">selected</c:if>>${mainCategory.c_mainName}</option>
										</c:forEach>
									</select>
								</div>
								<div class="mb-3 w-100">
									<select name="c_middleCode" id="c_middleCode"
										class="btn admin-input form-control">
										<option>중분류 선택</option>
									</select>
								</div>
								<input type="hidden" name="p_info" id="p_info"> <input
									type="hidden" name="p_idx" value="${vo.p_idx}"> <input
									type="hidden" name="p_image">
								<hr>
								<input type="button"
									class="btn btn-round btn-secondary form-control mb-3"
									value="미리보기"> <input type="button"
									class="btn btn-round btn-danger form-control mb-3"
									value="상품 수정" onclick="addProduct()">
							</div>
						</div>
					</div>
					<!-- Form End -->


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
		</form>
	</div>
	<!-- Content End -->

	<!-- Back to Top -->
	<a href="#" class="btn btn-lg btn-danger btn-lg-square back-to-top"><i
		class="bi bi-arrow-up"></i></a>

</body>

